######################################################################
package Net::Amazon::Property;
######################################################################
use base qw(Net::Amazon);

use Net::Amazon::Property::Book;
use Net::Amazon::Property::Music;
use Data::Dumper;
use Log::Log4perl qw(:easy);

use warnings; 
use strict;

##################################################
sub new {
##################################################
    my($class, %options) = @_;

    if(!$options{xmlref}) {
        die "Mandatory param xmlref missing";
    }

    my $self = { 
        %options, 
               };

    bless $self, $class;

        # Set default attributes
    for my $attr (qw(OurPrice ImageUrlLarge ImageUrlMedium ImageUrlSmall
                     ReleaseDate Catalog Asin url Manufacturer UsedPrice
                     ListPrice ProductName)) {
        $class->SUPER::make_accessor($attr);
        $self->$attr($options{xmlref}->{$attr});
    }

    return $self;
}

##################################################
sub as_string {
##################################################
    my($self) = @_;

    $Data::Dumper::Indent = 1; 
    return Data::Dumper::Dumper($self->{xmlref});
}

##################################################
sub factory {
##################################################
    my(%options) = @_;

    my $xmlref = $options{xmlref};
    die "Called factory without xmlref" unless $xmlref;

    DEBUG("xmlref=", Data::Dumper::Dumper($xmlref));

    my $catalog = $xmlref->{Catalog};
    my $obj;

    if(0) {
    } elsif($catalog eq "Book") {
        DEBUG("Creating new Book Property");
        $obj = Net::Amazon::Property::Book->new(xmlref => $xmlref);
    } elsif($catalog eq "Music") {
        DEBUG("Creating new Music Property");
        $obj = Net::Amazon::Property::Music->new(xmlref => $xmlref);
    } else {
        DEBUG("Creating new Default Property ($catalog)");
        $obj = Net::Amazon::Property->new(xmlref => $xmlref);
    }

    return $obj;
}

1;

__END__

=head1 NAME

Net::Amazon::Property - Baseclass for products on amazon.com

=head1 SYNOPSIS

  use Net::Amazon;

  # ...

  if($resp->is_success()) {
      for my $prop ($resp->properties) {
          print $_->ProductName(), " ",
                $_->Manufacturer(), " ",
                $_->OurPrice(), "\n";

=head1 DESCRIPTION

C<Net::Amazon::Property> is the baseclass for results returned
from Amazon web service queries. The term 'properties' is used as 
a generic description for an item on amazon.com.

Typically, the C<properties()> method of a C<Net::Amazon::Response::*> object
will return one or more objects of class C<Net::Amazon::Property> or
one of its subclasses, e.g. C<Net::Amazon::Property::Book> or
C<Net::Amazon::Property::CD>.

While C<Net::Amazon::Property> objects expose accessors for all 
fields returned in the XML response (like C<OurPrice()>, C<ListPrice()>,
C<Manufacturer()>, C<Asin()>, C<Catalog()>, C<ProductName()>, subclasses
might define their own accessors to more class-specific fields
(like the iC<Net::Amazon::Property::Book>'s C<authors()> method returning
a list of authors, while C<Net::Amazon::Property>'s C<Authors()> method
will return a reference to a sub-hash containing a C<Author> field, just like
the response's XML contained it).

=head2 METHODS

Methods vary, depending on the item returned from a query. Here's the most
common ones. They're all accessors, meaning they can be used like C<Method()>
to retrieve the value or like C<Method($value)> to set the value of the
field.

=over 4

=item Asin()

The item's ASIN number.

=item ProductName()

Book title, CD album name or item name

=item Catalog()

Shows the catalog the item was found in: C<Book>, C<Music>, C<Classical>,
C<Electronics> etc.

=item Authors()

Returns a sub-hash with a C<Author> key, which points to either a single
$scalar or to a reference of an array containing author names as scalars.

=item ReleaseDate()

Item's release date, format is "NN Monthname, Year".

=item Manufacturer()

Music label, publishing company or manufacturer

=item ImageUrlSmall()

URL to a small (thumbnail) image of the item

=item ImageUrlMedium()

URL to a medium-size image of the item

=item ImageUrlLarge()

URL to a large image of the item

=item ListPrice()

List price of the item

=item OurPrice()

Amazon price of the item

=item UsedPrice()

Used price of the item

=back

Please check the subclasses of C<Net::Amazon::Property> for specialized 
methods.

=head1 SEE ALSO

=head1 AUTHOR

Mike Schilli, E<lt>m@perlmeister.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Mike Schilli E<lt>m@perlmeister.comE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut