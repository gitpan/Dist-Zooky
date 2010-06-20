package Dist::Zooky::DistIni::Prereqs;
BEGIN {
  $Dist::Zooky::DistIni::Prereqs::VERSION = '0.04';
}

# ABSTRACT: Dist::Zooky DistIni plugin to handle prereqs

use strict;
use warnings;
use Moose;

with 'Dist::Zooky::Role::DistIni';

my $template = q|
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

sub content {
  my $self = shift;
  my %stash;
  $stash{$_} = $self->metadata->{prereqs}->{$_}->{requires}
    for qw(configure build runtime);
  my $content = $self->fill_in_string(
    $template,
    \%stash,
  );
  return $content;
}

__PACKAGE__->meta->make_immutable;
no Moose;

qq[WHAT DO YOU REQUIRE?];


__END__
=pod

=head1 NAME

Dist::Zooky::DistIni::Prereqs - Dist::Zooky DistIni plugin to handle prereqs

=head1 VERSION

version 0.04

=head1 METHODS

=over

=item C<content>

Returns C<content> for adding to C<dist.ini>.

=back

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Chris Williams.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

