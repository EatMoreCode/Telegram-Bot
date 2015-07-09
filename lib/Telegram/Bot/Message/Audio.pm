package Telegram::Bot::Message::Audio;

# ABSTRACT: The base class for Telegram message 'Audio' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'file_id';
has 'duration';
has 'mime_type';
has 'file_size';

sub is_array { return; }

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

1;
