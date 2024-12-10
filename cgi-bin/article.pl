#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml; charset=utf-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $owner = $cgi->param('owner') || '';
my $title = $cgi->param('title') || '';

print "<article>\n";
if ($owner ne '' && $title ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });

    my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
    $sth->execute($owner, $title);
    if (my $row = $sth->fetchrow_hashref) {
        print "  <owner>$owner</owner>\n";
        print "  <title>$title</title>\n";
        print "  <text>$row->{text}</text>\n";
    }
    $sth->finish;
    $dbh->disconnect;
}
print "</article>\n";
