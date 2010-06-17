package Dist::Zooky::Core::ModBuild;
BEGIN {
  $Dist::Zooky::Core::ModBuild::VERSION = '0.02';
}

# ABSTRACT: gather meta data for Module::Build dists

use strict;
use warnings;
use Moose;
use IPC::Cmd qw[run can_run];

with 'Dist::Zooky::Role::Core';
with 'Dist::Zooky::Role::Meta';

sub examine {
  my $self = shift;

  {
    local $ENV{PERL_MM_USE_DEFAULT} = 1;

    my $cmd = [ $^X, 'Build.PL' ];
    run ( command => $cmd, verbose => 0 );
  }

  if ( -e 'MYMETA.yml' ) {

    my $struct = $self->meta_from_file( 'MYMETA.yml' );
    $self->_set_name( $struct->{name} );
    $self->_set_author( $struct->{author} );
    $self->_set_license( $struct->{license} );
    $self->_set_version( $struct->{version} );
    $self->_set_prereqs( $struct->{prereqs} );
    
  }
  else {

    die "Couldn\'t find a 'MYMETA.yml' file, giving up\n";

  }

  {
    my $cmd = [ $^X, 'Build', 'distclean' ];
    run( command => $cmd, verbose => 0 );
  }

  return;
}

sub return_meta {
  my $self = shift;
  return { map { ( $_, $self->$_ ) } qw(author name version license Prereq) };
}

__PACKAGE__->meta->make_immutable;
no Moose;

qq[MakeMaker];


__END__
=pod

=head1 NAME

Dist::Zooky::Core::ModBuild - gather meta data for Module::Build dists

=head1 VERSION

version 0.02

=head1 METHODS

=over

=item C<examine>

=item C<return_meta>

=back

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Chris Williams.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

