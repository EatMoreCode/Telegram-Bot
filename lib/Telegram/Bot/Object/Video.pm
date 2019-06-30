package Telegram::Bot::Object::Video;

# ABSTRACT: The base class for Telegram 'Video' object.

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#video> for details of the
attributes available for L<Telegram::Bot::Object::Video> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PhotoSize;

has 'file_id';
has 'width';
has 'height';
has 'duration';
has 'thumb'; #PhotoSize
has 'mime_type';
has 'file_size';

sub fields {
  return { scalar                             => [qw/file_id width height duration
                                                     mime_type file_size /],
           'Telegram::Bot::Object::PhotoSize' => [qw/thumb/]
         };
}

1;
