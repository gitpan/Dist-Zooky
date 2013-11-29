
use strict;
use warnings;

use 5.008005;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "converts a distribution to Dist::Zilla",
  "AUTHOR" => "Chris Williams <chris\@bingosnet.co.uk>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Dist-Zooky",
  "EXE_FILES" => [
    "bin/dzooky"
  ],
  "LICENSE" => "perl",
  "NAME" => "Dist::Zooky",
  "PREREQ_PM" => {
    "App::Cmd" => "0.307",
    "CPAN::Meta" => "2.101610",
    "Class::Load" => 0,
    "Dist::Zilla" => "4.102342",
    "ExtUtils::MakeMaker" => "6.56",
    "File::Temp" => "0.22",
    "IPC::Cmd" => "0.58",
    "Module::Build" => "0.3607",
    "Module::Load::Conditional" => "0.38",
    "Module::Pluggable" => "3.9",
    "Moose" => "1.07",
    "MooseX::Types::Moose" => "0.22",
    "MooseX::Types::Perl" => "0.101340",
    "Params::Check" => "0.26",
    "Software::License" => "0.101620"
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.12",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "App::Cmd" => "0.307",
  "CPAN::Meta" => "2.101610",
  "Class::Load" => 0,
  "Dist::Zilla" => "4.102342",
  "ExtUtils::MakeMaker" => "6.56",
  "File::Spec" => 0,
  "File::Temp" => "0.22",
  "IO::Handle" => 0,
  "IPC::Cmd" => "0.58",
  "IPC::Open3" => 0,
  "Module::Build" => "0.3607",
  "Module::Load::Conditional" => "0.38",
  "Module::Pluggable" => "3.9",
  "Moose" => "1.07",
  "MooseX::Types::Moose" => "0.22",
  "MooseX::Types::Perl" => "0.101340",
  "Params::Check" => "0.26",
  "Software::License" => "0.101620",
  "Test::More" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



