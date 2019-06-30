package Telegram::Bot::Object::User;

# ABSTRACT: The base class for Telegram message 'User' type.

=head1 SYNOPSIS

    my $user = Telegram::Bot::Object::User->new($hashref);

=head1 DESCRIPTION

See the documenation at L<https://core.telegram.org/bots/api#user>

Typically you would not need to manually create one of these. They will
be returned from the Telegram Bot API.

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
