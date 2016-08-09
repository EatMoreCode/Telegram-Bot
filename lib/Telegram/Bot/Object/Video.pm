package Telegram::Bot::Object::Video;

# ABSTRACT: The base class for Telegram 'Video' object.

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'file_id';
has 'width';
has 'height';
has 'duration';
has 'thumb';
has 'mime_type';
has 'file_size';
has 'caption';

sub fields {
  return { scalar => [qw/file_id width height duration mime_type file_size caption/],
           'Telegram::Bot::Message::PhotoSize' => [qw/thumb/]
         };
}

1;
