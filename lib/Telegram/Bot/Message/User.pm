package Telegram::Bot::Message::User;

# ABSTRACT: The base class for Telegram message 'User' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'id';
has 'first_name';
has 'last_name';
has 'username';

sub is_array { return; }

sub fields {
  return { scalar => [qw/id first_name last_name username/]
         };
}

sub is_group { 0 }
sub is_user  { 1 }

1;
