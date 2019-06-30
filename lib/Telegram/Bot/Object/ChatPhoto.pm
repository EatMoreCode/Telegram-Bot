package Telegram::Bot::Object::ChatPhoto;

# ABSTRACT: The base class for Telegram 'ChatPhoto' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'small_file_id';
has 'big_file_id';

sub fields {
  return {
          'scalar' => [qw/small_file_id big_file_id/],
        };
}

1;
