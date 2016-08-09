package Telegram::Bot::Object::Location;

# ABSTRACT: The base class for Telegram message 'Location' type.

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'longitude';
has 'latitude';

sub fields {
  return { scalar => [qw/longitude latitude/],
         };
}

1;
