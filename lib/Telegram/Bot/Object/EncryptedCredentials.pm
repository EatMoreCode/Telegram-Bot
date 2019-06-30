package Telegram::Bot::Object::EncryptedCredentials;

# ABSTRACT: The base class for Telegram 'EncryptedCredentials' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'data';
has 'hash';
has 'secret';

sub fields {
  return { 'scalar' => [qw/ data hash secret/] };
}

1;
