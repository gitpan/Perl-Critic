##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-0.21_01/lib/Perl/Critic/Policy/Miscellanea/ProhibitFormats.pm $
#     $Date: 2006-12-03 23:40:05 -0800 (Sun, 03 Dec 2006) $
#   $Author: thaljef $
# $Revision: 1030 $
##############################################################################

package Perl::Critic::Policy::Miscellanea::ProhibitFormats;

use strict;
use warnings;
use Perl::Critic::Utils;
use base 'Perl::Critic::Policy';

our $VERSION = 0.21_01;

#-----------------------------------------------------------------------------

my $desc = q{Format used};
my $expl = [ 449 ];

#-----------------------------------------------------------------------------

sub default_severity { return $SEVERITY_MEDIUM     }
sub default_themes    { return qw( unreliable pbp ) }
sub applies_to       { return 'PPI::Token::Word'   }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;
    return if $elem ne 'format';
    return if ! is_function_call( $elem );
    return $self->violation( $desc, $expl, $elem );
}


1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Miscellanea::ProhibitFormats

=head1 DESCRIPTION

Formats are one of the oldest features of Perl.  Unfortunately, they suffer
from several limitations.  Formats are static and cannot be easily defined
at run time.  Also, formats depend on several obscure global variables.

For more modern reporting tools, consider using one of the template frameworks
like L<Template> or try the L<Perl6::Form> module.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2006 Jeffrey Ryan Thalhammer.  All rights reserved.

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
