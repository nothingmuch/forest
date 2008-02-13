package Forest::Tree::Reader;
use Moose::Role;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'tree' => (
    is      => 'ro',
    isa     => 'Forest::Tree',
    lazy    => 1,
    default => sub { Forest::Tree->new },
);

has 'parser' => (
    is      => 'rw',
    isa     => 'CodeRef',   
    lazy    => 1,
    builder => 'build_parser',
);

requires 'read';

sub parse_line { $_[0]->parser->(@_) }

1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS 

=over 4

=item B<>

=back

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
