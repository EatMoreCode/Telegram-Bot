package Telegram::Bot::Object::ChatMember;

# ABSTRACT: The base class for the Telegram type "ChatMember".

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#chatmember> for details of the
attributes available for L<Telegram::Bot::Object::ChatMember> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

use Telegram::Bot::Object::User;

use Data::Dumper;

# basic message stuff
has 'status'; # String
has 'user';  # User

# has 'is_anonymous'; # Boolean
# has 'custom_title'; # String (Optional)

sub fields {
  return {
          'scalar'                                      => [qw/status/],
          'Telegram::Bot::Object::User'                 => [qw/user/],
  };
}

sub arrays {
}

1;
