package Regexp;
require DynaLoader;
@ISA = qw(DynaLoader);

bootstrap Regexp;

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

=head1 AUTHOR

Nick Ing-Simmons E<lt>nick@ni-s.u-net.comE<gt>
