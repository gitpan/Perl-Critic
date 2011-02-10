#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/t/05_utils_perl.t $
#     $Date: 2011-02-09 20:31:08 -0600 (Wed, 09 Feb 2011) $
#   $Author: clonezone $
# $Revision: 4037 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use Readonly;


use Perl::Critic::Utils::Perl qw< :all >;


use Test::More tests => 7;

#-----------------------------------------------------------------------------

our $VERSION = '1.112_002';

#-----------------------------------------------------------------------------
#  export tests

can_ok('main', 'symbol_without_sigil');

#-----------------------------------------------------------------------------
#  name_without_sigil tests

{
    foreach my $sigil ( q<>, qw< $ @ % * & > ) {
        my $symbol = "${sigil}foo";
        is(
            symbol_without_sigil($symbol),
            'foo',
            "symbol_without_sigil($symbol)",
        );
    }
}

#-----------------------------------------------------------------------------

# ensure we return true if this test is loaded by
# t/05_utils_ppi.t_without_optional_dependencies.t
1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
