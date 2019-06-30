package Telegram::Bot::Object::VideoNote;

# ABSTRACT: The base class for Telegram 'VideoNote' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;


has 'file_id';
has 'length';
has 'duration';
has 'mime_type';
has 'thumb'; #PhotoSize
has 'file_size';

sub fields {
  return { scalar                             => [qw/file_id length duration mime_type file_size/],
           'Telegram::Bot::Object::PhotoSize' => [qw/thumb /],

         };
}

1;
