package Telegram::Bot::Object::Audio;

# ABSTRACT: The base class for Telegram 'Audio' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'file_id';
has 'duration';
has 'mime_type';
has 'file_size';

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

1;
