package Telegram::Bot::Object::PollOption;

# ABSTRACT: The base class for Telegram 'PollOption' type objects

=head1 DESCRIPTION

See L<https://core.telegram.org/bots/api#polloption> for details of the
attributes available for L<Telegram::Bot::Object::PollOption> objects.

=cut

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'text';
has 'voter_count';

sub fields {
  return { scalar  => [qw/text voter_count/],
         };
}

1;
