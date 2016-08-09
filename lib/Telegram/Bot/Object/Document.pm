package Telegram::Bot::Object::Document;

# ABSTRACT: The base class for Telegram 'Document' objects

use Mojo::Base 'Telegram::Bot::Object::Base';

use Telegram::Bot::Object::PhotoSize;

has 'file_id';
has 'thumb';
has 'file_name';
has 'mime_type';
has 'file_size';

sub is_array { return; }

sub fields {
  return { scalar => [qw/file_id file_name mime_type file_size/],
           'Telegram::Bot::Message::PhotoSize' => [qw/thumb/]
         };
}

1;
