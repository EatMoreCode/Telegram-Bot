package Telegram::Bot::Brain;

# ABSTRACT: A base class to make your very own Telegram bot

=head1 SYNOPSIS

  package MyApp::Coolbot;

  use Mojo::Base 'Telegram::Bot::Brain';

  has token       => 'token-you-got-from-@botfather';

  sub init {
      my $self = shift;
      $self->add_repeating_task(600, \&timed_task);
      $self->add_listener(\&criteria, \&response);
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
use Mojo::IOLoop;
use Mojo::UserAgent;
use Carp qw/croak/;
use Log::Any;
use Telegram::Bot::Message;
use Data::Dumper;

# base class for building telegram robots with Mojolicious
has longpoll_time => 60;
has ua         => sub { Mojo::UserAgent->new->inactivity_timeout(shift->longpoll_time + 15) };
has token      => sub { croak "you need to supply your own token"; };

has tasks      => sub { [] };
has listeners  => sub { [] };

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

=method add_listener

Respond to messages we receive. It takes two arguments

=for :list
* a CODEREF to be executed to evaluate if we should respond to this message
    or
  a regular expression to be matched against
* a CODEREF to be executed if the previous criteria was true
* an optional hashref of arguments
=end

Each CODEREF is passed two arguments, this C<Telegram::Bot::Brain> object, and
the C<Telegram::Bot::Message> object, the message that was sent to us.

=cut

sub add_listener {
  my $self = shift;
  my $crit = shift;
  my $resp = shift;
  my $args = shift || {};

  if (ref $crit eq 'Regexp') {
    my $regex = qr/$crit/;
    my $new_crit = sub {
      my ($self, $msg) = @_;
      return if ! defined $msg->text;
      return $msg->text =~ $regex;
    };
    $crit = $new_crit;
  }

  push @{ $self->listeners }, { criteria => $crit, response => $resp };
}

=method send_to_chat_id

Send a pre-constructed message (some subclass of L<Telegram::Bot::Message>) to a chat id.

=cut

sub send_to_chat_id {
  my $self    = shift;
  my $chat_id = shift;
  my $message = shift;
  my $args    = shift || {};

  my $token = $self->token;
  my $method = $message->send_method;
  my $msgURL = "https://api.telegram.org/bot${token}/send". $method;

  my $tx = $self->ua->post($msgURL, form => { chat_id => $chat_id, %{ $message->as_hashref }, %$args});
  if (my $res = $tx->success) { return $tx->res->json->{result}; }
  else {
    my $err = $tx->error;
    die "$err->{code} response: $err->{message}\nBody: " . $tx->res->body if $err->{code};
    die "Connection error: $err->{message}\nBody: " . $tx->res->body;
  }
}

=method send_message_to_chat_id

Send a plain text message to a chat_id (group or individual).

Can be passed an optional hashref which is passed directly to the Telegram Bot API, for extra
arguments like C<parse_mode> and so on.

   $self->send_message_to_chat_id($msg->chat->id, "<pre>$text</pre>", { parse_mode => 'HTML' });

=cut

sub send_message_to_chat_id {
  my $self    = shift;
  my $chat_id = shift;
  my $message = shift;
  my $args    = shift || {};

  my $token = $self->token;
  my $msgURL = "https://api.telegram.org/bot${token}/sendMessage";

  my $tx = $self->ua->post($msgURL, form => { %$args, chat_id => $chat_id, text => $message });
  if (my $res = $tx->success) { return $tx->res->json->{result}; }
  else {
    my $err = $tx->error;
    die "$err->{code} response: $err->{message}\nBody: " . $tx->res->body if $err->{code};
    die "Connection error: $err->{message}\nBody: " . $tx->res->body;
  }
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

    foreach my $potential_listener (@{ $self->listeners }) {
      my $criteria = $potential_listener->{criteria};
      my $response = $potential_listener->{response};
      if ($criteria->($self, $msg)) {
        # passed the criteria check, run the response
        $response->($self, $msg);
        # last if ($.....   check if we should stop looking at responses
      }
    }
}

sub think {
  my $self = shift;
  $self->init();

  $self->add_getUpdates_handler;
  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

1;
