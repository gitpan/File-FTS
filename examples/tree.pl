#!/usr/bin/perl 

use strict;
use warnings;

use File::FTS;

my $dir = shift;

my $fts = File::FTS->new($dir);

while (my $file = $fts->Dive())
{
    print "$file\n";
}

1;
