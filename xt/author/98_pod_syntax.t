#!perl

##############################################################################
#     $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/xt/author/98_pod_syntax.t $
#    $Date: 2011-03-26 16:16:47 -0500 (Sat, 26 Mar 2011) $
#   $Author: clonezone $
# $Revision: 4051 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use Perl::Critic::TestUtils qw{ starting_points_including_examples };

use Test::More;

#-----------------------------------------------------------------------------

our $VERSION = '1.114';

#-----------------------------------------------------------------------------

use Test::Pod 1.00;

all_pod_files_ok( all_pod_files( starting_points_including_examples() ) );

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
