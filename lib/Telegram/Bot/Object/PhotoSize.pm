package Telegram::Bot::Object::PhotoSize;

# ABSTRACT: The base class for Telegram message 'PhotoSize' type.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#photosize> for details of the
attributes available for L<Telegram::Bot::Object::PhotoSize> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Carp qw/croak/;

has 'file_id';
has 'width';
has 'height';
has 'file_size';

sub fields {
  return { scalar => [qw/file_id width height file_size/]
         };
}

1;
