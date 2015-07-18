#!perl

use strict;
use warnings;

# test to see if we got a working version of PDF::API2

use PDF::API2;
use CAM::PDF;

use File::Temp;
use Test::More tests => 1;

my $pdf = PDF::API2->new;
my $font = $pdf->corefont('Helvetica-Bold');
my $page = $pdf->page;
my $text = $page->text;
$text->font($font, 20);
$text->text('Hello world');

$pdf->preferences(
                  -firstpage => [ $page, -fit => 0],
                 );

my $string = $pdf->stringify;

unlike $string, qr/PDF::API2::Page=HASH/;

my $cam = CAM::PDF->new($string);

ok($cam);
