package Telegram::Bot::Object::LoginUrl;

# ABSTRACT: The base class for Telegram 'LoginUrl' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';

has 'url';
has 'forward_text';
has 'bot_username';
has 'request_write_access';

sub fields {
  return { 'scalar' => [qw/url forward_text bot_username request_write_access/] };
}

1;
