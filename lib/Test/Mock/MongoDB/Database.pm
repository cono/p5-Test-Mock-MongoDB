package Test::Mock::MongoDB::Database;

use strict;
use warnings;

require Test::Mock::Signature;
our @ISA = qw(Test::Mock::Signature);

our $CLASS = qw( MongoDB::Database );

sub init {
    my $mock = shift;
    return if exists $mock->{'skip_init'};

    $mock->method('get_collection')->callback(
        sub {
            return bless({}, 'MongoDB::Collection')
        }
    );
}

42;
