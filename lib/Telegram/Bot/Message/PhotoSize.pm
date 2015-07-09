package Telegram::Bot::Message::PhotoSize;

# ABSTRACT: The base class for Telegram message 'PhotoSize' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'file_id';
has 'width';
has 'height';
has 'file_size';

sub is_array { return; }

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

1;
