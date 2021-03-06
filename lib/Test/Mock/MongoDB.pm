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

__END__

=head1 NAME

Test::Mock::MongoDB - mock module for MongoDB class.

=head1 SYNOPSIS

Mock all constructors by default:

    use Test::Mock::MongoDB qw( any );

    my $mock         = Test::Mock::MongoDB->new;
    my $m_client     = $mock->get_client;
    my $m_database   = $mock->get_database;
    my $m_collection = $mock->get_collection;
    my $m_cursor     = $mock->get_cursor;

    my $db = $client->get_database('foo');
    my $collection = $db->get_collection('bar');

    $m_collection->method(insert => { name => any })->callback(
        sub { 42 }
    );
    print $collection->insert({ name => 'cono'}); # 42

Or you can leave default MongoDB behaviour by skipping init:

    my $mock = Test::Mock::MongoDB->new(skip_init => 'all');

    $mock->get_collection->method(find_one => { name => 'ivan'})->callback(
        sub {
            return { name => 'cono'};
        }
    );

    my $doc = $collection->find_one({ name => 'ivan'}); # { name => 'cono' }

=head1 DESCRIPTION

Current module mocks MongoDB class. Can be run in two modes:

=over 8

=item overrides constructors (does not need real connection)

=item do not override anything by default

=back

These modes controlled by: C<skip_init> parameter.

=head1 METHODS

=head2 init()

This method invoked from constructor C<new()> in base class: L<Test::Mock::Signature>. Current method implement logic of C<skip_init> parameter passed into constructor C<new()>.

C<skip_init> parameter can be:

=over 8

=item client - skip init of L<Test::Mock::MongoDB::MongoClient>

=item database - skip init of L<Test::Mock::MongoDB::Database>

=item collection - skip init of L<Test::Mock::MongoDB::Collection>

=item cursor - skip init of L<Test::Mock::MongoDB::Cursor>

=item all - skips all init

=back

e.g.:

    $mock = Test::Mock::MongoDB->new( skip_init => 'client' );

or

    $mock = Test::Mock::MongoDB->new( skip_init => 'all' );

or

    $mock = Test::Mock::MongoDB->new( skip_init => [ qw| client database | ] );

=head2 get_client() : L<Test::Mock::MongoDB::MongoClient>

Returns object of class L<Test::Mock::MongoDB::MongoClient>.

=head2 get_database() : L<Test::Mock::MongoDB::Database>

Returns object of class L<Test::Mock::MongoDB::Database>.

=head2 get_collection() : L<Test::Mock::MongoDB::Collection>

Returns object of class L<Test::Mock::MongoDB::Collection>.

=head2 get_cursor() : L<Test::Mock::MongoDB::Cursor>

Returns object of class L<Test::Mock::MongoDB::Cursor>.

=head1 AUTHOR

cono E<lt>cono@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014 - cono

=head1 LICENSE

Artistic v2.0

=head1 SEE ALSO

L<Test::Mock::Signature>, L<Data::Pattern::Compare>

=cut
