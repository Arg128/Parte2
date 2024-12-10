#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml; charset=utf-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $title = $cgi->param('title') || '';
my $text = $cgi->param('text') || '';
my $owner = $cgi->param('owner') || '';

print "<article>\n";
if ($title ne '' && $text ne '' && $owner ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });
    
    my $sth = $dbh->prepare("UPDATE Articles SET text=? WHERE owner=? AND title=?");
    my $res = $sth->execute($text,$owner,$title);
    if ($res) {
        print "  <title>$title</title>\n";
        print "  <text>$text</text>\n";
    }
    $sth->finish;
    $dbh->disconnect;
}
print "</article>\n";
