##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-1.06/lib/Perl/Critic/PolicyListing.pm $
#     $Date: 2007-06-27 23:50:20 -0700 (Wed, 27 Jun 2007) $
#   $Author: thaljef $
# $Revision: 1709 $
#        ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
##############################################################################

package Perl::Critic::PolicyListing;

use strict;
use warnings;
use Carp qw(carp confess);
use English qw(-no_match_vars);
use Perl::Critic::Policy qw();
use overload ( q{""} => 'to_string');

our $VERSION = 1.06;

#-----------------------------------------------------------------------------

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;
    my $policies = $args{-policies} || [];
    $self->{_policies} = [ sort _by_type @{ $policies } ];
    return $self;
}

#-----------------------------------------------------------------------------

sub to_string {
    my $self = shift;
    Perl::Critic::Policy::set_format( "%s %p [%t]\n" );
    return join q{}, map { "$_" } @{ $self->{_policies} };
}

#-----------------------------------------------------------------------------

sub _by_type { return ref $a cmp ref $b }

1;

__END__

=pod

=head1 NAME

Perl::Critic::PolicyListing - Display information about Policies

=head1 DESCRIPTION

This is a helper class that formats a set of Policy objects for
pretty-printing.  There are no user-serviceable parts here.

=head1 CONSTRUCTOR

=over 8

=item C<< new( -policies => \@POLICY_OBJECTS ) >>

Returns a reference to a new C<Perl::Critic::PolicyListing> object.

=back

=head1 METHODS

=over 8

=item to_string()

Returns a string representation of this C<PolicyListing>.  See
L<"OVERLOADS"> for more information.

=back

=head1 OVERLOADS

When a L<Perl::Critic::ProfilePrototype> is evaluated in string context, it
produces a one-line summary of the default severity, policy name, and default
themes for each L<Perl::Critic::Policy> object that was given to the
constructor of this C<PolicyListing>.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2007 Jeffrey Ryan Thalhammer.  All rights reserved.

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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
