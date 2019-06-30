package Telegram::Bot::Object::InlineKeyboardMarkup;

# ABSTRACT: The base class for Telegram 'InlineKeyboardMarkup' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#inlinekeyboardmarkup> for details of the
attributes available for L<Telegram::Bot::Object::InlineKeyboardMarkup> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::InlineKeyboardButton;

has 'inline_keyboard';

sub fields {
  return { 'Telegram::Bot::Object::InlineKeyboardButton' => [qw/inline_keyboard/],
         };
}

sub array_of_arrays {
  qw/inline_keyboard/;
}

1;
