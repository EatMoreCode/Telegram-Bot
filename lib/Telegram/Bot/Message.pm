package Telegram::Bot::Message;

# ABSTRACT: The base class for Telegram messages incoming to the bot

use Mojo::Base -base;
use Mojo::JSON qw/from_json/;

use Telegram::Bot::Message::User;
use Telegram::Bot::Message::UserOrGroup;
use Telegram::Bot::Message::Audio;
use Telegram::Bot::Message::Document;
use Telegram::Bot::Message::Video;
use Telegram::Bot::Message::Sticker;
use Telegram::Bot::Message::PhotoSize;
use Telegram::Bot::Message::Sticker;
use Telegram::Bot::Message::Contact;
use Telegram::Bot::Message::Location;

use Data::Dumper;

# basic message stuff
has 'message_id';
has 'from';
has 'date';
has 'chat';
has 'forward_from';
has 'forward_date';
has 'reply_to_message';


# the message might have several other optional parts
has 'text';
has 'audio';
has 'document';
has 'photo';
has 'sticker';
has 'video';
has 'contact';
has 'location';

has 'new_chat_participant';
has 'left_chat_participant';

sub fields {
  return {
          'scalar'                       => [qw/message_id date text forward_date/],
          'Telegram::Bot::Message'       => [qw/reply_to_message/],
          'Telegram::Bot::Message::User' => [qw/from
                                                new_chat_participant left_chat_participant
                                                forward_from/],

          'Telegram::Bot::Message::UserOrGroup' => [qw/chat/],

          'Telegram::Bot::Message::Audio'      => [qw/audio/],
          'Telegram::Bot::Message::Document'   => [qw/document/],
          'Telegram::Bot::Message::PhotoSize'  => [qw/photo/],
          'Telegram::Bot::Message::Video'      => [qw/video/],
          'Telegram::Bot::Message::Sticker'    => [qw/sticker/],
          'Telegram::Bot::Message::Contact'    => [qw/contact/],
          'Telegram::Bot::Message::Location'   => [qw/location/],
  };
}


sub is_array { my $field = shift; return $field eq 'photo'; }

sub create_from_json {
  my $class = shift;
  my $json  = shift;
  my $hash  = from_json $json;
  return $class->create_from_hash($hash);
}

sub create_from_hash {
  my $class = shift;
  my $hash  = shift;
  my $msg   = $class->new;
  warn "creating a $class from " . Dumper ($hash) . "\n";

  foreach my $k (keys %{ $class->fields }) {
    # warn " working on fields of type '$k'\n";
    if ($k eq 'scalar') {
      foreach my $field (@{ $class->fields->{scalar} } ) {
        # warn "  field: $field\n";
        $msg->$field($hash->{$field});
      }
    }
    else {
      foreach my $field (@{ $class->fields->{$k} } ) {
        # warn "  field: $field (" . Dumper($hash->{$field}) . ")\n";
        if (is_array($field)) {
          my @items;
          foreach my $item (@{ $hash->{$field} || [] }) {
            my $o = $k->create_from_hash($item)
              if defined $hash->{$field};
            push @items, $o;
          }
          $msg->$field(\@items);
        }
        else {
          my $o = $k->create_from_hash($hash->{$field})
            if defined $hash->{$field};
          $msg->$field($o);
        }
      }
    }
  }
  return $msg;
}


1;
