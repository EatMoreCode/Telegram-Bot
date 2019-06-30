package Telegram::Bot::Object::Sticker;

# ABSTRACT: The base class for Telegram message 'Sticker' type.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#sticker> for details of the
attributes available for L<Telegram::Bot::Object::Sticker> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;

has 'file_id';
has 'width';
has 'height';
has 'thumb'; # PhotoSize
has 'emoji';
has 'set_name';
# has 'mask_position'; # XXX TODO
has 'file_size';

sub fields {
  return { scalar                             => [qw/file_id width height emoji
                                                     set_name file_size /],
           'Telegram::Bot::Object::PhotoSize' => [ qw/thumb/ ],
         };
}

1;
