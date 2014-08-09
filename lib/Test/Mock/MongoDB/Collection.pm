package Test::Mock::MongoDB::Collection;

use strict;
use warnings;

require Test::Mock::Signature;
our @ISA = qw(Test::Mock::Signature);

our $CLASS = qw( MongoDB::Collection );

sub init {
    my $mock = shift;
    return if exists $mock->{'skip_init'};

    $mock->method('get_collection')->callback(
        sub {
            return bless({}, 'MongoDB::Collection')
        }
    );

    $mock->method('find')->callback(
        sub {
            return bless({}, 'MongoDB::Cursor')
        }
    );
}

42;
