######################################################################
package Net::Amazon::Response::Exchange;
######################################################################
use warnings;
use strict;
use base qw(Net::Amazon::Response);

use Net::Amazon::Property;
use Net::Amazon::Result::Seller::Listing;
use Log::Log4perl qw(:easy);

__PACKAGE__->make_array_accessor($_) for qw(listings);

##################################################
sub new {
##################################################
   my($class, %options) = @_;

   my $self = $class->SUPER::new(%options);

   bless $self, $class;   # reconsecrate
}

##################################################
sub result {
##################################################
    my($self) = @_;

    if($self->is_success()) {
        return Net::Amazon::Result::Seller::Listing->new(
            xmlref => $self->{xmlref}->{ListingProductDetails}->[0],
        );
    }

    return undef;
}

##################################################
sub as_string {
##################################################
   my($self) = @_;

   return "TODO: as_string not defined yet in ", __PACKAGE__;
}

##################################################
sub xmlref_add {
##################################################
    my($self, $xmlref) = @_;

    my $nof_items_added = 0;

    unless(ref($self->{xmlref}) eq "HASH" &&
        ref($self->{xmlref}->{ListingProductDetails}) eq "ARRAY") {
        $self->{xmlref}->{Details} = [];
    }

    if(ref($xmlref->{ListingProductDetails}) eq "ARRAY") {
            # Is it an array of items?
        push @{$self->{xmlref}->{ListingProductDetails}},
             @{$xmlref->{ListingProductDetails}};
        $nof_items_added = scalar @{$xmlref->{ListingProductDetails}};
    } else {
            # It is a single item
        push @{$self->{xmlref}->{ListingProductDetails}},
             $xmlref->{ListingProductDetails};
        $nof_items_added = 1;
    }

    return $nof_items_added;
}

##################################################
sub properties {
##################################################
    my($self) = @_;

    die "properties() not defined in ", __PACKAGE__, ". Use result() instead";
}

1;
