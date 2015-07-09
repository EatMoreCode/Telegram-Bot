package Telegram::Bot::Message::Sticker;

# ABSTRACT: The base class for Telegram message 'Sticker' type.

use Mojo::Base 'Telegram::Bot::Message';
use Telegram::Bot::Message::PhotoSize;

has 'file_id';
has 'width';
has 'height';
has 'thumb';
has 'file_size';

sub is_array { return; }

sub fields {
  return { scalar => [qw/file_id width height file_size/],
           'Telegram::Bot::Message::PhotoSize' => [qw/thumb/] 
         };
}

1;
