package Telegram::Bot::Object::Audio;

# ABSTRACT: The base class for Telegram 'Audio' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#audio> for details of the
attributes available for L<Telegram::Bot::Object::Audio> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'file_id';
has 'duration';
has 'performer';
has 'title';
has 'mime_type';
has 'file_size';
has 'thumb'; #PhotoSize

sub fields {
  return { scalar => [qw/file_id duration performer title mime_type file_size/],
           'Telegram::Bot::Object::PhotoSize' => [qw/thumb/],
         };
}

1;
