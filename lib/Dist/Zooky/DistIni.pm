package Dist::Zooky::DistIni;
BEGIN {
  $Dist::Zooky::DistIni::VERSION = '0.02';
}

# ABSTRACT: Generates a Dist::Zilla dist.ini file

use strict;
use warnings;
use Moose;

with 'Dist::Zilla::Role::TextTemplate';

my $template = q|
name = {{ $name }}
version = {{ $version }}
{{ $OUT .= join "\n", map { "author = $_" } @authors; }}
{{ $OUT .= join "\n", map { "license = $_" } @licenses; }}
{{ ( my $holder = $authors[0] ) =~ s/\s*\<.+?\>\s*//g; "copyright_holder = $holder"; }}

[GatherDir]
[PruneCruft]
[ManifestSkip]
[MetaYAML]
[MetaJSON]
[License]

{{ -e 'README' ? ';[Readme]' : '[Readme]'; }}

[ExecDir]
{{ $OUT = "dir = scripts" if -d 'scripts' }}

[ExtraTests]
[ShareDir]

{{ $OUT .= +( $type eq 'ModBuild' ? '[ModuleBuild]' : '[MakeMaker]' ) }}

[Manifest]
[TestRelease]
[ConfirmRelease]
[UploadToCPAN]

{{ 
   if ( keys %configure ) { 
      $OUT .= "[Prereq / ConfigureRequires]\n";
      $OUT .= join(' = ', $_, $configure{$_}) . "\n" for sort keys %configure;
   }
   else {
      $OUT .= ';[Prereq / ConfigureRequires]';
   }
}}
{{ 
   if ( keys %build ) { 
      $OUT .= "[Prereq / BuildRequires]\n";
      $OUT .= join(' = ', $_, $build{$_}) . "\n" for sort keys %build;
   }
   else {
      $OUT .= ';[Prereq / BuildRequires]';
   }
}}
{{ 
   if ( keys %runtime ) { 
      $OUT .= "[Prereq]\n";
      $OUT .= join(' = ', $_, $runtime{$_}) . "\n" for sort keys %runtime;
   }
   else {
      $OUT .= ';[Prereq]';
   }
}}
|;

has 'metadata' => (
  is => 'ro',
  isa => 'HashRef',
  required => 1,
);

sub write {
  my $self = shift;
  my $file = shift || 'dist.ini';
  my %stash;
  $stash{$_} = $self->metadata->{Prereq}->{$_}->{requires}
    for qw(configure build runtime);
  $stash{$_} = $self->metadata->{$_} for qw(author license version name type);
  $stash{"${_}s"} = delete $stash{$_} for qw(author license);
  my $content = $self->fill_in_string(
    $template,
    \%stash,
  );
  open my $ini, '>', $file or die "Could not open '$file': $!\n";
  print $ini $content;
  close $ini;
}

__PACKAGE__->meta->make_immutable;
no Moose;

qq[And Dist::Zooky too!];


__END__
=pod

=head1 NAME

Dist::Zooky::DistIni - Generates a Dist::Zilla dist.ini file

=head1 VERSION

version 0.02

=head1 SYNOPSIS

  my $meta = {
    type => 'MakeMaker',
    name => 'Foo-Bar',
    version => '0.02',
    author => [ 'Duck Dodgers', 'Ivor Biggun' ],
    license => [ 'Perl_5' ],
    Prereq => {
      'runtime' => {
        'requires' => { 'Moo::Cow' => '0.19' },
      },
    }
  };

  my $distini = Dist::Zooky::DistIni->new( metadata => $meta );
  $distini->write();

=head1 DESCRIPTION

Dist::Zooky::DistIni takes meta data and writes a L<Dist::Zilla> C<dist.ini> file.

=head2 ATTRIBUTES

=over

=item C<metadata>

A required attribute. This is a C<HASHREF> of meta data it should contain the keys 
C<name>, C<version>, C<author>, C<license> and C<Prereq>. See the C<SYNOPSIS> for an
example.

=back

=head2 METHODS

=over

=item C<write>

Writes a C<dist.ini> file with the provides C<metadata>. Takes an optional parameter, which is the filename
to write to, the default being C<dist.ini>.

=back

=head1 NAME

Dist::Zooky::DistIni - Generates a Dist::Zilla dist.ini file

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Chris Williams.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

