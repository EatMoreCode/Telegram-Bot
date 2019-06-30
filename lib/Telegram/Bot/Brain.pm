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

use strict;
use warnings;

use Mojo::IOLoop;
use Mojo::UserAgent;
use Carp qw/croak/;
use Log::Any;
use Data::Dumper;

use Telegram::Bot::Object::Message;

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
* CODEREF or regular expression
The coderef should return a true or false value, based on the input message. It is called
as an object method on your subclass, with the first argument being the message object.
If you instead supply a regular expression, the message object's text component is checked
against it.
* CODEREF to be executed if the previous criteria was true
As above, it is called as an object method, and the first argument is the message object
that you are responding to.
* an optional hashref of arguments

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

=method getMe

See L<https://core.telegram.org/bots/api#getme>.

Takes no arguments, and returns the L<Telegram::Bot::Object::User> that
represents this bot.

=cut

sub getMe {
  my $self = shift;
  my $token = $self->token;

  my $url = "https://api.telegram.org/bot${token}/getMe";
  my $api_response = $self->_post_request($url);

  return Telegram::Bot::Object::User->create_from_hash($api_response);
}

=method sendMessage

See L<https://core.telegram.org/bots/api#sendmessage>.

=cut

sub sendMessage {
  my $self = shift;
  my $args = shift || {};
  my $send_args = {};
  croak "no chat_id supplied" unless $args->{chat_id};
  $send_args->{chat_id} = $args->{chat_id};

  croak "no text supplied"    unless $args->{text};
  $send_args->{text}    = $args->{text};

  # these are optional, send if they are supplied
  $send_args->{parse_mode} = $args->{parse_mode} if exists $args->{parse_mode};
  $send_args->{disable_web_page_preview} = $args->{disable_web_page_preview} if exists $args->{disable_web_page_preview};
  $send_args->{disable_notification} = $args->{disable_notification} if exists $args->{disable_notification};
  $send_args->{reply_to_message_id}  = $args->{reply_to_message_id}  if exists $args->{reply_to_message_id};

  # check reply_markup is the right kind
  if (exists $args->{reply_markup}) {
    my $reply_markup = $args->{reply_markup};
    die "bad reply_markup supplied"
      if ( ref($reply_markup) ne 'Telegram::Bot::Object::InlineKeyboardMarkup' &&
           ref($reply_markup) ne 'Telegram::Bot::Object::ReplyKeyboardMarkup'  &&
           ref($reply_markup) ne 'Telegram::Bot::Object::ReplyKeyboardRemove'  &&
           ref($reply_markup) ne 'Telegram::Bot::Object::ForceReply' );
    $send_args->{reply_markup} = $reply_markup;
  }

  my $token = $self->token;
  my $url = "https://api.telegram.org/bot${token}/sendMessage";
  my $api_response = $self->_post_request($url, $send_args);

  return Telegram::Bot::Object::Message->create_from_hash($api_response);
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

  my $res = $self->ua->post($msgURL, form => { chat_id => $chat_id, %{ $message->as_hashref }, %$args})->result;
  if    ($res->is_success) { return $res->json->{result}; }
  elsif ($res->is_error)   { die "Failed to post: " . $res->message; }
  else                     { die "Not sure what went wrong"; }
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

  my $res = $self->ua->post($msgURL, form => { %$args, chat_id => $chat_id, text => $message })->result;
  if    ($res->is_success) { return $res->json->{result}; }
  elsif ($res->is_error)   { die "Failed to post: " . $res->message; }
  else                     { die "Not sure what went wrong"; }
}

=method edit_message

See Telegram Bot API for editMessageText.

Edits a previously sent message.

=cut

sub edit_message {
  my $self    = shift;
  my $message = shift;
  my $args    = shift || {};

  unless ($args->{inline_message_id} ||
          ($args->{chat_id} && $args->{message_id})) {
    croak "you need to set either inline_message_id or chat_id and message_id";
  }

  croak "you must supply the new text" unless $message;

  my $token = $self->token;
  my $msgURL = "https://api.telegram.org/bot${token}/editMessageText";

  my $res = $self->ua->post($msgURL, form => { %$args, text => $message })->result;
  if    ($res->is_success) { return $res->json->{result}; }
  elsif ($res->is_error)   { die "Failed to post: " . $res->message, $res->body; }
  else                     { die "Not sure what went wrong"; }
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

# process a message which arrived via getUpdates
sub process_message {
    my $self = shift;
    my $item = shift;

    use Data::Dumper; warn "GOT:" . Dumper($item);
    my $update_id = $item->{update_id};
    # There can be several types of responses. But only one response.
    # https://core.telegram.org/bots/api#update
    my $update;
    $update = Telegram::Bot::Object::Message->create_from_hash($item->{message})             if $item->{message};
    $update = Telegram::Bot::Object::Message->create_from_hash($item->{edited_message})      if $item->{edited_message};
    $update = Telegram::Bot::Object::Message->create_from_hash($item->{channel_post})        if $item->{channel_post};
    $update = Telegram::Bot::Object::Message->create_from_hash($item->{edited_channel_post}) if $item->{edited_channel_post};

    # if we got to this point without creating a response, it must be a type we
    # don't handle yet
    if (! $update) {
      die "Do not know how to handle this update: " . Dumper($item);
    }

    foreach my $potential_listener (@{ $self->listeners }) {
      my $criteria = $potential_listener->{criteria};
      my $response = $potential_listener->{response};
      if ($criteria->($self, $update)) {
        # passed the criteria check, run the response
        $response->($self, $update);
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

sub _post_request {
  my $self = shift;
  my $url  = shift;
  my $form_args = shift || {};

  my $res = $self->ua->post($url, form => $form_args)->result;
  if    ($res->is_success) { return $res->json->{result}; }
  elsif ($res->is_error)   { die "Failed to post: " . $res->message; }
  else                     { die "Not sure what went wrong"; }
}


1;
