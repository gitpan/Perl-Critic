##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-1.105_03/lib/Perl/Critic/Policy/InputOutput/RequireCheckedOpen.pm $
#     $Date: 2010-03-21 18:17:38 -0700 (Sun, 21 Mar 2010) $
#   $Author: thaljef $
# $Revision: 3794 $
##############################################################################

package Perl::Critic::Policy::InputOutput::RequireCheckedOpen;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities :classification };
use base 'Perl::Critic::Policy';

our $VERSION = '1.105_03';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{Return value of "open" ignored};
Readonly::Scalar my $EXPL => q{Check the return value of "open" for success};

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                     }
sub default_severity     { return $SEVERITY_MEDIUM       }
sub default_themes       { return qw( core maintenance ) }
sub applies_to           { return 'PPI::Token::Word'     }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    return if $elem ne 'open';
    return if ! is_unchecked_call( $elem );

    return $self->violation( $DESC, $EXPL, $elem );

}


1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords autodie

=head1 NAME

Perl::Critic::Policy::InputOutput::RequireCheckedOpen - Write C<< my $error = open $fh, $mode, $filename; >> instead of C<< open $fh, $mode, $filename; >>.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic|Perl::Critic>
distribution.


=head1 DESCRIPTION

The perl builtin I/O function C<open> returns a false value on
failure. That value should always be checked to ensure that the open
was successful.


    my $error = open( $filehandle, $mode, $filename );                  # ok
    open( $filehandle, $mode, $filename ) or die "unable to open: $!";  # ok
    open( $filehandle, $mode, $filename );                              # not ok

    use autodie;
    open $filehandle, $mode, $filename;                                 # ok

You can use L<autodie|autodie>, L<Fatal|Fatal>, or
L<Fatal::Exception|Fatal::Exception> to get around
this.  Currently, L<autodie|autodie> is not properly treated as a pragma; its
lexical effects aren't taken into account.


=head1 CONFIGURATION

This Policy is not configurable except for the standard options.


=head1 AUTHOR

Andrew Moore <amoore@mooresystems.com>

=head1 ACKNOWLEDGMENTS

This policy module is based heavily on policies written by Jeffrey
Ryan Thalhammer <jeff@imaginative-software.com>.

=head1 COPYRIGHT

Copyright (c) 2007-2010 Andrew Moore.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

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
