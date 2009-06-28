#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/t/17_optimizations.t $
#     $Date: 2009-06-27 20:02:58 -0400 (Sat, 27 Jun 2009) $
#   $Author: clonezone $
# $Revision: 3373 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use PPI::Document;
use Test::More;

#-----------------------------------------------------------------------------

our $VERSION = '1.099_002';

#-----------------------------------------------------------------------------

my $need_ppi_version = '1.203';
plan( skip_all => "Optimizations only work with PPI version $need_ppi_version.")
  if $PPI::Document::VERSION ne $need_ppi_version;

#-----------------------------------------------------------------------------

plan( tests => 2 );
use_ok('Perl::Critic::PPIx::Optimized');
my $code = q{print "Hello World" && wave( $hand );};  ## no critic (RequireInterpolation)
my $doc = PPI::Document->new(\$code);
my $found_elems = PPI::Node::find($doc, 'PPI::Element');
my @descendant_elems = $doc->descendants();
is_deeply($found_elems, \@descendant_elems, 'find() and descdendants() return the same thing.');

#-----------------------------------------------------------------------------

# ensure we run true if this test is loaded by
# t/17_optimizations.t_without_optional_dependencies.t
1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
