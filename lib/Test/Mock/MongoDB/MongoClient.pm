package Test::Mock::MongoDB::MongoClient;

use strict;
use warnings;

require Test::Mock::Signature;
our @ISA = qw(Test::Mock::Signature);

our $CLASS = qw( MongoDB::MongoClient );

sub init {
    my $mock = shift;
    return if exists $mock->{'skip_init'};

    $mock->method('new')->callback(
        sub {
            return bless({}, 'MongoDB::MongoClient')
        }
    );

    $mock->method('get_database')->callback(
        sub {
            return bless({}, 'MongoDB::Database')
        }
    );
}

42;
