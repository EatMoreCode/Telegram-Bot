package Telegram::Bot::Object::ChatPhoto;

# ABSTRACT: The base class for Telegram 'ChatPhoto' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#chatphoto> for details of the
attributes available for L<Telegram::Bot::Object::ChatPhoto> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'small_file_id';
has 'big_file_id';

sub fields {
  return {
          'scalar' => [qw/small_file_id big_file_id/],
        };
}

1;
