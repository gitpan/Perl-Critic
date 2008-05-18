##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic/lib/Perl/Critic/Policy/CodeLayout/ProhibitParensWithBuiltins.pm $
#     $Date: 2008-05-17 20:03:55 -0500 (Sat, 17 May 2008) $
#   $Author: clonezone $
# $Revision: 2349 $
##############################################################################

package Perl::Critic::Policy::CodeLayout::ProhibitParensWithBuiltins;

use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{
    :severities :data_conversion :classification :language
};
use base 'Perl::Critic::Policy';

our $VERSION = '1.083_003';

#-----------------------------------------------------------------------------

Readonly::Array my @ALLOW => qw( my our local return );
Readonly::Hash my %ALLOW => hashify( @ALLOW );

Readonly::Scalar my $DESC  => q{Builtin function called with parentheses};
Readonly::Scalar my $EXPL  => [ 13 ];

Readonly::Scalar my $PRECENDENCE_OF_LIST => precedence_of(q{>>}) + 1;
Readonly::Scalar my $PRECEDENCE_OF_COMMA => precedence_of(q{,});

#-----------------------------------------------------------------------------
# These are all the functions that are considered named unary
# operators.  These frequently require parentheses because they have lower
# precedence than ordinary function calls.

Readonly::Array my @NAMED_UNARY_OPS => qw(
    alarm           glob        rand
    caller          gmtime      readlink
    chdir           hex         ref
    chroot          int         require
    cos             lc          return
    defined         lcfirst     rmdir
    delete          length      scalar
    do              localtime   sin
    eval            lock        sleep
    exists          log         sqrt
    exit            lstat       srand
    getgrp          my          stat
    gethostbyname   oct         uc
    getnetbyname    ord         ucfirst
    getprotobyname  quotemeta   umask
                                undef
);
Readonly::Hash my %NAMED_UNARY_OPS => hashify( @NAMED_UNARY_OPS );

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                      }
sub default_severity     { return $SEVERITY_LOWEST        }
sub default_themes       { return qw( core pbp cosmetic ) }
sub applies_to           { return 'PPI::Token::Word'      }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;

    return if exists $ALLOW{$elem};
    return if not is_perl_builtin($elem);
    return if not is_function_call($elem);

    my $sib = $elem->snext_sibling();
    return if !$sib;
    if ( $sib->isa('PPI::Structure::List') ) {

        my $elem_after_parens = $sib->snext_sibling();

        # EXCEPTION 1: If the function is a named unary and there is an
        # operator with higher precedence right after the parentheses.
        # Example: int( 1.5 ) + 0.5;

        if ( _is_named_unary( $elem ) && $elem_after_parens ){
            # Smaller numbers mean higher precedence
            my $precedence = precedence_of( $elem_after_parens );
            return if defined $precedence && $precedence < $PRECENDENCE_OF_LIST;
        }

        # EXCEPTION 2, If there is an operator immediately adfter the
        # parentheses, and that operator has precedence greater than
        # or equal to a comma.
        # Example: join($delim, @list) . "\n";

        if ( $elem_after_parens ){
            # Smaller numbers mean higher precedence
            my $precedence = precedence_of( $elem_after_parens );
            return if defined $precedence && $precedence <= $PRECEDENCE_OF_COMMA;
        }

        # EXCEPTION 3: If the first operator within the parentheses is '='
        # Example: chomp( my $foo = <STDIN> );

        if ( my $first_op = $sib->find_first('PPI::Token::Operator') ){
            return if $first_op eq q{=};
        }

        # If we get here, it must be a violation
        return $self->violation( $DESC, $EXPL, $elem );
    }
    return;    #ok!
}

#-----------------------------------------------------------------------------

sub _is_named_unary {
    my $elem = shift;
    return exists $NAMED_UNARY_OPS{$elem->content};
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords disambiguates

=head1 NAME

Perl::Critic::Policy::CodeLayout::ProhibitParensWithBuiltins - Write C<open $handle, $path> instead of C<open($handle, $path)>.

=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic> distribution.


=head1 DESCRIPTION

Conway suggests that all built-in functions be called without
parentheses around the argument list.  This reduces visual clutter and
disambiguates built-in functions from user functions.  Exceptions are
made for C<my>, C<local>, and C<our> which require parentheses when
called with multiple arguments.

  open($handle, '>', $filename); #not ok
  open $handle, '>', $filename;  #ok

  split(/$pattern/, @list); #not ok
  split /$pattern/, @list;  #ok


=head1 CONFIGURATION

This Policy is not configurable except for the standard options.


=head1 NOTES

Coding with parentheses can sometimes lead to verbose and awkward
constructs, so I think the intent of Conway's guideline is to remove
only the F<unnecessary> parentheses.  This policy makes exceptions for
some common situations where parentheses are usually required.
However, you may find other situations where the parentheses are
necessary to enforce precedence, but they cause still violations.  In
those cases, consider using the '## no critic' comments to silence
Perl::Critic.

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
