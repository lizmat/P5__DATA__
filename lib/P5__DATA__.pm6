use v6.c;

my $DATA;

module P5__DATA__:ver<0.0.1>:auth<cpan:ELIZABETH> {

    my $handle;
    my $lock = Lock.new;
    my sub term:<DATA>(--> IO::Handle:D) {
        $lock.protect: {
            $handle //= callframe(3).file.IO.open(:r, :!chomp)
        }

        # Perl 5's logic appears to be that a line that contains 
        loop {
            with $handle.get -> $line {
                my $pos = 0;
                $pos = $_ + 1 with $line.index('#');
                return $handle with $line.index('__DATA__', $pos);
                return $handle with $line.index('__END__', $pos);
            }
            else {
                return $handle;
            }
        }
    }

    $DATA := &term:<DATA>;
}

sub EXPORT(|) {
    role Data {
        method obs($, $, $?) { say "we're in obs" }
        token term:sym<p5end>  { <!> }
        token term:sym<p5data> { <!> }
        token pod_block:sym<finish> {
            ^^ \h*
            [
                | '=begin' \h+ 'finish' <pod_newline>
                | '=for'   \h+ 'finish' <pod_newline>
                | '=finish'  <pod_newline>
                | '__DATA__' <pod_newline>
                | '__END__'  <pod_newline>
            ]
            $<finish> = .*
        }
    }

    $*LANG.define_slang('MAIN', $*LANG.slang_grammar('MAIN').^mixin(Data));

    { '&term:<DATA>' => $DATA }
}

=begin pod

=head1 NAME

P5__DATA__ - Implement Perl 5's __DATA__ and related functionality

=head1 SYNOPSIS

  use P5__DATA__; # exports DATA and a slang

=head1 DESCRIPTION

This module tries to mimic the behaviour of C<__DATA__> and C<__END__> and
the associated C<DATA> file handle of Perl 5 as closely as possible.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/P5__DATA__ . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Elizabeth Mattijsen

Re-imagined from Perl 5 as part of the CPAN Butterfly Plan.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
