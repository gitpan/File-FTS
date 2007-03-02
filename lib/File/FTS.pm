package File::FTS;

use strict;

use File::Spec;

use vars qw($VERSION);

$VERSION = '0.04';

sub new {
    my ($class, $base) = @_;
    bless [{'dir' => $base}], $class;
}

sub Dive {
    my $self = shift;
    my $this = $self->[-1];
    return undef unless $this;
    my $files;
    unless ($files = $this->{'files'}) {
        local(*DIR);
        opendir(DIR, $this->{'dir'});
        my @files_list = readdir(DIR);
        $files = $this->{'files'} = \@files_list;
        closedir(DIR);
    }
    my $item = shift(@$files);
    unless (defined($item)) {
        pop @$self;
        return $self->Dive;
    }
    if ($item eq "." || $item eq "..") {
        return $self->Dive;
    }    
    my $name = File::Spec->catfile($this->{'dir'}, $item);
    unless (-d $name) {
        return $name;
    }
    if (-l $name) {
        return $self->Dive;
    }
    push(@$self, {'dir' => $name});
    return $name;
    # return $self->Dive;
}

1;
__END__


=head1 NAME

FTS - Perl extension for File Traversing System

=head1 IMPORTANT NOTE!

This module is depcrecated and no longer actively maintained, except for some
maintenance. It is kept on CPAN for backwards compatibility. You should look 
at L<File::Find::Object> instead, which is more complete and more actively 
maintained.

=head1 SYNOPSIS

  use File::FTS;
  my $fts = new File::FTS("/usr/local");
  while (my $file = $fts->Dive) {
      print "$file\n";
  }

=head1 DESCRIPTION

This is similar to File::Find, but works non recursively.
Symbolic links to directories are skipped.

Inspired by the BSD fts library.

=head1 FUNCTIONS

=head2 my $fts = File::FTS->new($dir)

Constructs a new File::FTS object that operates on the directory $dir.

=head2 my $file = $fts->Dive()

Returns the next file.

=head1 AUTHOR

Original Author: Ariel Brosh, L<http://search.cpan.org/author/SCHOP/> (Ariel
has unexpectdly passed away and this module has been adopted by others)

Current Maintainer: Shlomi Fish, L<http://search.cpan.org/author/SHLOMIF/>

=head1 SEE ALSO

perl(1), L<File::Find>, fts(3), L<File::Find::Object>.

=head1 LICENSE

This module did not contain any license information when I inherited it
from its deceased author. According to my interpretation it is licensed
according to the terms of perl5 itself.

=cut
