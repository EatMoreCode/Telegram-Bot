package Telegram::Bot::Object::Venue;

# ABSTRACT: The base class for Telegram 'LoginUrl' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#venue> for details of the
attributes available for L<Telegram::Bot::Object::Venue> objects.

=cut

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
