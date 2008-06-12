##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Policy/ValuesAndExpressions/RequireInterpolationOfMetachars.pm $
#     $Date: 2008-06-12 13:17:36 -0500 (Thu, 12 Jun 2008) $
#   $Author: clonezone $
# $Revision: 2443 $
##############################################################################

package Perl::Critic::Policy::ValuesAndExpressions::RequireInterpolationOfMetachars;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities };
use base 'Perl::Critic::Policy';

#-----------------------------------------------------------------------------

our $VERSION = '1.086';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{String *may* require interpolation};
Readonly::Scalar my $EXPL => [ 51 ];

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                    }
sub default_severity     { return $SEVERITY_LOWEST      }
sub default_themes       { return qw(core pbp cosmetic) }
sub applies_to           { return qw(PPI::Token::Quote::Single
                                     PPI::Token::Quote::Literal) }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;
    # The string() method strips off the quotes
    return if not _needs_interpolation( $elem->string() );
    return if _looks_like_email_address( $elem->string() );
    return $self->violation( $DESC, $EXPL, $elem );
}

#-----------------------------------------------------------------------------

sub _needs_interpolation {
    my $string = shift;
    return $string =~ m{ [\$\@] \S+ }mxo             #Contains a $ or @
        || $string =~ m{ \\[tnrfae0xcNLuLUEQ] }mxo;  #Contains metachars
}

#-----------------------------------------------------------------------------

sub _looks_like_email_address {
    my $string = shift;
    return $string =~ m{\A [^\@\s]+ \@ [\w\-.]+ \z}mxo;
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::ValuesAndExpressions::RequireInterpolationOfMetachars - Warns that you might have used single quotes when you really wanted double-quotes.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic> distribution.


=head1 DESCRIPTION

This policy warns you if you use single-quotes or C<q//> with a string
that has unescaped metacharacters that may need interpolation. Its hard
to know for sure if a string really should be interpolated without
looking into the symbol table.  This policy just makes an educated
guess by looking for metacharacters and sigils which usually indicate that
the string should be interpolated.


=head1 CONFIGURATION

This Policy is not configurable except for the standard options.


=head1 NOTES

Perl's own C<warnings> pragma also warns you about this.

=head1 SEE ALSO

L<Perl::Critic::Policy::ValuesAndExpressions::ProhibitInterpolationOfLiterals>

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2008 Jeffrey Ryan Thalhammer.  All rights reserved.

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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
