#!/usr/bin/perl

use strict;
use warnings;

my $usernameExists = 0;		#boolean to determine wether or not to display error page

#-----------------------------------------
#parsing username out of CGI's POST method
#-----------------------------------------
my ($buffer, $name, $username, $password, $formName, $value, %FORM);
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
my @pairs = split(/&/, $buffer);		#splits the input string into different strings seperated by '&''

foreach my $pair (@pairs)
    {
		($formName, $value) = split(/=/, $pair);		#stores the variable name in formName and the content in value
		$value =~ tr/+/ /;							#replaces + character with a space
		$value =~ s/%(..)/pack("C", hex($1))/eg;	#substitutes hex pair back to original ASCII character
		$FORM{$formName} = $value;
    }
$name = $FORM{Name};
$username  = $FORM{Username};
$password = $FORM{Password};

#---------------------------------------------------------
#parsing members.csv to see if the username already exists
# members.csv example line: 'name username password'
#---------------------------------------------------------
open (my $fh, "<", "members.csv"); # open file '<' = read only
my ($scannedName, $scannedUsername, $scannedPassword);
#reading line by line from the file
while(my $line = <$fh>)
{
	($scannedName, $scannedUsername, $scannedPassword) = split(/ /, $line); #splits each line into words seperated by a space
	if($scannedUsername eq $username)		#string comparison
	{
		$usernameExists = 1;
		last;					#breaks out of while loop if username is matched
	}
}
close $fh;

#check for spaces in user, username and password
my $hasembededspace = (($name =~ /\S*\s+\S*/) or ($username =~ /\S*\s+\S*/) or ($password =~ /\S*\s+\S*/));
if ($hasembededspace)
{
	print "Content-type:text/html \r\n\r\n";
	print"<html>\n";
	print "<head>\n";
	print "<img src=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/logo.png\" width=\"50\" height=\"50\" alt=\"House Logo\">";
	print "<title> Invalid Name, Username or Password</title>";
	print "<head> \n";
	print "<body style =\"background-color:black\">\n";
	print "<h2><font color=\"#FFFFFF\"> Invalid Name, Username or Password </font></h2>\n";
	print "<p><a href=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/welcome.html\"> Go back to home page </a></p>\n";
	print "<p><small><font color=\"#808080\"> &copy Coco&SkushLtd</font></small></p>";
	print "</body>\n";
	print "</html>\n";
}


#---------------------
#error page generation
#---------------------
elsif ( $usernameExists )
{
	print "Content-type:text/html\r\n\r\n";
	print "<html>\n";
	print "<head>\n";
	print "<img src=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/logo.png\" width=\"50\" height=\"50\" alt=\"House Logo\">";
	print "<title>Username already exists</title>\n";
	print "</head>\n";
	print "<body style =\"background-color:black\">\n";
	print "<h2><font color=\"#FFFFFF\">Username already exists !</font></h2>\n";
	print "<p><a href=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/welcome.html\"> Go back to home page </a></p>\n";
	print "<p><small><font color=\"#808080\"> &copy Coco&SkushLtd</font></small></p>";
	print "</body>\n";
	print "</html>\n";
}
#-----------------------------------------------
#writing to members.csv + sucess page generation
#-----------------------------------------------
else
{
	open (my $ffh, ">>", "members.csv");
	print $ffh "$name $username $password\n";
	close $ffh;

	#generates sucess page
	print "Content-type:text/html\r\n\r\n";
	print "<html>\n";
	print "<head>\n";
	print "<img src=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/logo.png\" width=\"50\" height=\"50\" alt=\"House Logo\">";
	print "<title>Account created!</title>\n";
	print "</head>\n";
	print "<body style =\"background-color:black\">\n";
	print "<h2><font color=\"#FFFFFF\">Successful Account Creation! !</font></h2>\n";
	print "<p><a href=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/welcome.html\"> Login on the home page</a></p>\n";
	print "<p><small><font color=\"#808080\"> &copy Coco&SkushLtd</font></small></p>";
	print "</body>\n";
	print "</html>\n";
}

