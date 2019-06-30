package Telegram::Bot::Object::Poll;

# ABSTRACT: The base class for Telegram 'Poll' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#poll> for details of the
attributes available for L<Telegram::Bot::Object::Poll> objects.

=cut

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
