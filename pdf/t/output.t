#! perl
#
# Test for HTML files with UTF-8 content

use strict;
use warnings;

use utf8;

use Test::More tests => 1;
use File::Spec;

my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";


use Template::Flute;
use Template::Flute::PDF;

my %values = (camel => 'ラクダ');

my $spec = q{<specification>
<value name="camel" />
</specification>
};

my $html = <<'HTML';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
</head>
<body><a href="" class="camel">Camel</a><span>&nbsp;</span>
<div>
bla bla bla ààà ć
</div>
</body>
</html>
HTML



my $outputdir = File::Spec->catdir("t", "output");
unless (-d $outputdir) {
    mkdir $outputdir or die "Can't create $outputdir $!";
}

my $target = File::Spec->catfile("t", "output", "output.pdf");

if (-f $target) {
    unlink $target or die "Can't remove $target $!";
}

my $flute = Template::Flute->new(template => $html,
                                 specification => $spec,
                                 values => \%values);
my $out = $flute->process;

diag $out;

my $flute_pdf = Template::Flute::PDF->new(template => $flute->template,
                                          file => $target);

$flute_pdf->process;

ok(-f $target);
