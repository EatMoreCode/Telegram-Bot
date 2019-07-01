package Telegram::Bot::Object::KeyboardButton;

# ABSTRACT: The base class for Telegram 'KeyboardButton' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#keyboardbutton> for details of the
attributes available for L<Telegram::Bot::Object::KeyboardButton> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'text';
has 'request_contact';
has 'request_location';

sub fields {
  return { 'scalar' => [qw/text request_contact request_location/],
         };
}

1;
