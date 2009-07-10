package dbedia::Debian;

=head1 NAME

dbedia::Debian - helper functions to use http://dbedia.org/Debian/

=head1 SYNOPSIS

    use dbedia::Debian;
    my %provides = %{dbedia::Debian->perl_provides};

=head1 DESCRIPTION

=cut

use warnings;
use strict;
use Carp::Clan ;
use LWP::Simple 'mirror', 'is_error';
use File::Basename 'dirname';
use IO::Uncompress::Gunzip 'gunzip', '$GunzipError';
use JSON::XS;
use dbedia::Debian;

our $VERSION = '0.01';
our $DBEDIA_BASE_URI = 'http://dbedia.org/Debian/';
our $PERL_PROVIDES_BASENAME = 'perlProvides.json.gz';

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

sub PERL_PROVIDES_FILENAME {
    return '/var/cache/apt/apt-pm/'.$PERL_PROVIDES_BASENAME;
}

sub parse_filename {
    my $self     = shift;
    my $filename = shift;
    
    croak 'pass .deb filename as argument'
        if ((not $filename) or ($filename !~ m{^(.+)_(.+)_(.+)\.deb$}));
    
    return $1, $2, $3;
}

sub perl_provides {
    my $self = shift;

    die 'no "'.dbedia::Debian->PERL_PROVIDES_FILENAME.'" run `sudo apt-pm update`', "\n"
        if not -r dbedia::Debian->PERL_PROVIDES_FILENAME;

    my $json_data;
    gunzip $self->PERL_PROVIDES_FILENAME => \$json_data or die "gunzip failed: $GunzipError\n";
    my %provides = %{JSON::XS->new->utf8->decode($json_data)};
    $json_data = undef;
    
    return \%provides;
}

sub perl_provides_update {
    my $self            = shift;
    my $dbedia_base_uri = shift || $DBEDIA_BASE_URI;
    
    die dirname($self->PERL_PROVIDES_FILENAME).' folder not writeable', "\n"
        if not -w dirname($self->PERL_PROVIDES_FILENAME);
    
    my $url = $dbedia_base_uri.$PERL_PROVIDES_BASENAME;
    my $rc  = mirror($url, $self->PERL_PROVIDES_FILENAME);
    die 'failed to fetch "'.$url.'"'."\n"
        if is_error($rc);

    return;
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

'huh?';
