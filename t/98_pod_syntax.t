#!perl

##############################################################################
#     $URL: http://perlcritic.tigris.org/svn/perlcritic/branches/Perl-Critic-PPI-1.204/t/98_pod_syntax.t $
#    $Date: 2009-07-22 10:19:39 -0700 (Wed, 22 Jul 2009) $
#   $Author: clonezone $
# $Revision: 3435 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use English qw< -no_match_vars >;

use Perl::Critic::TestUtils qw{ starting_points_including_examples };

use Test::More;

#-----------------------------------------------------------------------------

our $VERSION = '1.101_003';

#-----------------------------------------------------------------------------

eval 'use Test::Pod 1.00';
plan skip_all => 'Test::Pod 1.00 required for testing POD' if $EVAL_ERROR;
all_pod_files_ok( all_pod_files( starting_points_including_examples() ) );

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
