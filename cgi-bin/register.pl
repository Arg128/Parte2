#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml; charset=utf-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $userName = $cgi->param('userName') || '';
my $password = $cgi->param('password') || '';
my $firstName = $cgi->param('firstName') || '';
my $lastName = $cgi->param('lastName') || '';

print "<user>\n";
if ($userName ne '' && $password ne '' && $firstName ne '' && $lastName ne '') {
    my $dbhost = $ENV{'DB_HOST'} || 'db';
    my $dbname = $ENV{'DB_NAME'} || 'miwikipedia';
    my $dbuser = $ENV{'DB_USER'} || 'wikiuser';
    my $dbpass = $ENV{'DB_PASS'} || 'wikipass';
    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";
    my $dbh = DBI->connect($dsn, $dbuser, $dbpass, { RaiseError => 0, PrintError => 0 });
    
    my $sth = $dbh->prepare("INSERT INTO Users(userName,password,firstName,lastName) VALUES(?,?,?,?)");
    my $res = $sth->execute($userName,$password,$firstName,$lastName);
    if ($res) {
        print "  <owner>$userName</owner>\n";
        print "  <firstName>$firstName</firstName>\n";
        print "  <lastName>$lastName</lastName>\n";
    }
    $sth->finish;
    $dbh->disconnect;
}
print "</user>\n";
