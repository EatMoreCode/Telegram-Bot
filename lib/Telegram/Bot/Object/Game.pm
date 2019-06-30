package Telegram::Bot::Object::Game;

# ABSTRACT: The base class for Telegram message 'Game' type.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#game> for details of the
attributes available for L<Telegram::Bot::Object::Game> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;
use Telegram::Bot::Object::Animation;
use Telegram::Bot::Object::MessageEntity;

has 'title';
has 'description';
has 'photo'; # Array of PhotoSize
has 'text';
has 'text_entities'; #Array of MessageEntity
has 'animation'; #Animation

sub fields {
  return { scalar                                 => [qw/title description text/],
           'Telegram::Bot::Object::PhotoSize'     => [qw/photo/],
           'Telegram::Bot::Object::MessageEntity' => [qw/text_entities/],
           'Telegram::Bot::Object::Animation'     => [qw/animation/],
         };
}

sub arrays { qw/photo text_entities/ }

1;
