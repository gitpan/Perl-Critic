##################################################################
#     $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-0.18_01/t/20_policies_miscellanea.t $
#    $Date: 2006-08-06 16:13:55 -0700 (Sun, 06 Aug 2006) $
#   $Author: thaljef $
# $Revision: 556 $
##################################################################

use strict;
use warnings;
use Test::More tests => 10;

# common P::C testing tools
use Perl::Critic::TestUtils qw(pcritique);
Perl::Critic::TestUtils::block_perlcriticrc();

my $code ;
my $policy;
my %config;

#----------------------------------------------------------------

$code = <<'END_PERL';
#just a comment
$foo = "bar";
$baz = qq{nuts};
END_PERL

$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code), 3, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
# $Revision: 556 $
# $Source$
# $Date: 2006-08-06 16:13:55 -0700 (Sun, 06 Aug 2006) $
END_PERL

$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code), 0, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
'$Revision: 556 $'
'$Source: foo/bar $'
'$Date: 2006-08-06 16:13:55 -0700 (Sun, 06 Aug 2006) $'
END_PERL

$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code), 0, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
q{$Revision: 556 $}
q{$Source: foo/bar $}
q{$Date: 2006-08-06 16:13:55 -0700 (Sun, 06 Aug 2006) $}
END_PERL

$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code), 0, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
q{$Revision: 556 $}
q{$Author: thaljef $}
q{$Id: whatever $}
END_PERL

%config = (keywords => 'Revision Author Id');
$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code, \%config), 0, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
#nothing here!
END_PERL

%config = (keywords => 'Author Id');
$policy = 'Miscellanea::RequireRcsKeywords';
is( pcritique($policy, \$code, \%config), 2, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
tie $scalar, 'Some::Class';
tie @array, 'Some::Class';
tie %hash, 'Some::Class';

tie ($scalar, 'Some::Class');
tie (@array, 'Some::Class');
tie (%hash, 'Some::Class');

tie $scalar, 'Some::Class', @args;
tie @array, 'Some::Class', @args;
tie %hash, 'Some::Class' @args;

tie ($scalar, 'Some::Class', @args);
tie (@array, 'Some::Class', @args);
tie (%hash, 'Some::Class', @args);
END_PERL

$policy = 'Miscellanea::ProhibitTies';
is( pcritique($policy, \$code, \%config), 12, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
$hash{tie} = 'foo';
%hash = ( tie => 'knot' );
$object->tie();
END_PERL

$policy = 'Miscellanea::ProhibitTies';
is( pcritique($policy, \$code, \%config), 0, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
format STDOUT =
@<<<<<<   @||||||   @>>>>>>
"left",   "middle", "right"
.

format =
@<<<<<<   @||||||   @>>>>>>
"foo",   "bar",     "baz"
.

format REPORT_TOP =
                                Passwd File
Name                Login    Office   Uid   Gid Home
------------------------------------------------------------------
.
format REPORT =
@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<
$name,              $login,  $office,$uid,$gid, $home
.

END_PERL

$policy = 'Miscellanea::ProhibitFormats';
is( pcritique($policy, \$code, \%config), 4, $policy);

#----------------------------------------------------------------

$code = <<'END_PERL';
$hash{format} = 'foo';
%hash = ( format => 'baz' );
$object->format();
END_PERL

$policy = 'Miscellanea::ProhibitFormats';
is( pcritique($policy, \$code, \%config), 0, $policy);
