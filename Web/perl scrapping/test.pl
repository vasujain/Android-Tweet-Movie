#!/usr/usc/bin/perl -w

#Fatal errors will now be echoed to the browser as well as to the log.
#CGI::Carp arranges to send a minimal HTTP header to the browser so that even errors that occur in the early compile phase will be seen. 
use CGI::Carp qw(fatalsToBrowser);
use File::Copy;

print "content-type:text/html \n\n";

#Creation of a new CGI object that contains the parameters passed to this script
#This code calls the new() method of the CGI class and stores a new CGI object into the variable named $query.
#The new() method does parsing the script parameters and environment variables and stores its results in the new object 'query'.
use CGI;
my $query = CGI->new();

#Initialization of local variables to store the User Registration data POST-ed by FORM
$f_name=$query->param('fname');
$m_name=$query->param('mname');
$l_name=$query->param('lname');
$address=$query->param('addr');
$city=$query->param('city');
$state=$query->param('state');
$zip=$query->param('zip');
$login=$query->param('login');
$pwd1=$query->param('pwd1');

#This perice of code opens the file and checks if $login entered in the form is already present in the form
	open(MYFILEVAL,"index.xml");
	foreach $line (<MYFILEVAL>) 
		{					
			if($line =~ /\<login\>$login\<\/login\>/)  
			{
			print "Username already exists in the database.\n";exit;
			}				
		}
	close(MYFILEVAL);

#A filename is created with default filename to store the values
$filename='index.xml';

#Generation of XML Code using the form parameters
	unless (-e $filename) 
	{
		my $xmlcode1 = '<?xml version="1.0" encoding="UTF-8"?>';
		my $xmlroot = '<userroot>';
		my $xmlcode2 = '<user>';
		my $xmlcode3 = '      <fname>' . $f_name . '</fname>';
		my $xmlcode4 = '      <mname>' . $m_name . '</mname>';
		my $xmlcode5 = '      <lname>' . $l_name . '</lname>';
		my $xmlcode6 = '      <address>' . $address . '</address>';
		my $xmlcode7 = '      <city>' . $city . '</city>';
		my $xmlcode8 = '      <state>' . $state . '</state>';
		my $xmlcode9 = '      <zip>' . $zip . '</zip>';
		my $xmlcode10 ='      <login>' . $login . '</login>';
		my $xmlcode11 ='      <pwd1>' . $pwd1 . '</pwd1>';
		my $xmlcode12 ='</user>';
		my $xmlrootend='</userroot>';
		open(MYFILE,">>index.xml");
		print MYFILE $xmlcode1; print MYFILE "\n";
		print MYFILE $xmlroot; print MYFILE "\n";
		print MYFILE $xmlcode2; print MYFILE "\n";
		print MYFILE $xmlcode10; print MYFILE "\n";
		print MYFILE $xmlcode11; print MYFILE "\n";		
		print MYFILE $xmlcode3; print MYFILE "\n";
		print MYFILE $xmlcode4; print MYFILE "\n";
		print MYFILE $xmlcode5; print MYFILE "\n";
		print MYFILE $xmlcode6; print MYFILE "\n";
		print MYFILE $xmlcode7; print MYFILE "\n";
		print MYFILE $xmlcode8; print MYFILE "\n";
		print MYFILE $xmlcode9; print MYFILE "\n";
		print MYFILE $xmlcode12; print MYFILE "\n";
		print MYFILE $xmlrootend; print MYFILE "\n";
		close(MYFILE);
		copy("index.xml", "../htdocs/alluserlist.xml");
		$rdurl="<a href='http://cs-server.usc.edu:17418/hw6page3.html'>Click here</a>";
		print "</br> Thankyou for your Entry.</br> Your Record has been saved.</br> Please go back to login form at $rdurl to view movies in your area!!</br>";
		exit;
	}

#From now on we will open a main.xml file and append index.xml into it till the 2nd last line
	open(MYFILEMAIN,">>main.xml");
	open(MYFILEINDEX,"index.xml");
	foreach $line (<MYFILEINDEX>) 
	{
		if($line =~ /<\/userroot/)
		{
			close(MYFILEINDEX);	
			close(MYFILEMAIN);	
		}
		print MYFILEMAIN $line;
	}
#initializing variables for entry into main.xml	
	open(MYFILEMAIN,">>main.xml");
	my $xmlcode2 = '<user>';
	my $xmlcode3 = '      <fname>' . $f_name . '</fname>';
	my $xmlcode4 = '      <mname>' . $m_name . '</mname>';
	my $xmlcode5 = '      <lname>' . $l_name . '</lname>';
	my $xmlcode6 = '      <address>' . $address . '</address>';
	my $xmlcode7 = '      <city>' . $city . '</city>';
	my $xmlcode8 = '      <state>' . $state . '</state>';
	my $xmlcode9 = '      <zip>' . $zip . '</zip>';
	my $xmlcode10 ='      <login>' . $login . '</login>';
	my $xmlcode11 ='      <pwd1>' . $pwd1 . '</pwd1>';
	my $xmlcode12 ='</user>';
	my $xmlrootend='</userroot>';
	print MYFILEMAIN $xmlroot; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode2; print MYFILEMAIN "\n";	
	print MYFILEMAIN $xmlcode10; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode11; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode3; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode4; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode5; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode6; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode7; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode8; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode9; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlcode12; print MYFILEMAIN "\n";
	print MYFILEMAIN $xmlrootend; print MYFILEMAIN "\n";
	close(MYFILEMAIN);

#Deletes index.xml file from the server
unlink "index.xml";				
#Renames the file main.xml to index.xml
rename("main.xml", "index.xml");
#Copy finalized index.xml to htdocs for final linking into the hw6homepage
copy("index.xml", "../htdocs/alluserlist.xml");

#Final output message if the data entry is saved
$rdurl="<a href='http://cs-server.usc.edu:17418/hw6page3.html'>Click here</a>";
print "</br> Thankyou for your Entry.</br> Your Record has been saved.</br> Please go back to login form at $rdurl to view movies in your area!!</br>";

#End of Script 