package File::FTS;
use strict;
use Symbol;
use File::Spec;
use vars qw($VERSION);

$VERSION = '0.01';

sub new {
	my ($class, $base) = @_;
	bless [{'dir' => $base}], $class;
}

sub Dive {
	my $self = shift;
	my $this = $self->[-1];
	return undef unless $this;
	my $fd;
	unless ($fd = $this->{'fd'}) {
		$fd = $this->{'fd'} = gensym;
		opendir($fd, $this->{'dir'});
	}
	my $item = readdir($fd);
	if ($item eq "." || $item eq "..") {
		return $self->Dive;
	}
	unless (defined($item)) {
		closedir($fd);
		pop @$self;
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
	return $self->Dive;
}

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

FTS - Perl extension for File Traversing System

=head1 SYNOPSIS

  use FTS;
  $fts = new FST("/usr/local");
  while ($file = $fts->Dive) {
  	print "$file\n";
  }

=head1 DESCRIPTION

This is similar to File::Find, but works non recursively.
Symbolic links to directories are skipped.

Inspired by the BSD fts library.

=head1 AUTHOR

Ariel Brosh, B<schop@cpan.org>

=head1 SEE ALSO

perl(1), L<File::Find>, fts(3).

=cut
