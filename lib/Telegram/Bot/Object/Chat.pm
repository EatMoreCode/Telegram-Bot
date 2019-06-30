package Telegram::Bot::Object::Chat;

# ABSTRACT: The base class for Telegram 'Chat' type objects

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

1;
