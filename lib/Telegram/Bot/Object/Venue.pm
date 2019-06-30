package Telegram::Bot::Object::Venue;

# ABSTRACT: The base class for Telegram 'LoginUrl' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::Location;

has 'location'; #Location
has 'title';
has 'address';
has 'foursquare_id';
has 'foursquare_type';

sub fields {
  return { 'scalar'                           => [qw/title address
                                                     foursquare_id foursquare_type/],
            'Telegram::Bot::Object::Location' => [qw/location/] };

}

1;
