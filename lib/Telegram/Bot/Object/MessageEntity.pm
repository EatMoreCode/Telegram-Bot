package Telegram::Bot::Object::MessageEntity;

# ABSTRACT: The base class for Telegram 'MessageEntity' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#messageentity> for details of the
attributes available for L<Telegram::Bot::Object::MessageEntity> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::User;

has 'type';
has 'offset';
has 'length';
has 'url';
has 'user'; #User

sub fields {
  return {
          'scalar'                      => [qw/type offset length url/],
          'Telegram::Bot::Object::User' => [qw/user/],
        };
}

1;
