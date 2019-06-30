package Telegram::Bot::Object::EncryptedPassportElement;

# ABSTRACT: The base class for Telegram 'EncryptedPassportElement' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

# XXX Implement rest of this
# https://core.telegram.org/bots/api#encryptedpassportelement

has 'type';
has 'data';
has 'phone_number';
has 'email';

# XXX more here

sub fields {
  return { 'scalar' => [qw/type data phone_number email/] };
}

1;
