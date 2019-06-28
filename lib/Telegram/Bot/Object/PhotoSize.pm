package Telegram::Bot::Object::PhotoSize;

# ABSTRACT: The base class for Telegram message 'PhotoSize' type.

use Mojo::Base 'Telegram::Bot::Object::Base';
use Carp qw/croak/;

has 'file_id';
has 'width';
has 'height';
has 'file_size';

has 'image';

sub is_array { 1 }

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

sub as_hashref {
  my $self = shift;
  my $hash = {};
  if ($self->image) {
    croak "no such file '". $self->image . "'." unless -e $self->image;
    $hash->{photo} = { file => $self->image };
  }

  return $hash;
}

sub send_method {
  return "Photo";
}

1;
