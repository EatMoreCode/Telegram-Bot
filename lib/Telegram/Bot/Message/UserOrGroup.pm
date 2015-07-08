package Telegram::Bot::Message::UserOrGroup;

# ABSTRACT: The base class for Telegram message 'User' type.

use Mojo::Base 'Telegram::Bot::Message';

use Telegram::Bot::Message::User;
use Telegram::Bot::Message::Group;



sub create_from_hash {
  my $class = shift;
  my $hash  = shift;
  if ($hash->{id} < 0) {
    return Telegram::Bot::Message::Group->create_from_hash($hash);
  }
  else {
    return Telegram::Bot::Message::User->create_from_hash($hash);
  }
}
    

1;
