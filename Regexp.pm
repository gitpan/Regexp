package Regexp;

use vars qw(@EXPORT_OK @ISA $VERSION);
use overload '""' => 'stringify';

BEGIN {
    require DynaLoader;
    require Exporter;

    @ISA = qw(Exporter DynaLoader);

    @EXPORT_OK = qw(FOLD MULTILINE SINGLELINE GLOBAL EXTENDED NOCASE);

    $VERSION = "0.004";

    bootstrap Regexp $VERSION;
}

sub stringify { shift->pattern }


1;

__END__

=head1 NAME

Regexp - Object Oriented interface to perl's regular expression code

=head1 SYNOPSIS

    use Regexp;

    my $re = new Regexp q/Some Pattern/;

    if (match $re "Some String") { ... }

    $re->prematch

    $re->postmatch

    $re->pattern

    my @info  = $re->backref
    my $count = $re->backref


=head1 DESCRIPTION

=head1 CONSTRUCTORS

=over 4

=item new ( PATTERN [, FLAGS ] )

C<new> compiles the given C<PATTERN> into a new Regexp object.
See L<perlre> for a description of C<PATTERN>

A second optional parameter, C<FLAGS>, can be used to control how the pattern
is compiled. C<FLAGS> is a numeric value which can be constructed by or-ing
together constants which Regexp conditionally exports. The constants are :

=over 4

=item FOLD

Perform case-insensitive matches. See C</i> in L<perlre>

=item NOCASE

A synonym for FOLD

=item MULTILINE

Treat strings as multiple lines, See C</m> in L<perlre>

=item SINGLELINE

Treat strings as single lines, See C</s> in L<perlre>

=item EXTENDED

Use extended patter formats to increase legibility, See C</x> in L<perlre>

=back

=item current

Returns an object which represents the current (last) pattern.

=back

=head1 METHODS

=over 4

=item minlength

Returns the minimum length that a string has to be before it
will match the regular expression

=item pattern

Returns the pattern text

=item match ( STRING [, OFFSET [, FLAGS]] )

C<match> is like the C<=~> operator in perl. C<STRING> is the string
which the regexp is to be applied. C<OFFEST> and C<FLAGS> are both optional.

In a scalar context C<match> returns a true or false value depending
on whether the match was sucessful. In an array context C<match> returns
an array of the contents of all the backreferences, or an empty array.

C<OFFSET>, if given, directs the regexp code to start trying to match
the regexp at the given offset from the start of C<STRING>

C<FLAGS> is a numeric value which can be constructed by or-ing
together constants which Regexp conditionally exports. The constants are :

=over 4

=item GLOBAL

Match as many times as possible, starting each time where the previous
match ended. See C</g> option in L<perlre>.

If C<match> is called in an array context and the C<GLOBAL> flag is set then
the result will be an array of all the backreferences from all the matches.

=back

=item nparens

Returns the number of parentheses in the expression

=item lastparen

Returns the number of the last parentheses that matched.

=item backref ( [INDEX] )

The result of C<backref> is sensetive to how it is called.

If called with a single argument then C<backref> returns the text
for the given backreference in the pattern. Backreferences are
numbered from 1 as with C<$1..$9>.

If called with a single argument of zero, then C<backref> will
return the text of the last match. (Same as C<lastmatch>)

If called without any arguments, and in a scalar context, then
C<backref> will return the number of backreferences that there are
in the C<Regexp> object. (Same as C<nparens>)

If called without any arguments, and in aN array context, then
C<backref> will return a list of all the backreference values
from the last match.


=item prematch

Returns the text preceeding the text of the last match

=item lastmatch

Returns the text of the last match

=item postmatch

Returns the text following the text of the last match

=item startpos

Returns the offset into the B<original> string to the start of the text
in the last match.

=item length

Returns the length of the text in the last match

=item endpos

Returns the offset into the B<original> string to the end of the text
in the last match.

=back

=head1 AUTHORS

Regexp is a combination of work by
Nick Ing-Simmons E<lt>F<nick@ni-s.u-net.com>E<gt> and
Ilya Zakharevich E<lt>F<ilya@math.ohio-state.edu>E<gt> brought together 
and improved by Graham Barr E<lt>F<bodg@tiuk.ti.com>E<gt>

=cut
