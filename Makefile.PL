use ExtUtils::MakeMaker;
                           
WriteMakefile(
    'VERSION'  => '0.002',
    'NAME'     => 'Regexp',
    'clean' => {FILES => "*% *.bak"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
);


