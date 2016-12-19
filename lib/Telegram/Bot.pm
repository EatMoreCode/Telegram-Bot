package Telegram::Bot;

# ABSTRACT: A base class to make your very own Telegram bot

=head1 SYNOPSIS

NOTE: This API should not yet be considered stable.

Creating a bot is easy:

    package MyBot;
    
    use Mojo::Base 'Telegram::Bot::Brain';

    has token => 'YOURTOKENHERE';

    # is this a message we'd like to respond to?
    sub _hello_for_me {
      my ($self, $msg) = @_;
      # look for the word 'hello' with or without a leading slash
      if ($msg->text =~ m{/?hello}i) {
        return 1;
      }
      return 0;
    }

    # send a polite reply, to either a group or a single user,
    # depending on where we were addressed from
    sub _be_polite {
      my ($self, $msg) = @_;

      # is this a 1-on-1 ?
      if ($msg->chat->is_user) {
        $self->send_message_to_chat_id($msg->chat->id, "hello there");

        # send them a picture as well
        my $image = Telegram::Bot::Object::PhotoSize->new(image => "smile.png");
        $self->send_to_chat_id($msg->chat->id, $image);
      }
      # group chat
      else {
        $self->send_message_to_chat_id($msg->chat->id, "hello to everyone!");
      }
    }

    # setup our bot
    sub init {
      my $self = shift;
      $self->add_listener(\&_hello_for_me,  # criteria
                          \&_be_polite      # response
                         ); 
 
    }

    1;
    
Now just:

    perl -MMyBot -E 'MyBot->new->think'
    
and you've got yourself a stew, baby! Or a bot, anyway.

Note that for the bot to see messages that do not start with a leading '/', you will need to use
the C<'/setprivacy'> command on Telegram's C<@botfather> interface to change the privacy settings.

=cut

1;
