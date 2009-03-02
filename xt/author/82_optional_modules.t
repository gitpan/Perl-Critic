#!/usr/bin/perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/xt/author/82_optional_modules.t $
#     $Date: 2009-03-01 17:40:39 -0600 (Sun, 01 Mar 2009) $
#   $Author: clonezone $
# $Revision: 3205 $
##############################################################################

use 5.006001;
use strict;
use warnings;

use Readonly; # So we don't barf when we hit Readonly::XS below.

use lib 'inc';
use Perl::Critic::BuildUtilities qw< recommended_module_versions >;

use Test::More;

#-----------------------------------------------------------------------------

our $VERSION = '1.097_002';

#-----------------------------------------------------------------------------

# Certain developers change perl installations on occasion and don't always
# have all the optional modules installed.  Make sure that they know that they
# don't.  :]

my %module_versions = (
    recommended_module_versions(),
    'Test::Deep'            => 0,
    'Test::Memory::Cycle'   => 0,
    'Test::Pod'             => 0,
    'Test::Pod::Coverage'   => 0,
    'Test::Without::Module' => 0,
);

plan tests => scalar keys %module_versions;

foreach my $module (sort keys %module_versions) {
    use_ok( $module, $module_versions{$module} );
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
