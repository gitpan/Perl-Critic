#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-0.19/lib/Perl/Critic/Policy/RegularExpressions/RequireLineBoundaryMatching.pm $
#     $Date: 2006-08-20 13:46:40 -0700 (Sun, 20 Aug 2006) $
#   $Author: thaljef $
# $Revision: 633 $
# ex: set ts=8 sts=4 sw=4 expandtab
########################################################################

package Perl::Critic::Policy::RegularExpressions::RequireLineBoundaryMatching;

use strict;
use warnings;
use Perl::Critic::Utils;
use base 'Perl::Critic::Policy';

our $VERSION = 0.19;

#----------------------------------------------------------------------------

my $desc = q{Regular expression without "/m" flag};
my $expl = [ 237 ];

#----------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOW }
sub applies_to { return qw(PPI::Token::Regexp::Match
                           PPI::Token::Regexp::Substitute) }

#----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    #Note: as of PPI 1.103, 'modifiers' is not part of the published
    #API.  I'm cheating by accessing it here directly.

    if ( ! defined $elem->{modifiers}->{'m'} ) {
        return $self->violation( $desc, $expl, $elem );
    }
    return; #ok!;
}

1;

__END__

#----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::RegularExpressions::RequireLineBoundaryMatching

=head1 DESCRIPTION

Folks coming from a C<sed> or C<awk> background tend to assume that
C<'$'> and C<'^'> match the beginning and and of the line, rather than
then beginning and ed of the string.  Adding the '/m' flag to your
regex makes it behave as most people expect it should.

  my $match = m{ ^ $pattern $ }x;  #not ok
  my $match = m{ ^ $pattern $ }xm; #ok

=head1 NOTES

For common regular expressions like e-mail addresses, phone numbers,
dates, etc., have a look at the L<Regex::Common> module.  Also, be
cautions about slapping modifier flags onto existing regular
expressions, as they can drastically alter their meaning.  See
L<http://www.perlmonks.org/?node_id=484238> for an interesting
discussion on the effects of blindly modifying regular expression
flags.

=head1 AUTHOR

Jeffrey Ryan Thalhammer  <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2006 Jeffrey Ryan Thalhammer. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
