#!perl 

my $t = 0;

sub passed {
    
    print "# line ",(caller)[2],"\nnot "
	unless $_[0];
    print "ok ",++$t,"\n";

}

$| = 1;
print "1..15\n";
require Regexp;
print "ok ",++$t,"\n";
my $re = new Regexp q/\b([fo]+)\b/;

passed($re);

passed($re->pattern eq '\b([fo]+)\b');

passed($re->match("pre foo post"));

passed(($re->parentheses)[0] eq 'foo');

passed($re->prematch eq 'pre ');

passed($re->postmatch eq ' post');

passed($re->match("bar") ? 0 : 1);

foreach ('foo','bar','foobar','foo bar')
 {
  my $m =  match $re;
  passed( /\bfoo\b/ ? $m : not($m));
 }

$s = "foo foo foo";

if ($s =~ /o+/)
 {
  my $cur = current Regexp;
  passed($cur->pattern eq 'o+');
 }

passed($re->match($s,length($s)-3));

passed(! ($re->match($s,length($s)-2)));



