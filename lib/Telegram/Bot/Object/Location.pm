package Telegram::Bot::Object::Location;

# ABSTRACT: The base class for Telegram message 'Location' type.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#location> for details of the
attributes available for L<Telegram::Bot::Object::Location> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'longitude';
has 'latitude';

sub fields {
  return { scalar => [qw/longitude latitude/],
         };
}

1;
