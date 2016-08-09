package Telegram::Bot::Object::Base;

use Mojo::Base -base;

sub send_method {
  my $self  = shift;
  my $class = ref($self);
  $class =~ s/Telegram::Bot::Object:://;
  return $class;
}

sub as_hashref {
  my $self = shift;
  my $hash = {};
  # add the simple scalar values
  foreach my $field ( @{ $self->fields->{scalar} } ) {
    $hash->{$field} = $self->$field;
  }
  return $hash;
}

1;
