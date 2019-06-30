package Telegram::Bot::Object::InlineKeyboardButton;

# ABSTRACT: The base class for Telegram 'InlineKeyboardButton' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::LoginUrl;
use Telegram::Bot::Object::CallbackGame;


has 'text';
has 'url';
has 'login_url'; #LoginUrl
has 'callback_data';
has 'switch_inline_query';
has 'switch_inline_query_current_chat';
has 'callback_game'; # CallbackGame
has 'pay';

sub fields {
  return { 'scalar' => [qw/text url callback_data switch_inline_query
                           switch_inline_query_current_chat switch_inline_query_current_chat
                           pay/],
  'Telegram::Bot::Object::LoginUrl'    => [qw/login_url/],
  'Telegram::Bot::Object::CallbackGame'=> [qw/callback_game/],
         };
}

1;
