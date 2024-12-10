#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml; charset=utf-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $user = $cgi->param('user') || '';
my $password = $cgi->param('password') || '';

print "<user>\n";
if ($user ne '' && $password ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });
    
    my $sth = $dbh->prepare("SELECT userName, firstName, lastName FROM Users WHERE userName=? AND password=?");
    $sth->execute($user, $password);
    if (my $row = $sth->fetchrow_hashref) {
        print "  <owner>$row->{userName}</owner>\n";
        print "  <firstName>$row->{firstName}</firstName>\n";
        print "  <lastName>$row->{lastName}</lastName>\n";
    }
    $sth->finish;
    $dbh->disconnect;
}
print "</user>\n";
