package Telegram::Bot::Object::PhotoSize;

# ABSTRACT: The base class for Telegram message 'PhotoSize' type.

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'file_id';
has 'width';
has 'height';
has 'file_size';

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

1;
