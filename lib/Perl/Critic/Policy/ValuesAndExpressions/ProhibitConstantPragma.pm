#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-0.18_01/lib/Perl/Critic/Policy/ValuesAndExpressions/ProhibitConstantPragma.pm $
#     $Date: 2006-08-06 16:13:55 -0700 (Sun, 06 Aug 2006) $
#   $Author: thaljef $
# $Revision: 556 $
# ex: set ts=8 sts=4 sw=4 expandtab
########################################################################

package Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma;

use strict;
use warnings;
use Perl::Critic::Utils;
use base 'Perl::Critic::Policy';

our $VERSION = '0.18_01';
$VERSION = eval $VERSION;    ## no critic

#---------------------------------------------------------------------------

my $desc = q{Pragma 'constant' used};
my $expl = [ 55 ];

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_HIGH }
sub applies_to { return 'PPI::Statement::Include' }

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;
    if ( $elem->type() eq 'use' && $elem->pragma() eq 'constant' ) {
        return $self->violation( $desc, $expl, $elem );
    }
    return;    #ok!
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma

=head1 DESCRIPTION

Named constants are a good thing.  But don't use the C<constant>
pragma because barewords don't interpolate.  Instead use the
L<Readonly> module.

  use constant FOOBAR => 42;  #not ok

  use Readonly;
  Readonly  my $FOOBAR => 42;  #ok

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2006 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
