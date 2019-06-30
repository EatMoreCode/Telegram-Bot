package Telegram::Bot::Object::Chat;

# ABSTRACT: The base class for Telegram 'Chat' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#chat> for details of the
attributes available for L<Telegram::Bot::Object::Chat> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::ChatPhoto;
use Telegram::Bot::Object::Message;

has 'id';
has 'type';
has 'title';
has 'username';
has 'first_name';
has 'last_name';
has 'all_members_are_administrators';
has 'photo'; #ChatPhoto
has 'description';
has 'invite_link';
has 'pinned_message'; #Message
has 'sticker_set_name';
has 'can_set_sticker_set';

sub fields {
  return {
          'scalar'                           => [qw/id type title username first_name
                                                    last_name all_members_are_administrators
                                                    description invite_link sticker_set_name
                                                    can_set_sticker_set/],
          'Telegram::Bot::Object::ChatPhoto' => [qw/photo/],
          'Telegram::Bot::Object::Message'   => [qw/pinned_message/],
        };
}

=method is_user

Returns true is this is a chat is a single user.

=cut

sub is_user {
  shift->id > 0;
}

=method is_group

Returns true if this is a chat is a group.

=cut

sub is_group {
  shift->id < 0;
}

1;
