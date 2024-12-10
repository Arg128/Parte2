#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml; charset=utf-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $owner = $cgi->param('owner') || '';

print "<articles>\n";
if ($owner ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });

    my $sth = $dbh->prepare("SELECT owner, title FROM Articles WHERE owner=?");
    $sth->execute($owner);
    while (my $row = $sth->fetchrow_hashref) {
        print "  <article>\n";
        print "    <owner>$row->{owner}</owner>\n";
        print "    <title>$row->{title}</title>\n";
        print "  </article>\n";
    }
    $sth->finish;
    $dbh->disconnect;
}
print "</articles>\n";
