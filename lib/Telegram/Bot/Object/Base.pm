package Telegram::Bot::Object::Base;

# ABSTRACT: The base class for all Telegram::Bot::Object objects

use Mojo::Base -base;

sub arrays { qw// }  # override if needed
sub _field_is_array {
  my $self = shift;
  my $field = shift;
  if (grep /^$field$/, $self->arrays) {
    return 1;
  }
  return;
}

sub array_of_arrays { qw// } #override if needed
sub _field_is_array_of_arrays {
  my $self = shift;
  my $field = shift;
  if (grep /^$field$/, $self->array_of_arrays) {
    return 1;
  }
  return;
}

# create an object from a hash. Needs to deal with the nested types, and
# arrays
sub create_from_hash {
  my $class = shift;
  my $hash  = shift;
  my $obj   = $class->new;

  warn "creating a new $class from hash $hash\n";

  # deal with each type of field
  foreach my $type (keys %{ $class->fields }) {
    my @fields_of_this_type = @{ $class->fields->{$type} };

    foreach my $field (@fields_of_this_type) {

      # ignore fields for which we have no value in the hash
      next if (! defined $hash->{$field} );

      # warn "type: $type field $field\n";
      if ($type eq 'scalar') {
        if ($obj->_field_is_array($field)) {
          # simple scalar array ref, so just copy it
          $obj->$field($hash->$field);
        }
        elsif ($obj->_field_is_array_of_arrays) {
          die "not yet implemented for scalars";
        }
        else {
          $obj->$field($hash->{$field});
        }
      }

      else {
        if ($obj->_field_is_array($field)) {
          my @sub_array;
          foreach my $data ( @{ $hash->{$field} } ) {
            push @sub_array, $type->create_from_hash($data);
          }
          $obj->$field(\@sub_array);
        }
        elsif ($obj->_field_is_array_of_arrays) {
          die "not yet implemented for scalars";
        }
        else {
          warn "creating a $type for $field in this: " . ref($obj) . "\n";
          $obj->$field($type->create_from_hash($hash->{$field}));
        }

      }
    }
  }

  return $obj;
}

sub as_hashref {
  my $self = shift;
  my $hash = {};
  # add the simple scalar values
  foreach my $type ( @{ $self->fields }) {
    my @fields = @{ $self->fields->$type };
    foreach my $field (@fields) {
      if ($type eq 'scalar') {
        $hash->{$field} = $self->$field;
      }
      else {
        # non array types
        $hash->{$field} = $self->$field->as_hashref
          if (ref($self->$field) ne 'ARRAY');
        # array types
        $hash->{$field} = [
          map { $_->as_hashref } @{ $self->$field }
        ] if (ref($self->$field) eq 'ARRAY');
      }
    }
  }
  return $hash;
}

1;
