use strict;

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

sub MY::postamble {
        package MY;
        shift->SUPER::postamble . <<'MAKE';
dist : README

README : lib/File/FTS.pm
	@$(PERL) -MPod::Text -e "pod2text('$<');" > $@

MAKE
}

WriteMakefile(
    'NAME'	=> 'File::FTS',
    'VERSION_FROM' => 'lib/File/FTS.pm', # finds $VERSION
    'PL_FILES' => {},
);

