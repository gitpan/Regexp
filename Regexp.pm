package Regexp;

use vars qw(@EXPORT_OK @ISA $VERSION);

require DynaLoader;
require Exporter;

@ISA = qw(Exporter DynaLoader);

@EXPORT_OK = qw(FOLD EVAL MULTILINE SINGLELINE KEEP GLOBAL EXTENDED);

$VERSION = "0.003";

bootstrap Regexp $VERSION;

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    ($pack,$file,$line) = caller;
	    die "Your vendor has not defined Regexp macro $constname, used at $file line $line.\n";
	}
    }
    eval "sub $AUTOLOAD () { $val }";
    goto &$AUTOLOAD;
}

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

    my @info  = $re->parentheses
    my $count = $re->parentheses


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

=item MULTILINE

Treat strings as multiple lines, See C</m> in L<perlre>

=item SINGLELINE

Treat strings as single lines, See C</s> in L<perlre>

=item EXTENDED

Use extended patter formats to increase legibility, See C</x> in L<perlre>

=back

=item current ()

Returns an object which represents the current (last) pattern.

=back

=head1 METHODS

=over 4

=item match ( STRING [, OFFSET [, FLAGS]] )

C<match> is like the C<=~> operator in perl. C<STRING> is the string
which the regexp is to be applied. C<OFFEST> and C<FLAGS> are both optional.

C<OFFSET>, if given, directs the regexp code to start trying to match
the regexp at the given offset from the start of C<STRING>

C<FLAGS> is a numeric value which can be constructed by or-ing
together constants which Regexp conditionally exports. The constants are :

=over 4

=item GLOBAL

Match as many times as possible, starting each time where the previous
match ended. See C</g> option in L<perlre>

=back

=item nparens

Returns the number of parentheses in the expression

=item lastparen

Returns the number of the last parentheses that matched.

=item minlength

Returns the minimum length that a string has to be before it
will match the regular expression

=item pattern

Returns the pattern text

=item parentheses

=item prematch

Returns the text preceeding the text of the last match

=item lastmatch

Returns the text of the last match

=item postmatch

Returns the text following the text of the last match

=item length

Returns the length of the text in the last match

=item endpos ()

Returns the offset into the original string to the start of the text
following the last match.

=back

=head1 AUTHORS

Regexp is a combination of two previous modules by
Nick Ing-Simmons E<lt>F<nick@ni-s.u-net.com>E<gt> and
Ilya Zakharevich E<lt>F<ilya@math.ohio-state.edu>E<gt> combined together by
Graham Barr E<lt>F<bodg@tiuk.ti.com>E<gt>

=cut
