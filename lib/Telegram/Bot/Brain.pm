package Telegram::Bot::Brain;

# ABSTRACT: A base class brain for your Telegram bot

=head1 SYNOPSIS

  package MyApp::Coolbot;

  use Mojo::Base 'Telegram::Bot::Brain';

  has token       => 'token-you-got-from-@botfather';

  sub init {
      my $self = shift;
      $self->add_repeating_task(600, \&timed_task);
      $self->add_responder(qr/start/i, \&respond_to_start_command);
  }

Elsewhere....

  my $bot = MyApp::Coolbot->new();
  $bot->think;  # this will block unless there is already an event
                # loop running

=head1 DESCRIPTION

This base class makes it easy to create your own Bot classes that
interface with the Telegram Bot API.

Internally it uses the Mojo::IOLoop event loop to provide non-blocking
access to the Bot API, allowing your bot to listen for events via the
longpoll getUpdates API method and also trigger timed events that can
run without blocking.

=head1 SEE ALSO

=for :list
* L<Mojolicious>
* L<https://core.telegram.org/bots>

=cut

use Mojo::Base -base;
use Carp qw/croak/;
use Log::Any;
use Telegram::Bot::Message;
use Data::Dumper;

# base class for building telegram robots with Mojolicious
has longpoll_time => 60;
has ua         => sub { Mojo::UserAgent->new->inactivity_timeout(shift->longpoll_time + 15) };
has token      => sub { croak "why you no override??"; };

has tasks      => sub { [] };
has responders => sub { [] };

has log        => sub { Log::Any->get_logger };

=method add_repeating_task

This method will add a sub to run every C<$seconds> seconds.

=cut

sub add_repeating_task {
  my $self    = shift;
  my $seconds = shift;
  my $task    = shift;

  my $repeater = sub {

      # Perform operation every $seconds seconds
      my $last_check = time();
      Mojo::IOLoop->recurring(0.1 => sub {
                                  my $loop = shift;
                                  my $now  = time();
                                  return unless ($now - $last_check) >= $seconds;
                                  $last_check = $now;
                                  $task->($self);
                              });
  };

  # keep a copy
  push @{ $self->tasks }, $repeater;

  # kick it off
  $repeater->();
}

=method add_responder

Respond to text message to our bot.

=cut

sub add_responder {
  my $self = shift;
  my $re   = shift;
  my $code = shift;

  push @{ $self->{responders} }, { re => $re, code => $code };
}

=method send_message_to_chat_id

Send a text message to a chat_id (group or individual).

=cut

sub send_message_to_chat_id {
  my $self    = shift;
  my $chat_id = shift;
  my $message = shift;

  my $token = $self->token;
  my $msgURL = "https://api.telegram.org/bot${token}/sendMessage";

  $self->ua->post($msgURL, form => { chat_id => $chat_id, text => $message });
}

sub add_getUpdates_handler {
  my $self = shift;

  my $http_active = 0;
  my $last_update_id = -1;
  my $token  = $self->token;

  Mojo::IOLoop->recurring(0.1 => sub {
    # do nothing if our previous longpoll is still going
    return if $http_active;

    my $offset = $last_update_id + 1;
    my $updateURL = "https://api.telegram.org/bot${token}/getUpdates?offset=${offset}&timeout=60";
    $http_active = 1;

    $self->ua->get($updateURL => sub {
      my ($ua, $tx) = @_;
      my $res = $tx->res->json;
      my $items = $res->{result};
      foreach my $item (@$items) {
        $last_update_id = $item->{update_id};
        $self->process_message($item);
      }

      $http_active = 0;
    });
  });
}

sub process_message {
    my $self = shift;
    my $item = shift;

    my $msg = Telegram::Bot::Message->create_from_hash($item->{message});
    warn Dumper($msg);

    # foreach my $potential_responder (@$responders) {
    # }
}

sub think {
  my $self = shift;
  $self->init();

  $self->add_getUpdates_handler;
  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

1;
