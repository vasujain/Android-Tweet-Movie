#!/usr/usc/bin/perl -w
use CGI::Carp qw(fatalsToBrowser);
print "content-type:text/xml \n\n";
use CGI;
my $query = CGI->new();
$zip=$query->param('zip');

#Check if PERL LWP Module is installed
if(eval{require LWP::Simple;})
{
}
else
{
	print "You need to install the Perl LWP module!<br>";
	exit;
}
		
$url = "http://www.flixster.com/showtimes/$zip";
$content = LWP::Simple::get($url);
#print "$content";			
open(FXFL,">flixcode.txt");			
print FXFL $content;		
close(FXFL);		
#system("display.pl");		

open(FXFILE,"flixcode.txt");
open(SHRT,">shrt.txt");
$count=0;$flag=0;
foreach $line (<FXFILE>) 
	{	
		if($line =~ /\<div\sclass\=\"theater/)#\"\>/)
		{	
		$flag=$flag+1;					
		}
		if ($flag==1)
		{
		#print "<center>";
		#print $line;
		print SHRT $line;
		#$count++;
		#//TheaterName Line4 //Theater Address Line5
		}
		if($flag>1) 
		{		
		close(FXFILE);
		close(SHRT);		
		}				
	}

#Variables for storing intermediate values are defined. They will be used in tabular printing.
$lineFlag=0;
$thName="";			#Variable to store name of a theater
$thAdd="";			#Variable to store address of a theater
$movieCount=0;		#Variable to store number of movies in a theater
$spclString="";
@movieURL;			#Finds Movie page's URL
@movieName;			#Finds Movie Name
@movieSpan;			#Finds Timespan for Mvoie
@movieImgURL;		#Finds URL where img poster is
@movieImageURL;		#Finds Img URL for Poster
@movieString;		#Finds Movie Time 
#@movieTime;

#This code will assign all variables with some values
open(SHRTVAR,"<shrt.txt");	
foreach $line (<SHRTVAR>) 
	{		
		#<a href="/showtimes/university-village-3" >University Village 3</a></h2>
		if($line =~ /\<a\shref\=\"\/showtimes\/(?:\w|\-|\w)*\"\s\>(.+)\<\/a/) 
		{
		$thName= $1;
		}
		#<i>3323 South Hoover Street, Los Angeles CA 90007 | (213) 748-6321</i>
		if($line =~ /\<i\>(.+)\<\/i/) 
		{
		$thAdd= $1;
		}			
		#<a href="/movie/dream-house-2011"  title="Dream House" onmouseover="mB(event, 771204354);"  >Dream House</a>
		if ($line =~ /\<a\shref\=\"\/movie\/(.+)\"\s\stitle/) 
		{
		@movieURL[$movieCount]=$1;
		}
		
		
		if ($line =~ /title\=\"(.+)\"\sonmouseover(.+)\>(.+)\<\/a\>/) 
		{
		@movieName[$movieCount]=$3;
		}
		#<span>(PG-13 , 1 hr. 31 min.)</span>
		if ($line =~ /\<span\>(.+)\<\/span/) 
		{
		@movieSpan[$movieCount]=$1;
		}
		#<div class="times">
		
		if (($lineFlag>0) && ($line =~ /\<\/div\>/))  
		{
		$lineFlag--;
		}		
		
		if ($lineFlag==1)
		{
			if(($line =~ /\</))  
			{
			@movieString[$movieCount]=@movieString[$movieCount]."";
			}
			else
			{
			@movieString[$movieCount]=@movieString[$movieCount].$line;
			}		
		}
		
		if ($line =~ /\<div\sclass\=\"times\"\>/)#(.+)\<\/div/) 
		{
		$lineFlag++;
		}				
		
		
		#<div class="mtitle">  Take its count
		if ($line =~ /\<div\sclass\=\"mtitle\"/)
		{
		$movieCount++;
			if ($movieCount==0)
			{
			print "<center><table border=2 style='text-align:center;'><tr><td colspan=4><font size=4><p><b>$thName</b></p></font><p><i>$thAdd</i></p></td></tr>";
			print "</br>MSorry, we have no showtime information for this theater at this time.";
			exit;
			}
		}
		
	}
	
	#Check if PERL LWP Module is installed
		if(eval{require LWP::Simple;})
		{
		}
		else
		{
			print "You need to install the Perl LWP module!<br>";
			exit;
		}
	
	#Final Table Printing	
	#print "<?xml version=\"1.0\" encoding=\"utf-8\"?>";# <rsp stat=\"ok\">";
	print "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?> <rsp stat=\"ok\">";
	print "<movies total=\"$movieCount\">";	
	for ($i=1;$i<=$movieCount;$i++)
	{
				@movieImgURL[$i]="http://www.flixster.com/movie/".@movieURL[$i];#."-photos";
				$content = LWP::Simple::get(@movieImgURL[$i]);	
				open(MOV2,">mov.txt"); print MOV2 $content;	close(MOV2);
	
		open(MOV2,"<mov.txt");	
		foreach $line (<MOV2>) 
			{		
			if (($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"120\"/) ||($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"115\"/)||($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"117\"/)  ||($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"119\"/) )
				{	@movieImageURL[$i]=$1;	}
			}
			
			@movieName[$i]=~s/&/&amp;/g;
			@movieName[$i]=~s/'/&apos;/g;
		print "<movie cover='@movieImageURL[$i]' Title='@movieName[$i]' MovieDuration='@movieSpan[$i]' showtime='@movieString[$i]' theatre='$thName' url='http://www.flixster.com/movie/@movieURL[$i]' />";
	}
	print "</movies>";
	print "</rsp>";
	exit;	
#End of Program


###Part2 ### Prints a XML File as well
#	open(XMLF,">123.xml");	
#	print XMLF "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
#	print XMLF "<movies total=\"$movieCount\">";	
#	for ($i=1;$i<=$movieCount;$i++)
#	{
#				@movieImgURL[$i]="http://www.flixster.com/movie/".@movieURL[$i];#."-photos";
#				$content = LWP::Simple::get(@movieImgURL[$i]);	
#				open(MOV2,">mov.txt"); print MOV2 $content;	close(MOV2);
#	
#		open(MOV2,"<mov.txt");	
#		foreach $line (<MOV2>) 
#		{
#		if (($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"120\"/) ||($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"115\"/)  ||($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"119\"/) )
#			{		@movieImageURL[$i]=$1;		}
#		}
#		print XMLF "<movie cover='@movieImageURL[$i]' Title='@movieName[$i]' MovieDuration='@movieSpan[$i]' showtime='@movieString[$i]' theatre='$thName'/>";		
#	}
#	print XMLF "</movies>";
#	exit;	
#End of Program
