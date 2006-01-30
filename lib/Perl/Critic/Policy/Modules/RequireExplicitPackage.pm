#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Policy/Modules/RequireExplicitPackage.pm $
#     $Date: 2006-01-04 20:29:14 -0800 (Wed, 04 Jan 2006) $
#   $Author: thaljef $
# $Revision: 209 $
########################################################################

package Perl::Critic::Policy::Modules::RequireExplicitPackage;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

our $VERSION = '0.14';
$VERSION = eval $VERSION;    ## no critic

#----------------------------------------------------------------------------

my $expl = q{Violates encapsulation};
my $desc = q{Code not contained in explicit package};

#----------------------------------------------------------------------------

sub default_severity { return $SEVERITY_HIGH  }
sub applies_to { return 'PPI::Document' }

#----------------------------------------------------------------------------

sub new {
    my ( $class, %args ) = @_;
    my $self = bless {}, $class;

    #Set config, if defined
    $self->{_exempt_scripts} =
      defined $args{exempt_scripts} ? $args{exempt_scripts} : 1;

    return $self;
}

#----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    # You can configure this policy to exclude scripts
    return if $self->{_exempt_scripts} && _is_script($doc);

    my $match = $doc->find_first( sub { $_[1]->significant() } ) || return;
    return if $match->isa('PPI::Statement::Package');  #First is 'package'

    # Must be a violation...
    my $sev = $self->get_severity();
    return Perl::Critic::Violation->new( $desc, $expl, $match, $sev );
}

sub _is_script {
    my $doc = shift;
    my $first_comment = $doc->find_first('PPI::Token::Comment') || return;
    $first_comment->location->[0] == 1 || return;
    return $first_comment =~ m{ \A \#\! }mx;
}

1;

__END__

#----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Modules::RequireExplicitPackage

=head1 DESCRIPTION

Conway doesn't specifically mention this, but I've come across it in
my own work.  In general, the first statement of any Perl module or
library should be a C<package> statement.  Otherwise, all the code
that comes before the C<package> statement is getting executed in the
caller's package, and you have no idea who that is.  Good
encapsulation and common decency require your module to keep its
innards to itself.

As for scripts, most people understand that the default package is
C<main>, so this Policy doesn't apply to files that begin with a perl
shebang.  But it you want to require an explicit C<package>
declaration in all files, including scripts, then add the following to
your F<.perlcriticrc> file

  [Modules::RequireExplicitPackage]
  exempt_scripts = 0

There are some valid reasons for not having a C<package> statement at
all.  But make sure you understand them before assuming that you
should do it too.

=head1 IMPORTANT CHANGES

This policy was formerly called "ProhibitUnpackagedCode" which sounded
a bit odd.  If you get lots of "Cannot load policy module" errors,
then you probably need to change "ProhibitUnpackagedCode" to
"RequireExplicitPackage" in your F<.perlcriticrc> file.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005-2006 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
