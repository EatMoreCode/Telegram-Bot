package Telegram::Bot::Object::Sticker;

# ABSTRACT: The base class for Telegram message 'Sticker' type.

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;

has 'file_id';
has 'width';
has 'height';
has 'thumb';
has 'file_size';
has 'emoji';

sub fields {
  return { scalar => [qw/file_id width height file_size emoji/],
           object => [ { thumb => 'Telegram::Bot::Object::PhotoSize' } ],
           array  => [ ],
         };
}

1;
