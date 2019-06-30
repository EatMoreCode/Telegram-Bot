package Telegram::Bot::Object::Contact;

# ABSTRACT: The base class for Telegram 'Contact' objects.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#chat> for details of the
attributes available for L<Telegram::Bot::Object::Contact> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'phone_number';
has 'first_name';
has 'last_name';
has 'user_id';

sub fields {
  return { scalar => [qw/phone_number first_name last_name user_id/],
         };
}

1;
