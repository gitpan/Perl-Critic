##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-1.04/lib/Perl/Critic/Policy/Miscellanea/ProhibitTies.pm $
#     $Date: 2007-03-19 18:06:56 -0800 (Mon, 19 Mar 2007) $
#   $Author: thaljef $
# $Revision: 1308 $
##############################################################################

package Perl::Critic::Policy::Miscellanea::ProhibitTies;

use strict;
use warnings;
use Perl::Critic::Utils qw{ :severities :classification };
use base 'Perl::Critic::Policy';

our $VERSION = 1.04;

#-----------------------------------------------------------------------------

my $desc = q{Tied variable used};
my $expl = [ 451 ];

#-----------------------------------------------------------------------------

sub supported_parameters { return() }
sub default_severity { return $SEVERITY_LOW       }
sub default_themes   { return qw(core pbp maintenance) }
sub applies_to       { return 'PPI::Token::Word'  }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;
    return if $elem ne 'tie';
    return if ! is_function_call( $elem );
    return $self->violation( $desc, $expl, $elem );
}


1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Miscellanea::ProhibitTies

=head1 DESCRIPTION

Conway discourages using C<tie> to bind Perl primitive variables to
user-defined objects.  Unless the tie is done close to where the
object is used, other developers probably won't know that the variable
has special behavior.  If you want to encapsulate complex behavior,
just use a proper object or subroutine.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2007 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
