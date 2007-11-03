# -*- perl -*-
# !!! DO NOT EDIT !!!
# This file was automatically generated.
package Net::Amazon::Validate::Type::CartModify;

use 5.006;
use strict;
use warnings;

use constant RESPONSEGROUP_VALID_VALUES => {
    'Cart' => 'default',
    'CartNewReleases' => 'valid',
    'CartSimilarities' => 'valid',
    'CartTopSellers' => 'valid',
    'Request' => 'default',
};



sub new {
    my ($class , %options) = @_;
    my $self = {
        %options,
    };
    bless $self, $class;
}

sub assert {
    my ($self, $value, $name, $href) = @_;
    die "Unknown type in Net::Amazon::Request constructor: $value" unless defined $href->{$value};
}

sub validate {
    my ($self, $value, $name, $href) = @_;
    if ( ref ($value) eq 'ARRAY' ) {
        $self->assert($_, $name, $href) for (@$value);
    } else {
        $self->assert($value, $name, $href);
    }
}

sub ResponseGroup {
    my ($self, $value) = @_;
    $self->validate($value, "ResponseGroup", (RESPONSEGROUP_VALID_VALUES));
}



1;