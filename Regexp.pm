package Regexp;
require DynaLoader;
require Exporter;
@ISA = qw(Exporter DynaLoader);

bootstrap Regexp;

@EXPORT_OK = qw(
	     FOLD EVAL MULTILINE SINGLELINE KEEP GLOBAL EXTENDED
);

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
	    die "Your vendor has not defined Regexp macro $constname, used at $file line $line.
";
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

=item current ()

Returns an object which represents the current (last) pattern.

=back

=head1 METHODS

=over 4

=item match ( STRING [, OFFSET [, FLAGS]] )

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
Nick Ing-Simmons E<lt>F<nick@ni-s.u-net.com>E<gt>
and
Ilya Zakharevich E<lt>F<ilya@math.ohio-state.edu>E<gt>
conbined together by
Graham Barr E<lt>F<bodg@tiuk.ti.com>E<gt>
