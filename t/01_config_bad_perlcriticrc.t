#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/branches/Perl-Critic-PPI-1.204/t/01_config_bad_perlcriticrc.t $
#     $Date: 2009-07-22 10:19:39 -0700 (Wed, 22 Jul 2009) $
#   $Author: clonezone $
# $Revision: 3435 $
##############################################################################


# Test that all the problems in an rc file get reported and not just the first
# one that is found.


use 5.006001;
use strict;
use warnings;

use English qw< -no_match_vars >;
use Readonly;

use Test::More;

use Perl::Critic::PolicyFactory (-test => 1);
use Perl::Critic;

#-----------------------------------------------------------------------------

our $VERSION = '1.101_003';

#-----------------------------------------------------------------------------

my @color_severity_params;
my $skip_color_severity = eval { require Term::ANSIColor; 1; } ? undef :
    'Term::ANSIColor is not available';
# We can not do the color-severity tests if Term::ANSIColor is not available,
# because without Term::ANSIColor the parameters are not validated, so any
# value will be accepted and we will not get any errors from them.
$skip_color_severity
    or @color_severity_params = qw<
        color-severity-highest
        color-severity-high
        color-severity-medium
        color-severity-low
        color-severity-lowest
    >;

plan tests => 13 + scalar @color_severity_params;

Readonly::Scalar my $PROFILE => 't/01_bad_perlcriticrc';
Readonly::Scalar my $NO_ENABLED_POLICIES_MESSAGE =>
    q<There are no enabled policies.>;
Readonly::Scalar my $INVALID_PARAMETER_MESSAGE =>
    q<The BuiltinFunctions::RequireBlockGrep policy doesn't take a "no_such_parameter" option.>;
Readonly::Scalar my $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX =>
    q<The value for the Documentation::RequirePodSections "source" option ("Zen_and_the_Art_of_Motorcycle_Maintenance") is not one of the allowed values: >;

eval {
    my $critic = Perl::Critic->new( '-profile' => $PROFILE );
};

my $test_passed;
my $eval_result = $EVAL_ERROR;

$test_passed =
    ok( $eval_result, 'should get an exception when using a bad rc file' );

die "No point in continuing.\n" if not $test_passed;

$test_passed =
    isa_ok(
        $eval_result,
        'Perl::Critic::Exception::AggregateConfiguration',
        '$EVAL_ERROR',  ## no critic (RequireInterpolationOfMetachars)
    );

if ( not $test_passed ) {
    diag( $eval_result );
    die "No point in continuing.\n";
}

my @exceptions = @{ $eval_result->exceptions() };

my @parameters = (
    qw<
        exclude
        include
        profile-strictness
        severity
        single-policy
        theme
        top
        verbose
    >,
    @color_severity_params,
);

my %expected_regexes =
    map
        { $_ => generate_global_message_regex( $_, $PROFILE ) }
        @parameters;

my $expected_exceptions = 1 + scalar @parameters;
is(
    scalar @exceptions,
    $expected_exceptions,
    'should have received the correct number of exceptions'
);
if (@exceptions != $expected_exceptions) {
    foreach my $exception (@exceptions) {
        diag "Exception: $exception";
    }
}

while (my ($parameter, $regex) = each %expected_regexes) {
    is(
        ( scalar grep { m/$regex/xms } @exceptions ),
        1,
        "should have received one and only one exception for $parameter",
    );
}

is(
    ( scalar grep { $INVALID_PARAMETER_MESSAGE eq $_ } @exceptions ),
    0,
    'should not have received an extra-parameter exception',
);

# Test that we get an exception for bad individual policy configuration.
# The selection of RequirePodSections is arbitrary.
is(
    ( scalar grep { is_require_pod_sections_source_exception($_) } @exceptions ),
    1,
    'should have received an invalid source exception for RequirePodSections',
);

sub generate_global_message_regex {
    my ($parameter, $file) = @_;

    return
        qr<
            \A
            The [ ] value [ ] for [ ] the [ ] global [ ]
            "$parameter"
            .*
            found [ ] in [ ] "$file"
        >xms;
}

sub is_require_pod_sections_source_exception {
    my ($exception) = @_;

    my $prefix =
        substr
            $exception,
            0,
            length $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX;

    return $prefix eq $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX;
}

#-----------------------------------------------------------------------------

# ensure we run true if this test is loaded by
# t/01_config_bad_perlcriticrc.t_without_optional_dependencies.t
1;


##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
