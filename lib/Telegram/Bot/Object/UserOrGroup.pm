package Telegram::Bot::Object::UserOrGroup;

# ABSTRACT: The base class for Telegram message 'User' type.

use Mojo::Base 'Telegram::Bot::Object::Base';

use Telegram::Bot::Object::User;
use Telegram::Bot::Object::Group;

sub is_array { return; }

sub create_from_hash {
  my $class = shift;
  my $hash  = shift;
  if ($hash->{id} < 0) {
    return Telegram::Bot::Object::Group->create_from_hash($hash);
  }
  else {
    return Telegram::Bot::Object::User->create_from_hash($hash);
  }
}


1;
