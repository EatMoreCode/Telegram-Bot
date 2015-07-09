package Telegram::Bot::Message::Video;

# ABSTRACT: The base class for Telegram message 'Video' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'file_id';
has 'width';
has 'height';
has 'duration';
has 'thumb';
has 'mime_type';
has 'file_size';
has 'caption';

sub is_array { return; }

sub fields {
  return { scalar => [qw/file_id width height duration mime_type file_size caption/],
           'Telegram::Bot::Message::PhotoSize' => [qw/thumb/]
         };
}

1;
