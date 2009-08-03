#!perl

##############################################################################
#     $URL: http://perlcritic.tigris.org/svn/perlcritic/branches/Perl-Critic-PPI-1.204/t/07_perlcritic.t $
#    $Date: 2009-08-03 01:23:03 -0500 (Mon, 03 Aug 2009) $
#   $Author: clonezone $
# $Revision: 3460 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use File::Spec;

use Test::More tests => 1;

#-----------------------------------------------------------------------------

our $VERSION = '1.102';

#-----------------------------------------------------------------------------

my $perlcritic = File::Spec->catfile( qw(blib script perlcritic) );
if (not -e $perlcritic) {
    $perlcritic = File::Spec->catfile( qw(bin perlcritic) )
}

require_ok($perlcritic);

#-----------------------------------------------------------------------------

# ensure we run true if this test is loaded by
# t/07_perlcritic.t_without_optional_dependencies.t
1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
