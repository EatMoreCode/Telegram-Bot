package Telegram::Bot::Message::Location;

# ABSTRACT: The base class for Telegram message 'Location' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'longitude';
has 'latitude';

sub is_array { return; }

sub fields {
  return { scalar => [qw/longitude latitude/],
         };
}

1;
