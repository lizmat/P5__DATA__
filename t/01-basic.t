use v6.c;
use Test;
use P5__DATA__;

plan 2;

ok defined(::('&term:<DATA>')),            'is DATA imported?';
ok !defined(P5__DATA__::{'&term:<DATA>'}), 'is DATA externally NOT accessible?';

#__DATA__

# vim: ft=perl6 expandtab sw=4
