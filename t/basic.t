#!perl 
$| = 1;
my $t = 0;
print "1..14\n";
require Regexp;
print "ok ",++$t,"\n";
my $re = new Regexp q/\b([fo]+)\b/;
print "not " unless $re;
print "ok ",++$t,"\n";
print "not " unless $re->pattern eq '\b([fo]+)\b';
print "ok ",++$t,"\n";
print "not " unless $re->match("pre foo post");
print "ok ",++$t,"\n";
print "not " unless ($re->parentheses)[0] eq 'foo';
print "ok ",++$t,"\n";
print "not " unless $re->prematch eq 'pre ';
print "ok ",++$t,"\n";
print "not " unless $re->postmatch eq ' post';
print "ok ",++$t,"\n";
print "not " if $re->match("bar");
print "ok ",++$t,"\n";
foreach ('foo','bar','foobar','foo bar')
 {
  my $m = match $re;
  print "not " unless ($m == /\bfoo\b/);
  print "ok ",++$t,"\n";
 }

$s = "foo foo foo";

if (0) {                

if ($s =~ /o+/)
 {
  my $cur = current Regexp;
  print "not " unless $cur->pattern eq 'o+';
  print "ok ",++$t,"\n";
 }
}

print "not " unless($re->match($s,length($s)-3));
print "ok ",++$t,"\n";

print "not " if($re->match($s,length($s)-2));
print "ok ",++$t,"\n";



