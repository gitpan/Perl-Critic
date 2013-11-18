package Perl::Critic::Policy::BuiltinFunctions::RequireBlockMap;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

our $VERSION = '1.121_01';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{Expression form of "map"};
Readonly::Scalar my $EXPL => [ 169 ];

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                  }
sub default_severity     { return $SEVERITY_HIGH      }
sub default_themes       { return qw( core bugs pbp ) }
sub applies_to           { return 'PPI::Token::Word'  }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    return if $elem ne 'map';
    return if ! is_function_call($elem);

    my $arg = first_arg($elem);
    return if !$arg;
    return if $arg->isa('PPI::Structure::Block');

    return $self->violation( $DESC, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::BuiltinFunctions::RequireBlockMap - Write C<map { /$pattern/ } @list> instead of C<map /$pattern/, @list>.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic|Perl::Critic>
distribution.

=head1 DESCRIPTION

The expression forms of C<grep> and C<map> are awkward and hard to
read.  Use the block forms instead.

    @matches = grep   /pattern/,   @list;        #not ok
    @matches = grep { /pattern/ }  @list;        #ok

    @mapped = map   transform($_),   @list;      #not ok
    @mapped = map { transform($_) }  @list;      #ok

=head1 CONFIGURATION

This Policy is not configurable except for the standard options.

=head1 SEE ALSO

L<Perl::Critic::Policy::BuiltinFunctions::ProhibitStringyEval|Perl::Critic::Policy::BuiltinFunctions::ProhibitStringyEval>

L<Perl::Critic::Policy::BuiltinFunctions::RequireBlockGrep|Perl::Critic::Policy::BuiltinFunctions::RequireBlockGrep>

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>


=head1 COPYRIGHT

Copyright (c) 2005-2013 Imaginative Software Systems.  All rights reserved.

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
