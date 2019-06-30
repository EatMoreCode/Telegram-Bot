package Telegram::Bot::Object::Voice;

# ABSTRACT: The base class for Telegram 'Voice' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#voice> for details of the
attributes available for L<Telegram::Bot::Object::Voice> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'file_id';
has 'duration';
has 'mime_type';
has 'file_size';

sub fields {
  return { scalar => [qw/file_id duration mime_type file_size/]
         };
}

1;
