package Telegram::Bot::Message;

# ABSTRACT: The base class for Telegram messages

use Mojo::Base -base;
use Mojo::JSON qw/from_json/;

use Telegram::Bot::Message::User;
use Telegram::Bot::Message::UserOrGroup;

use Data::Dumper;

# basic message stuff
has 'message_id';
has 'from';
has 'date';
has 'text';
has 'chat';
has 'new_chat_participant';
has 'left_chat_participant';
has 'forward_from';
has 'forward_date';
has 'reply_to_message';


sub fields {
  return { 
    'scalar' 
     => [qw/message_id date text forward_date/],
   'Telegram::Bot::Message' 
     => [qw/reply_to_message/],
   'Telegram::Bot::Message::User' 
     => [qw/from 
            new_chat_participant left_chat_participant
            forward_from/],
   'Telegram::Bot::Message::UserOrGroup' 
     => [qw/chat/],
  };
}

sub create_from_json {
  my $class = shift;
  my $json  = shift;
  my $hash  = from_json $json;
  return $class->create_from_hash($hash);
}

sub create_from_hash {
  my $class = shift;
  my $hash = shift;
  my $msg  = $class->new;
  # warn "creating a $class from " . Dumper ($hash) . "\n";

  foreach my $k (keys $class->fields) {
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
        my $o;
        $o = $k->create_from_hash($hash->{$field}) 
          if defined $hash->{$field};
        $msg->$field($o);
      }
    }
  }
  return $msg;
}

1;
