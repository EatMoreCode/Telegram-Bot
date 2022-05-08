package Telegram::Bot::Object::CallbackQuery;

# ABSTRACT: The base class for the Telegram type "CallbackQuery".

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#callbackquery> for details of the
attributes available for L<Telegram::Bot::Object::CallbackQuery> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

use Telegram::Bot::Object::User;
use Telegram::Bot::Object::Message;

use Data::Dumper;

# basic message stuff
has 'id'; # String
has 'from';  # User
has 'message'; # Message

has 'inline_message_id'; # String
has 'chat_instance'; # String
has 'data'; # String

has 'game_short_name'; # String

sub fields {
  return {
          'scalar'                                      => [qw/id inline_message_id chat_instance data game_short_name/],
          'Telegram::Bot::Object::User'                 => [qw/from/],

          'Telegram::Bot::Object::Message'              => [qw/message/],
  };
}

sub arrays {
}

=method

A convenience method to respond to a keyboard prompt.

=cut

sub answer {
  my $self = shift;
  my $text = shift;
  return $self->_brain->answerCallbackQuery({callback_query_id => $self->id, text => $text, cache_time => 3600});
}

1;
