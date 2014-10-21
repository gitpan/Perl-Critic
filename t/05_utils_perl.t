#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/branches/Perl-Critic-1.106/t/05_utils_perl.t $
#     $Date: 2010-05-10 22:15:46 -0500 (Mon, 10 May 2010) $
#   $Author: clonezone $
# $Revision: 3809 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use Readonly;

use Test::More tests => 8;

#-----------------------------------------------------------------------------

our $VERSION = '1.106';

#-----------------------------------------------------------------------------

BEGIN {
    use_ok('Perl::Critic::Utils::Perl', qw{ :all } );
}

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
