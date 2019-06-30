package Telegram::Bot::Object::PassportData;

# ABSTRACT: The base class for Telegram 'PassportData' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::EncryptedPassportElement;
use Telegram::Bot::Object::EncryptedCredentials;

has 'data'; # Array of EncryptedPassportElement
has 'credentials'; # EncryptedCredentials

sub fields {
  return { 'Telegram::Bot::Object::EncryptedPassportElement' => [qw/data/],
           'Telegram::Bot::Object::EncryptedCredentials'     => [qw/credentials/],
         };
}
sub arrays {
  qw/data/;
}

1;
