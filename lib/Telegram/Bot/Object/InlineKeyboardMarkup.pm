package Telegram::Bot::Object::InlineKeyboardMarkup;

# ABSTRACT: The base class for Telegram 'InlineKeyboardMarkup' type objects

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
