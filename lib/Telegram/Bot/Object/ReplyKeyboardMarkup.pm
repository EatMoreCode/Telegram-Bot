package Telegram::Bot::Object::ReplyKeyboardMarkup;

# ABSTRACT: The base class for Telegram 'ReplyKeyboardMarkup' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#replykeyboardmarkup> for details of the
attributes available for L<Telegram::Bot::Object::InlineKeyboardMarkup> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::KeyboardButton;

has 'keyboard';
has 'resize_keyboard';
has 'one_time_keyboard';
has 'selective';

sub fields {
  return { 'scalar' => [qw/resize_keyboard one_time_keyboard selective/],
           'Telegram::Bot::Object::KeyboardButton' => [qw/keyboard/],
         };
}

sub array_of_arrays {
  qw/keyboard/;
}

1;
