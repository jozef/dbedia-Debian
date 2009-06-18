package dbedia::Debian;

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use base 'Class::Accessor::Fast';

=head1 PROPERTIES

=cut

__PACKAGE__->mk_accessors(qw{
});

=head1 METHODS

=head2 new()

Object constructor.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new({ @_ });
    
    return $self;
}

1;


__END__

=head1 AUTHOR

Jozef Kutej, C<< <jkutej at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dbedia-debian at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=dbedia-Debian>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc dbedia::Debian


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=dbedia-Debian>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/dbedia-Debian>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/dbedia-Debian>

=item * Search CPAN

L<http://search.cpan.org/dist/dbedia-Debian>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jozef Kutej, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

'Matisse'; # End of dbedia::Debian
