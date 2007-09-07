#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/branches/Perl-Critic-1.076/t/01_config_bad_perlcriticrc.t $
#     $Date: 2007-09-02 20:07:03 -0500 (Sun, 02 Sep 2007) $
#   $Author: clonezone $
# $Revision: 1854 $
##############################################################################


# Test that all the problems in an rc file get reported and not just the first
# one that is found.


use strict;
use warnings;

use English qw{ -no_match_vars };

use Test::More;

use Perl::Critic::PolicyFactory (-test => 1);
use Perl::Critic;

my $test_count = 11;
plan tests => $test_count;

my $profile = 't/01_bad_perlcriticrc';

eval {
    my $critic = Perl::Critic->new( '-profile' => $profile );
};

my $eval_result = $EVAL_ERROR;

ok( $eval_result, 'should get an exception when using a bad rc file' );

SKIP: {
    skip 'because there was no exception', $test_count - 1
        if not $eval_result;

    isa_ok($eval_result, 'Perl::Critic::ConfigErrors', '$EVAL_ERROR');

    SKIP: {
        skip
            q{because the exception wasn't an instance of ConfigErrors},
            $test_count - 2
            if not $eval_result->isa('Perl::Critic::ConfigErrors');

        my @messages = @{ $eval_result->messages() };

        my @parameters = qw{
            exclude
            include
            profile-strictness
            severity
            single-policy
            theme
            top
            verbose
        };

        my %expected_regexes =
            map { $_ => generate_message_regex( $_, $profile ) } @parameters;

        is(
            scalar @messages,
            scalar @parameters,
            'should have received the correct number of error messages'
        );

        while (my ($parameter, $regex) = each %expected_regexes) {
            is(
                ( scalar grep { m/$regex/ } @messages ),
                1,
                "should have received one and only one message for $parameter",
            );
        }
    }
}

sub generate_message_regex {
    my ($parameter, $file) = @_;

    return
        qr/
            \A
            The [ ] value [ ] for [ ]
            "$parameter"
            .*
            found [ ] in [ ] "$file"
        /xms;
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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
