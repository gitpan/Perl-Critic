##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Exception/Fatal.pm $
#     $Date: 2007-12-20 10:00:02 -0600 (Thu, 20 Dec 2007) $
#   $Author: clonezone $
# $Revision: 2062 $
##############################################################################

package Perl::Critic::Exception::Fatal;

use strict;
use warnings;

our $VERSION = '1.081_004';

#-----------------------------------------------------------------------------

use Exception::Class (
    'Perl::Critic::Exception::Fatal' => {
        isa         => 'Perl::Critic::Exception',
        description =>
            'A problem that should cause Perl::Critic to stop running.',
    },
);

#-----------------------------------------------------------------------------

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);

    $self->show_trace(1);

    return $self;
}

#-----------------------------------------------------------------------------

sub full_message {
    my ( $self ) = @_;

    return
          $self->short_class_name()
        . q{: }
        . $self->description()
        . "\n\n"
        . $self->message()
        . "\n\n"
        . gmtime $self->time()
        . "\n\n";
}


1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Exception::Fatal - A problem that should cause L<Perl::Critic> to stop running

=head1 DESCRIPTION

Something went wrong and processing should not continue.  You should
never specifically look for this exception or one of its subclasses.

Note: the constructor invokes L<Exception::Class/"show_trace"> to
force stack-traces to be included in the standard stringification.

This is an abstract class.  It should never be instantiated.


=head1 METHODS

=over

=item C<full_message()>

Overrides L<Exception::Class/"full_message"> to include extra information.


=back


=head1 AUTHOR

Elliot Shank <perl@galumph.com>

=head1 COPYRIGHT

Copyright (c) 2007 Elliot Shank.  All rights reserved.

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
