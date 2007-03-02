use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    'module_name' => "File::FTS",
    'requires' =>
    {
    },
    'license' => "perl",
);
$build->create_build_script;
