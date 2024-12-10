#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;

print $cgi->header("text/html; charset=UTF-8");
print "<html><body><h2>Hola desde CGI Bin</h2></body></html>";
