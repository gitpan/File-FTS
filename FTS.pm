package File::FTS;

use strict;

use File::Spec;

use vars qw($VERSION);

$VERSION = '0.02';

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

=head1 SYNOPSIS

  use FTS;
  $fts = new FTS("/usr/local");
  while ($file = $fts->Dive) {
      print "$file\n";
  }

=head1 DESCRIPTION

This is similar to File::Find, but works non recursively.
Symbolic links to directories are skipped.

Inspired by the BSD fts library.

=head1 AUTHOR

Original Author: Ariel Brosh, L<http://search.cpan.org/author/SCHOP/> (Ariel
has unexpectdly passed away and this module has been adopted by someone else)

Current Maintainer: Shlomi Fish, B<shlomif@cpan.org>

=head1 SEE ALSO

perl(1), L<File::Find>, fts(3).

=cut
