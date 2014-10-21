##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-1.03/lib/Perl/Critic/Policy/BuiltinFunctions/ProhibitLvalueSubstr.pm $
#     $Date: 2007-02-13 10:58:53 -0800 (Tue, 13 Feb 2007) $
#   $Author: thaljef $
# $Revision: 1247 $
##############################################################################

package Perl::Critic::Policy::BuiltinFunctions::ProhibitLvalueSubstr;

use strict;
use warnings;
use Perl::Critic::Utils qw{ :severities :classification };
use base 'Perl::Critic::Policy';

our $VERSION = 1.03;

#-----------------------------------------------------------------------------

my $desc = q{Lvalue form of "substr" used};
my $expl = [ 165 ];

#-----------------------------------------------------------------------------

sub supported_parameters { return() }
sub default_severity { return $SEVERITY_MEDIUM     }
sub default_themes    { return qw( core maintenance pbp ) }
sub applies_to       { return 'PPI::Token::Word'   }

#-----------------------------------------------------------------------------

sub violates {
    my ($self, $elem, undef) = @_;

    return if $elem ne 'substr';
    return if ! is_function_call($elem);

    my $sib = $elem;
    while ($sib = $sib->snext_sibling()) {
        if ( $sib->isa( 'PPI::Token::Operator') && $sib eq q{=} ) {
            return $self->violation( $desc, $expl, $sib );
        }
    }
    return; #ok!
}

1;

#-----------------------------------------------------------------------------

__END__

=pod

=head1 NAME

Perl::Critic::Policy::BuiltinFunctions::ProhibitLvalueSubstr

=head1 DESCRIPTION

Conway discourages the use of C<substr()> as an lvalue, instead
recommending that the 4-argument version of C<substr()> be used instead.

  substr($something, 1, 2) = $newvalue;     # not ok
  substr($something, 1, 2, $newvalue);      # ok

=head1 AUTHOR

Graham TerMarsch <graham@howlingfrog.com>

=head1 COPYRIGHT

Copyright (C) 2005-2007 Graham TerMarsch.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
