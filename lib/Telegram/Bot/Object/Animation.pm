package Telegram::Bot::Object::Animation;

# ABSTRACT: The base class for Telegram message 'Animation' type.

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;
use Carp qw/croak/;

has 'file_id';
has 'width';
has 'height';
has 'duration';
has 'thumb'; #PhotoSize
has 'file_name';
has 'mime_type';
has 'file_size';

sub fields {
  return { scalar => [qw/file_id width height duration file_name mime_type file_size/],
           'Telegram::Bot::Object::PhotoSize' => [qw/thumb/],
         };
}


1;
