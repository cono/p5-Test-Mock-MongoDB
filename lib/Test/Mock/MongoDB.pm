package Test::Mock::MongoDB;

use strict;
use warnings;

our $VERSION = '0.01';

require Test::Mock::Signature;
our @ISA = qw(Test::Mock::Signature);

our $CLASS = qw( MongoDB );

use Test::Mock::MongoDB::MongoClient;
use Test::Mock::MongoDB::Database;
use Test::Mock::MongoDB::Collection;
use Test::Mock::MongoDB::Cursor;

sub init {
    my $mock = shift;
    my $skip = $mock->{'skip_init'} || 'none';
    $skip = ref($skip) ? $skip : [ $skip ];

    my %members = (
        client     => {
            class  => 'MongoClient',
            params => {}
        },
        database   => {
            class  => 'Database',
            params => {}
        },
        collection => {
            class  => 'Collection',
            params => {}
        },
        cursor     => {
            class  => 'Cursor',
            params => {}
        }
    );

    for my $s (@$skip) {
        if ($s eq 'all') {
            for my $key ( keys %members ) {
                $members{$key}->{'params'}->{'skip_init'} = 1;
            }
            next;
        }
        next unless exists $members{$s};

        $members{$s}->{'params'}->{'skip_init'} = 1;
    }

    for my $key ( keys %members ) {
        my $class  = "Test::Mock::MongoDB::$members{$key}->{'class'}";
        my $params = $members{$key}->{'params'};

        $mock->{"_$key"} = $class->new(%$params);
    }
}

sub get_client {
    $_[0]->{'_client'}
}

sub get_database {
    $_[0]->{'_database'}
}

sub get_collection {
    $_[0]->{'_collection'}
}

sub get_cursor {
    $_[0]->{'_cursor'}
}

42;
