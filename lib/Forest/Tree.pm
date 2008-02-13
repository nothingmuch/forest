package Forest::Tree;
use Moose;
use MooseX::AttributeHelpers;

use Scalar::Util 'reftype';
use List::Util   'sum', 'max';

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'node' => (is => 'rw', isa => 'Any');

has 'uid'  => (
    is      => 'rw',
    isa     => 'Value',
    lazy    => 1,
    default => sub { ($_[0] =~ /\((.*?)\)$/)[0] },
);

has 'parent' => (
    reader      => 'parent',
    writer      => '_set_parent',
    predicate   => 'has_parent',
    clearer     => 'clear_parent',
    isa         => 'Maybe[Forest::Tree]',
    is_weak_ref => 1,
    handles     => {
        'add_sibling'       => 'add_child',
        'get_sibling_at'    => 'get_child_at',
        'insert_sibling_at' => 'insert_child_at',
    },
);

has 'children' => (
    metaclass => 'Collection::Array',
    is        => 'rw',
    isa       => 'ArrayRef[Forest::Tree]',
    lazy      => 1,
    default   => sub { [] },
    provides  => {
        'get'   => 'get_child_at',
        'count' => 'child_count',
    }
);

has 'size' => (
    is        => 'ro',
    isa       => 'Int',
    lazy      => 1,
    required  => 1,
    clearer   => 'clear_size',
    predicate => 'has_size',
    default   => sub {
        my $self = shift;
        return 1 unless $self->child_count;        
        1 + sum map { $_->size } @{ $self->children };
    }
);

has 'height' => (
     is        => 'ro',
     isa       => 'Int',
     lazy      => 1,
     required  => 1,
     clearer   => 'clear_height',
     predicate => 'has_height',
     default   => sub {
         my $self = shift;
         return 0 unless $self->child_count;
         1 + max map { $_->height } @{ $self->children };
     }
);

after 'clear_size' => sub {
    my $self = shift;
    $self->parent->clear_size
        if $self->has_parent && $self->parent->has_size;
};

after 'clear_height' => sub {
    my $self = shift;
    $self->parent->clear_height
        if $self->has_parent && $self->parent->has_height;
};

## informational
sub is_root { !(shift)->has_parent      }
sub is_leaf { (shift)->child_count == 0 }

## depth
sub depth { ((shift)->parent || return -1)->depth + 1 }

## child management
sub add_child {
    my ($self, $child) = @_;
    (blessed($child) && $child->isa('Forest::Tree'))
        || confess "Child parameter must be a Forest::Tree not (" . (defined $child ? $child : 'undef') . ")";
    $child->_set_parent($self);
    $self->clear_height if $self->has_height;
    $self->clear_size   if $self->has_size;    
    push @{ $self->children } => $child;
    $self;
}

sub insert_child_at {
    my ($self, $index, $child) = @_;
    (blessed($child) && $child->isa('Forest::Tree'))
        || confess "Child parameter must be a Forest::Tree not (" . (defined $child ? $child : 'undef') . ")";
    $child->_set_parent($self);
    $self->clear_height if $self->has_height;
    $self->clear_size   if $self->has_size;
    splice @{ $self->children }, $index, 0, $child;
}

sub remove_child_at {
    my ($self, $index) = @_;
    $self->clear_height if $self->has_height;
    $self->clear_size   if $self->has_size;
    my $child = splice @{ $self->children }, $index, 1;
    $child->clear_parent;
}

## traversal
sub traverse {
    my ($self, $func) = @_;
    (defined($func))
        || confess "Cannot traverse without traversal function";
    (reftype($func) eq "CODE")
        || die "Traversal function must be a CODE reference, not : $func";
    foreach my $child (@{ $self->children }) {
        $func->($child);
        $child->traverse($func);
    }
}

##siblings

sub siblings {
    my $self = shift;
    [ grep { $self->uid ne $_->uid } @{ $self->children } ];
}

__PACKAGE__->meta->make_immutable(inline_accessors => 0);

no Moose; 1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 node

=head2 uid

=head2 parent

=over 4

=item B<parent>

=item B<_set_parent>

=item B<has_parent>

=item B<clear_parent>

=back

=head2 children

=head2 size

=over 4

=item B<size>

=item B<has_size>

=item B<clear_size>

=back

=head2 height

=over 4

=item B<height>

=item B<has_height>

=item B<clear_height>

=back

=head1 METHODS

=head2 is_root

True if the current tree has no parent

=head2 is_leaf

True if the current tree has no children

=head2 depth

Return the depth of this tree. Root has a depth of -1

=head2 add_child $child

Add a new child. The $child must be a C<Forest::Tree>

=head2 insert_child_at $index $child

Insert a child at this position. (zero-base index)

=head2 get_child_at $index

Return the child at this position. (zero-base index)

=head2 remove_child_at $index

Remove the child at this position. (zero-base index)

=head2 child_count

Returns the number of children this tree has

=head2 traverse \&func

Takes a reference to a subroutine and traverses the tree applying this subroutine to
every descendant.

=head2 siblings

Returns an array reference of all siblings (not including us)

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
