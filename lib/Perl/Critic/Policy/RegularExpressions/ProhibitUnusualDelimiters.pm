##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/lib/Perl/Critic/Policy/RegularExpressions/ProhibitUnusualDelimiters.pm $
#     $Date: 2009-01-18 17:32:26 -0600 (Sun, 18 Jan 2009) $
#   $Author: clonezone $
# $Revision: 3007 $
##############################################################################

package Perl::Critic::Policy::RegularExpressions::ProhibitUnusualDelimiters;

use 5.006001;
use strict;
use warnings;
use Readonly;

use English qw(-no_match_vars);
use Carp;

use Perl::Critic::Utils qw{ :booleans :severities hashify };
use Perl::Critic::Utils::PPIRegexp qw{ get_delimiters };
use base 'Perl::Critic::Policy';

our $VERSION = '1.095_001';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q<Use only '//' or '{}' to delimit regexps>;
Readonly::Scalar my $EXPL => [246];

Readonly::Array my @EXTRA_BRACKETS => qw{ () [] <> };

#-----------------------------------------------------------------------------

sub supported_parameters {
    return (
        {
            name               => 'allow_all_brackets',
            description        =>
                q[In addition to allowing '{}', allow '()', '[]', and '{}'.],
            behavior           => 'boolean',
        },
    );
}

sub default_severity     { return $SEVERITY_LOWEST        }
sub default_themes       { return qw( core pbp cosmetic ) }
sub applies_to           { return qw(PPI::Token::Regexp::Match
                                     PPI::Token::Regexp::Substitute
                                     PPI::Token::QuoteLike::Regexp) }

#-----------------------------------------------------------------------------

sub initialize_if_enabled {
    my ( $self, $config ) = @_;

    my %delimiters = hashify( qw< // {} > );
    if ( $self->{_allow_all_brackets} ) {
        @delimiters{ @EXTRA_BRACKETS } = (1) x @EXTRA_BRACKETS;
    }

    $self->{_allowed_delimiters} = \%delimiters;

    return $TRUE;
}

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    my $allowed_delimiters = $self->{_allowed_delimiters};
    foreach my $delimiter (get_delimiters($elem)) {
        next if $allowed_delimiters->{$delimiter};
        return $self->violation( $DESC, $EXPL, $elem );
    }

    return;  # OK
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::RegularExpressions::ProhibitUnusualDelimiters - Use only C<//> or C<{}> to delimit regexps.


=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic|Perl::Critic>
distribution.


=head1 DESCRIPTION

Perl lets you delimit regular expressions with almost any character,
but most choices are illegible.  Compare these equivalent expressions:

  s/foo/bar/;   # good
  s{foo}{bar};  # good
  s#foo#bar#;   # bad
  s;foo;bar;;   # worse
  s|\|\||\||;   # eye-gouging bad


=head1 CONFIGURATION

There is one option for this policy, C<allow_all_brackets>.  If this
is true, then, in addition to allowing C<//> and C<{}>, the other
matched pairs of C<()>, C<[]>, and C<< <> >> are allowed.


=head1 CREDITS

Initial development of this policy was supported by a grant from the
Perl Foundation.


=head1 AUTHOR

Chris Dolan <cdolan@cpan.org>


=head1 COPYRIGHT

Copyright (c) 2007-2009 Chris Dolan.  Many rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
