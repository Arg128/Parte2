#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Text::Markdown 'markdown'; 

my $cgi = CGI->new;
print $cgi->header('text/html; charset=utf-8'); 

my $owner = $cgi->param('owner') || '';
my $title = $cgi->param('title') || '';

if ($owner ne '' && $title ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });

    my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner=? AND title=?");
    $sth->execute($owner,$title);
    if (my $row = $sth->fetchrow_hashref) {
        my $text_md = $row->{text};
        my $html = markdown($text_md);
        print $html;
    }
    $sth->finish;
    $dbh->disconnect;
}
