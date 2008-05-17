##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Policy/TestingAndDebugging/ProhibitNoWarnings.pm $
#     $Date: 2008-05-17 00:26:31 -0500 (Sat, 17 May 2008) $
#   $Author: clonezone $
# $Revision: 2340 $
##############################################################################

package Perl::Critic::Policy::TestingAndDebugging::ProhibitNoWarnings;

use strict;
use warnings;
use Readonly;

use List::MoreUtils qw(all);

use Perl::Critic::Utils qw{ :characters :severities :data_conversion };
use base 'Perl::Critic::Policy';

our $VERSION = '1.083_002';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{Warnings disabled};
Readonly::Scalar my $EXPL => [ 431 ];

#-----------------------------------------------------------------------------

sub supported_parameters {
    return (
        {
            name            => 'allow',
            description     => 'Permitted warning categories.',
            default_string  => $EMPTY,
            parser          => \&_parse_allow,
        },
    );
}

sub default_severity { return $SEVERITY_HIGH            }
sub default_themes   { return qw( core bugs pbp )       }
sub applies_to       { return 'PPI::Statement::Include' }

#-----------------------------------------------------------------------------

sub _parse_allow {
    my ($self, $parameter, $config_string) = @_;

    $self->{_allow} = {};

    if( defined $config_string ) {
        my $allowed = lc $config_string; #String of words
        my %allowed = hashify( $allowed =~ m/ (\w+) /gmx );
        $self->{_allow} = \%allowed;
    }

    return;
}

#-----------------------------------------------------------------------------

sub violates {

    my ( $self, $elem, undef ) = @_;

    return if $elem->type()   ne 'no';
    return if $elem->pragma() ne 'warnings';

    #Arguments to 'no warnings' are usually a list of literals or a
    #qw() list.  Rather than trying to parse the various PPI elements,
    #I just use a regex to split the statement into words.  This is
    #kinda lame, but it does the trick for now.

    # TODO consider: a possible alternate implementation:
    #   my $re = join q{|}, keys %{$self->{allow}};
    #   return if $re && $stmnt =~ m/\b(?:$re)\b/mx;
    # May need to detaint for that to work...  Not sure.

    my $stmnt = $elem->statement();
    return if !$stmnt;
    my @words = $stmnt =~ m/ ([[:lower:]]+) /gmx;
    @words = grep { $_ ne 'qw' && $_ ne 'no' && $_ ne 'warnings' } @words;
    return if all { exists $self->{_allow}->{$_} } @words;

    #If we get here, then it must be a violation
    return $self->violation( $DESC, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::TestingAndDebugging::ProhibitNoWarnings - Prohibit various flavors of C<no warnings>.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic> distribution.


=head1 DESCRIPTION

There are good reasons for disabling certain kinds of warnings.  But if you
were wise enough to C<use warnings> in the first place, then it doesn't make
sense to disable them completely.  By default, any C<no warnings> statement
will violate this policy.  However, you can configure this Policy to allow
certain types of warnings to be disabled (See L<Configuration>).  A bare C<no
warnings> statement will always raise a violation.

=head1 CONFIGURATION

The permitted warning types can be configured via the C<allow> option.  The
value is a list of whitespace-delimited warning types that you want to be able
to disable.  See L<perllexwarn> for a list of possible warning types.  An
example of this customization:

  [TestingAndDebugging::ProhibitNoWarnings]
  allow = uninitialized once

=head1 SEE ALSO

L<Perl::Critic::Policy::TestingAndDebugging::RequireUseWarnings>

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2008 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  The full text of this license can be found in
the LICENSE file included with this module

=cut

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
