#!/usr/usc/bin/perl -w
use CGI::Carp qw(fatalsToBrowser);
print "content-type:text/html \n\n";
use CGI;
my $query = CGI->new();

#MyURL: http://cs-server.usc.edu:17418/hw6page3.html

$userid=$query->param('userid');
$userpwd=$query->param('userpwd');
$filename='index.xml';

	if(-e $filename) 
	{
		$frmlogin=""; $frmpwd="";  $zippy=00000;
		
		# Regex use \ before any special character like { <, >, \ } 
		# Regex use (.+) to extract value sandwiched between texts into a variable $1.
				
		$flagy=0;
		open(MYFILEINDI,"index.xml");
		foreach $line (<MYFILEINDI>) 
			{					
				#Set flagy=1 to start reading from the line where you encountered $userid variable
				if($line =~ /\<login\>$userid\<\/login\>/)  
				{ 
				$flagy=1;
				}
				#Parse variables from the XML tag
				if($flagy==1)
				{
					if($line =~ /\<login\>(.+)\<\/login\>/)  
					{ 	$frmlogin=$1;}
					if($line =~ /\<pwd1\>(.+)\<\/pwd1\>/)  
					{	$frmpwd=$1;}	
					if($line =~ /\<fname\>(.+)\<\/fname\>/)  
					{	$frmfname=$1;}				
					if($line =~ /\<mname\>(.+)\<\/mname\>/)  
					{	$frmmname=$1;}
					if($line =~ /\<lname\>(.+)\<\/lname\>/)  
					{	$frmlname=$1;}					
					if($line =~ /\<address\>(.+)\<\/address\>/)  
					{	$frmaddr=$1;}
					if($line =~ /\<city\>(.+)\<\/city\>/)  
					{	$frmcity=$1;}
					if($line =~ /\<state\>(.+)\<\/state\>/)  
					{	$frmstate=$1;}					
					if($line =~ /\<zip\>(.+)\<\/zip\>/)  
					{ 	$zippy=$1;}									
				}
				#Break the flagy variable reading now on
				if($flagy==1 && $line=~/\<\/user/)
				{
				$flagy=0;
				}			
			}	
		close(MYFILEINDEX);	
		$fulladdr=$frmaddr." ".$frmcity." ".$frmstate." ".$zippy;
		
		#Check if PERL LWP Module is installed
		if(eval{require LWP::Simple;})
		{
		}
		else
		{
			print "You need to install the Perl LWP module!<br>";
			exit;
		}
		#Match if userid/password entered in the page is not blank
		if (($userid eq "") && ($userpwd eq ""))
		{
		print "<b><font color=red>Credentials (Username/Password) can not be blank.\n</b></font>";exit;
		}
		#Match userid/password entered in the page from XML values
		if (($userid eq $frmlogin) && ($userpwd eq $frmpwd))
		{
			print "<center><font size=5><b>Welcome $frmfname!</font></b></center></br>";		
			print "<center><font size=4><b>You are from $fulladdr</font></b></center></br>";		
			print "<center><font size=6><b>The Movies in Theater today </font></b></center></br></br>";		
			$url = "http://www.flixster.com/showtimes/$zippy";
			$content = LWP::Simple::get($url);
			#print "$content";			
			open(FXFL,">flixcode.txt");			
			print FXFL $content;				
			system("display.pl");
		}
		else 
		{
		print "<center><b><font color=red>Invalid Credentials (Username/Password).</br>Username does not exist or password is wrong.\n</b></font>";
		$rdurlreg="<a href='http://cs-server.usc.edu:17418/hw6page2.html'>Registration</a>";
		$rdurllog="<a href='http://cs-server.usc.edu:17418/hw6page3.html'>Login</a>";
		print "</br></br> If you are not a registerd user Please go to $rdurlreg form to register!!</br>";
		print "<b>OR</b></br> Go back to $rdurllog form to try again!!</br></center>";
		exit;
		}
	} 

	else
	{
		$rdurl="<a href='http://cs-server.usc.edu:17418/hw6page2.html'>Click here</a>";
		print "\n UserId does not Exists!! \n Please go back to form at $rdurl and register!!\n";
		exit;
	}
#End of Program