##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Policy/ControlStructures/ProhibitPostfixControls.pm $
#     $Date: 2008-07-21 19:37:38 -0700 (Mon, 21 Jul 2008) $
#   $Author: clonezone $
# $Revision: 2606 $
##############################################################################

package Perl::Critic::Policy::ControlStructures::ProhibitPostfixControls;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :characters :severities :data_conversion :classification };
use base 'Perl::Critic::Policy';

our $VERSION = '1.089';

#-----------------------------------------------------------------------------

Readonly::Hash my %PAGES_OF => (
    if      => [ 93, 94 ],
    unless  => [ 96, 97 ],
    until   => [ 96, 97 ],
    for     => [ 96     ],
    foreach => [ 96     ],
    while   => [ 96     ],
);

# These functions can have postfix 'if'.
my @DEFAULT_FLOW_CONTROL = qw( warn die carp croak cluck confess goto exit );

#-----------------------------------------------------------------------------

sub supported_parameters {
    return (
        {
            name               => 'allow',
            description        => 'The permitted postfix controls.',
            default_string     => $EMPTY,
            behavior           => 'enumeration',
            enumeration_values => [ sort keys %PAGES_OF ],
            enumeration_allow_multiple_values   => 1,
        },
        {
            name               => 'flowcontrol',
            description        => 'The exempt flow control functions.',
            default_string     => 'carp cluck confess croak die exit goto warn',
            behavior           => 'string list',
        },
    );
}

sub default_severity { return $SEVERITY_LOW         }
sub default_themes   { return qw(core pbp cosmetic) }
sub applies_to       { return 'PPI::Token::Word'    }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    my $expl = $PAGES_OF{$elem};
    return if not $expl;

    return if is_hash_key($elem);
    return if is_method_call($elem);
    return if is_subroutine_name($elem);
    return if is_included_module_name($elem);
    return if is_package_declaration($elem);

    # Skip controls that are allowed
    return if exists $self->{_allow}->{$elem};

    # Skip Compound variety (these are good)
    my $stmnt = $elem->statement();
    return if !$stmnt;
    return if $stmnt->isa('PPI::Statement::Compound');

    # Handle special cases
    if ( $elem eq 'if' ) {
        # Postfix 'if' allowed with loop breaks, or other
        # flow-controls like 'die', 'warn', and 'croak'
        return if $stmnt->isa('PPI::Statement::Break');
        return if defined $self->{_flowcontrol}{ $stmnt->schild(0) };
    }

    # If we get here, it must be postfix.
    my $desc = qq{Postfix control "$elem" used};
    return $self->violation( $desc, $expl, $elem );
}

1;

__END__

=pod

=for stopwords flowcontrol

=head1 NAME

Perl::Critic::Policy::ControlStructures::ProhibitPostfixControls - Write C<if($condition){ do_something() }> instead of C<do_something() if $condition>.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic|Perl::Critic>
distribution.


=head1 DESCRIPTION

Conway discourages using postfix control structures (C<if>, C<for>,
C<unless>, C<until>, C<while>) because they hide control flow.  The
C<unless> and C<until> controls are particularly evil because they
lead to double-negatives that are hard to comprehend.  The only
tolerable usage of a postfix C<if> is when it follows a loop break
such as C<last>, C<next>, C<redo>, or C<continue>.

    do_something() if $condition;         #not ok
    if($condition){ do_something() }      #ok

    do_something() while $condition;      #not ok
    while($condition){ do_something() }   #ok

    do_something() unless $condition;     #not ok
    do_something() unless ! $condition;   #really bad
    if(! $condition){ do_something() }    #ok

    do_something() until $condition;      #not ok
    do_something() until ! $condition;    #really bad
    while(! $condition){ do_something() } #ok

    do_something($_) for @list;           #not ok

    LOOP:
    for my $n (0..100){
        next if $condition;               #ok
        last LOOP if $other_condition;    #also ok
    }

=head1 CONFIGURATION

A set of constructs to be ignored by this policy can specified by
giving a value for 'allow' of a string of space-delimited keywords:
C<if>, C<for>, C<unless>, C<until>, and/or C<while>.  An example of
specifying allowed flow-control structures in a F<.perlcriticrc> file:

    [ControlStructures::ProhibitPostfixControls]
    allow = for if until

By default, all postfix control keywords are prohibited.

The set of flow-control functions that are exempt from the restriction
can also be configured with the 'flowcontrol' directive in your
F<.perlcriticrc> file:

    [ControlStructures::ProhibitPostfixControls]
    flowcontrol = warn die carp croak cluck confess goto exit

=head1 NOTES

The C<die>, C<croak>, and C<confess> functions are frequently used as
flow-controls just like C<next> or C<last>.  So this Policy does
permit you to use a postfix C<if> when the statement begins with one
of those functions.  It is also pretty common to use C<warn>, C<carp>,
and C<cluck> with a postfix C<if>, so those are allowed too.


=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2008 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
