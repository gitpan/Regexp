use ExtUtils::MakeMaker;
                           
WriteMakefile(
    'NAME'     => 'Regexp',
    'clean' => {FILES => "*% *.bak"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
    'VERSION'  => '0.001'
);


