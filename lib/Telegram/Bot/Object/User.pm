package Telegram::Bot::Object::User;

# ABSTRACT: The base class for Telegram message 'User' type.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#user> for details of the
attributes available for L<Telegram::Bot::Object::User> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'id';
has 'is_bot';
has 'first_name';
has 'last_name';     # optional
has 'username';      # optional
has 'language_code'; # optional

sub fields {
  return { scalar => [qw/id is_bot first_name last_name username language_code/]
         };
}

1;
