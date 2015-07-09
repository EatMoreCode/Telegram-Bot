package Telegram::Bot::Message::Contact;

# ABSTRACT: The base class for Telegram message 'Contact' type.

use Mojo::Base 'Telegram::Bot::Message';

has 'phone_number';
has 'first_name';
has 'last_name';
has 'user_id';

sub is_array { return; }

sub fields {
  return { scalar => [qw/phone_number first_name last_name user_id/],
         };
}

1;
