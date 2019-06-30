package Telegram::Bot::Object::Invoice;

# ABSTRACT: The base class for Telegram 'Invoice' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'title';
has 'description';
has 'start_parameter';
has 'currency';
has 'total_amount';

sub fields {
  return { scalar => [qw/title description start_parameter currency total_amount/],
         };
}

1;
