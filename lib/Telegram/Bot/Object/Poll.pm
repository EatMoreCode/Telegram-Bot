package Telegram::Bot::Object::Poll;

# ABSTRACT: The base class for Telegram 'Poll' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
use Telegram::Bot::Object::PollOption;


has 'id';
has 'question';
has 'options'; # Array of PollOption
has 'is_closed';

sub fields {
  return { scalar                              => [qw/id question is_closed/],
           'Telegram::Bot::Object::PollOption' => [qw/options /],

         };
}

sub arrays {
  qw/options/;
}

1;
