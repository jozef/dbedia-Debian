package dbedia::Debian;

=head1 NAME

dbedia::Debian - helper functions to use L<http://dbedia.org/Debian/>

=head1 SYNOPSIS

    use dbedia::Debian;
    my %provides = %{dbedia::Debian->perl_provides};

=head1 DESCRIPTION

An experiment.

=cut

use warnings;
use strict;
use Carp::Clan ;
use LWP::Simple 'mirror', 'is_error';
use File::Basename 'dirname';
use IO::Uncompress::Gunzip 'gunzip', '$GunzipError';
use JSON::XS;

our $VERSION = '0.02';
our $DBEDIA_BASE_URI = 'http://dbedia.org/Debian/';
our $PERL_PROVIDES_BASENAME = 'perlProvides.json.gz';

use base 'Class::Accessor::Fast';

=head1 PROPERTIES

none so far

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


=head2 PERL_PROVIDES_FILENAME()

returns path to the apt-pm cache file.

=cut

sub PERL_PROVIDES_FILENAME {
    return '/var/cache/apt/apt-pm/'.$PERL_PROVIDES_BASENAME;
}


=head2 parse_filename($filename)

Parses .deb filename an returns
C<($deb_package_name, $deb_package_version, $deb_package_architecture)>.

=cut

sub parse_filename {
    my $self     = shift;
    my $filename = shift;
    
    croak 'pass .deb filename as argument'
        if ((not $filename) or ($filename !~ m{^(.+)_(.+)_(.+)\.deb$}));
    
    return $1, $2, $3;
}


=head2 perl_provides()

Returns hash reference with Perl packages as keys and the location
as values:

   "Moose::Util" => {
      "0.87" => {
         "pm_file" => "/usr/share/perl5/Moose/Util.pm",
         "filename" => "libmoose-perl_0.87-1_all.deb",
         "folder" => "pool/main/libm/libmoose-perl"
      },
      "0.54" => {
         "pm_file" => "/usr/share/perl5/Moose/Util.pm",
         "filename" => "libmoose-perl_0.54-1_all.deb",
         "folder" => "pool/main/libm/libmoose-perl"
      },
      "0.86" => {
         "pm_file" => "/usr/share/perl5/Moose/Util.pm",
         "filename" => "libmoose-perl_0.86-1_all.deb",
         "folder" => "pool/main/libm/libmoose-perl"
      },
      "0.80" => {
         "pm_file" => "/usr/share/perl5/Moose/Util.pm",
         "filename" => "libmoose-perl_0.80-1_all.deb",
         "folder" => "pool/main/libm/libmoose-perl"
      }
   },
   ...

=cut

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


=head2 perl_provides_update()

Refresh PERL_PROVIDES_FILENAME() from L<http://dbedia.com/Debian/>

=cut

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


=head2 find_perl_module_package($module_name, $min_version)

For given C<$module_name> and C<$min_version> required looks up a Debian
package. Returns Debian package name in scalar context and name + version
in array context.

NOTE: the hash with perl_provides will be loaded and cached first time used
and the memory will not be released until program ends.

=cut

my %provides_cache;
sub find_perl_module_package {
    my $self    = shift;
    my $module  = shift;
    my $version = shift || 0;
    
    %provides_cache = %{dbedia::Debian->perl_provides}
        if not %provides_cache;
    
    return if not exists $provides_cache{$module};
    
    # sort available versions and grep smaller than requested
    my @versions =
        sort { CPAN::Version->vcmp($a, $b) }
        grep { not CPAN::Version->vlt($_, $version) }
        keys %{$provides_cache{$module}}
    ;
    
    return if not @versions;
    
    my $debianized_version = $versions[0];
    my ($deb_package_name, $deb_package_version) =
        dbedia::Debian->parse_filename($provides_cache{$module}->{$debianized_version}->{'filename'});
    return ($deb_package_name, $deb_package_version)
        if wantarray();
    return $deb_package_name;
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
