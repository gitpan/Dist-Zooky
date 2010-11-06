
use strict;
use warnings;

BEGIN { require 5.008005; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'converts a distribution to Dist::Zilla',
  'AUTHOR' => 'Chris Williams <chris@bingosnet.co.uk>',
  'BUILD_REQUIRES' => {},
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Dist-Zooky',
  'EXE_FILES' => [
    'bin/dzooky'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'Dist::Zooky',
  'PREREQ_PM' => {
    'App::Cmd' => '0.307',
    'CPAN::Meta' => '2.101610',
    'Class::MOP' => '1.03',
    'Dist::Zilla' => '4.102342',
    'ExtUtils::MakeMaker' => '6.56',
    'File::Temp' => '0.22',
    'IPC::Cmd' => '0.58',
    'Module::Build' => '0.3607',
    'Module::Load::Conditional' => '0.38',
    'Module::Pluggable' => '3.9',
    'Moose' => '1.07',
    'MooseX::Types::Moose' => '0.22',
    'MooseX::Types::Perl' => '0.101340',
    'Params::Check' => '0.26',
    'Software::License' => '0.101620'
  },
  'VERSION' => '0.06',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



