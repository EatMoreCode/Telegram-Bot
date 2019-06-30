package Telegram::Bot::Object::EncryptedCredentials;

# ABSTRACT: The base class for Telegram 'EncryptedCredentials' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#encryptedcredentials> for details of the
attributes available for L<Telegram::Bot::Object::EncryptedCredentials> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'data';
has 'hash';
has 'secret';

sub fields {
  return { 'scalar' => [qw/ data hash secret/] };
}

1;
