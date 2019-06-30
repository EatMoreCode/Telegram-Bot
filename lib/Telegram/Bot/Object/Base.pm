package Telegram::Bot::Object::Base;

# ABSTRACT: The base class for all Telegram::Bot::Object objects.

=head1 DESCRIPTION

This class should not be instantiated itself. Instead, instantiate a sub-class.

You should generally not need to instantiate objects of sub-classes of L<Telegram::Bot::Object::Base>,
instead the appropriate objects will be created from an incoming request via
L<Telegram::Bot::Brain>.

You can then use the methods referenced below on those objects.

=cut

use Mojo::Base -base;

has '_brain'; # a reference to our brain

=method arrays

Should be overridden by subclasses, returning an array listing of which fields
for the object are arrays.

=cut

sub arrays { qw// }  # override if needed
sub _field_is_array {
  my $self = shift;
  my $field = shift;
  if (grep /^$field$/, $self->arrays) {
    return 1;
  }
  return;
}

=method array_of_arrays

Should be overridden by subclasses, returning an array listing od which fields
for the object are arrays of arrays.

=cut

sub array_of_arrays { qw// } #override if needed
sub _field_is_array_of_arrays {
  my $self = shift;
  my $field = shift;
  if (grep /^$field$/, $self->array_of_arrays) {
    return 1;
  }
  return;
}

=method create_from_hash

Create an object of the appropriate class, including any sub-objects of
other types, as needed.

=cut

# create an object from a hash. Needs to deal with the nested types, and
# arrays
sub create_from_hash {
  my $class = shift;
  my $hash  = shift;
  my $brain = shift || die "no brain supplied";
  my $obj   = $class->new(_brain => $brain);

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
          my $val = $hash->{$field};
          # deal with boolean stuff so we don't pollute our object
          # with JSON
          if (ref($val) eq 'JSON::PP::Boolean') {
            $val = !!$val;
          }
          $obj->$field($val);
        }
        elsif ($obj->_field_is_array_of_arrays) {
          die "not yet implemented for scalars";
        }
        else {
          my $val = $hash->{$field};
          if (ref($val) eq 'JSON::PP::Boolean') {
            $val = 0+$val;

          }
          $obj->$field($val);
        }
      }

      else {
        if ($obj->_field_is_array($field)) {
          my @sub_array;
          foreach my $data ( @{ $hash->{$field} } ) {
            push @sub_array, $type->create_from_hash($data, $brain);
          }
          $obj->$field(\@sub_array);
        }
        elsif ($obj->_field_is_array_of_arrays) {
          die "not yet implemented for scalars";
        }
        else {
          $obj->$field($type->create_from_hash($hash->{$field}, $brain));
        }

      }
    }
  }

  return $obj;
}

=method as_hashref

Return this object as a hashref.

=cut

sub as_hashref {
  my $self = shift;
  my $hash = {};
  # add the simple scalar values
  foreach my $type ( keys %{ $self->fields }) {
    my @fields = @{ $self->fields->{$type} };
    foreach my $field (@fields) {
      if ($type eq 'scalar') {
        $hash->{$field} = $self->$field;
      }
      else {
        # non array types
        $hash->{$field} = $self->$field->as_hashref
          if (ref($self->$field) ne 'ARRAY' && defined $self->$field);
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
