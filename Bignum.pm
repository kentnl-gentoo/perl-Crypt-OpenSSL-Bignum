package Crypt::OpenSSL::Bignum;

use 5.005;
use strict;
use Carp;

use vars qw( $VERSION @ISA );

require DynaLoader;

@ISA = qw(DynaLoader);

$VERSION = '0.01';

bootstrap Crypt::OpenSSL::Bignum $VERSION;

sub DESTROY
{
    shift->_free_BN();
}

sub bless_pointer
{
    my( $proto, $p_pointer ) = @_;
    return bless( \$p_pointer, $proto );
}

sub equals
{
    my( $self, $a ) = @_;
    return ! $self->cmp( $a );
}


1;
__END__

=head1 NAME

Crypt::OpenSSL::Bignum - OpenSSL's multiprecision integer arithmetic

=head1 SYNOPSIS

  use Crypt::OpenSSL::Bignum;

  my $bn = Crypt::OpenSSL::Bignum->new_from_decimal( "1000" );
  # or
  my $bn = Crypt::OpenSSL::Bignum->new_from_word( 1000 );
  # or
  my $bn = Crypt::OpenSSL::Bignum->new_from_hex("0x3e8");
  # or
  my $bn = Crypt::OpenSSL::Bignum->new_from_bin(pack( "C*", 3, 232 ))

  use Crypt::OpenSSL::Bignum::CTX;

  sub print_factorial
  {
    my( $n ) = @_;
    my $fac = Crypt::OpenSSL::Bignum->one();
    my $ctx = Crypt::OpenSSL::Bignum::CTX->new();
    foreach my $i (1 .. $n)
    {
      $fac->mul( Crypt::OpenSSL::Bignum->new_from_word( $i ), $ctx, $fac );
    }
    print "$n factorial is ", $fac->to_decimal(), "\n";
  }

=head1 DESCRIPTION

Crypt::OpenSSL::BIGNUM provides access to OpenSSL multiprecision
integer arithmetic libraries.  Presently, many though not all of the
arithmetic operations that OpenSSL provides are exposed to perl.  In
addition, this module can be used to provide access to bignum values
produced by other OpenSSL modules, such as key parameters from
Crypt::OpenSSL::RSA.

I<NOTE>: Many of the methods in this package can croak, so use eval, or
Error.pm's try/catch mechanism to capture errors.

=head1 Class Methods

=over

=item new_from_word

Create a new Bignum object whose value will be the word given.  Note
that Bignums created using this method are necessarily between 0 and
2^32 - 1.

=item new_from_decimal

Create a new Bignum object whose value is specified by the given decimal
representation.

=item new_from_hex

Create a new Bignum object whose value is specified by the given
hexidecimal representation.

=item new_from_bin

Create a new Bignum object whose value is specified by the given
packed binary data.  Note that objects created using this method are
necessarily nonnegative.

=item zero

Returns a new Bignum object representing 0

=item one

Returns a new Bignum object representing 1

=item bless_pointer

Given a pointer to a OpenSSL BIGNUM object in memory, construct and
return Crypt::OpenSSL::Bignum object around this.  Note that the
underlying BIGNUM object will be destroyed (via BN_clear_free(3ssl))
when the returned Bignum object goes out of scope, so the pointer
passed to this method should only be referenced via the returned perl
object after calling bless_pointer.

This method is intended only for use by XSUB writers writing code that
interfaces with OpenSSL library methods, and who wish to be able to
return a BIGNUM structure to perl as a Crypt::OpenSSL::Bignum object.

=back

=head1 Instance Methods

=over

=item pointer_copy

This method is intended only for use by XSUB writers wanting to have
access to the underlying BIGNUM structure referenced by a
Crypt::OpenSSL::Bignum perl object so that they can pass them to other
routines in the OpenSSL library.  It returns a perl scalar whose IV
can be cast to a BIGNUM* value.  This can then be passed to an XSUB
which can work with the BIGNUM directly.  Note that the BIGNUM object
pointed to will be a copy of the BIGNUM object wrapped by the
instance; it is thus the responsiblity of the client to free space
allocated by this BIGNUM object if and when it is done with it. See
also bless_pointer.

=back

=head1 AUTHOR

Ian Robertson, iroberts@cpan.org

=head1 SEE ALSO

L<perl>, L<bn(3ssl)>

=cut
