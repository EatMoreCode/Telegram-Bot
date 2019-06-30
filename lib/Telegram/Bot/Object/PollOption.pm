package Telegram::Bot::Object::PollOption;

# ABSTRACT: The base class for Telegram 'PollOption' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'text';
has 'voter_count';

sub fields {
  return { scalar  => [qw/text voter_count/],
         };
}

1;
