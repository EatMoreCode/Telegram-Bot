package Telegram::Bot::Message::Group;

# ABSTRACT: The base class for Telegram message 'Group' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'id';
has 'title';

sub fields {
  return { scalar => [qw/id title/]
         };
}

sub is_group { 1 }
sub is_user  { 0 }

1;
