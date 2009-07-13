use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'dbedia-Debian',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jkutej@cpan.org>',
    dist_version_from   => 'lib/dbedia/Debian.pm',
    requires => {
        'Class::Accessor::Fast' => 0,
        'File::Find::Rule' => 0,
        'Carp::Clan'       => 0,
        'JSON::XS'         => 0,
        'File::Spec'       => 0,
        'LWP::Simple'      => 0,
        'File::Basename'   => 0,
        'IO::Uncompress::Gunzip'
                           => 0,
    },
    build_requires => {
        'Test::More'      => 0,
        'Test::Exception' => 0,
        'File::Spec'      => 0,
    },
    script_files => [
        'script/apt-pm',
    ],
    add_to_cleanup      => [ 'dbedia-Debian-*' ],
    create_readme       => 1,
    sign                => 1,
);

$builder->create_build_script();
