use ExtUtils::MakeMaker;
                           
WriteMakefile(
    'VERSION_FROM' => 'Regexp.pm',
    'NAME'	   => 'Regexp',
    'clean'	   => {FILES => "*% *.b[ac]k"},
    'dist'	   => {COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
);


