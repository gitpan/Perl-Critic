##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Exception/Fatal/PolicyDefinition.pm $
#     $Date: 2008-06-06 00:48:04 -0500 (Fri, 06 Jun 2008) $
#   $Author: clonezone $
# $Revision: 2416 $
##############################################################################

package Perl::Critic::Exception::Fatal::PolicyDefinition;

use 5.006001;
use strict;
use warnings;

use Readonly;

our $VERSION = '1.085';

#-----------------------------------------------------------------------------

use Exception::Class (
    'Perl::Critic::Exception::Fatal::PolicyDefinition' => {
        isa         => 'Perl::Critic::Exception::Fatal',
        description => 'A bug in a policy was found.',
        alias       => 'throw_policy_definition',
    },
);

#-----------------------------------------------------------------------------

Readonly::Array our @EXPORT_OK => qw< throw_policy_definition >;

#-----------------------------------------------------------------------------


1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Exception::Fatal::PolicyDefinition - A bug in a policy.

=head1 DESCRIPTION

A bug in a policy was found, e.g. it didn't implement a method that it should
have.


=head1 METHODS

Only inherited ones.


=head1 AUTHOR

Elliot Shank <perl@galumph.com>

=head1 COPYRIGHT

Copyright (c) 2007-2008 Elliot Shank.  All rights reserved.

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
