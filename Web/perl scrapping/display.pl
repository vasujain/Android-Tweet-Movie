#!/usr/usc/bin/perl -w
use CGI::Carp qw(fatalsToBrowser);
#print "content-type:text/plain \n\n";

#File is  opened and data for first theater is extracted from it between first theater class
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
		if ($line =~ /title\=\"(.+)\"\sonmouseover/) 
		{
		@movieName[$movieCount]=$1;
		}
		#<span>(PG-13 , 1 hr. 31 min.)</span>
		if ($line =~ /\<span\>(.+)\<\/span/) 
		{
		@movieSpan[$movieCount]=$1;
		}
		#<div class="times">
		
		if ($line =~ /\<div\sclass\=\"times\"\>/)#(.+)\<\/div/) 
		{
		$lineFlag++;
		}				
		if ($lineFlag==1)
		{
		@movieString[$movieCount]=@movieString[$movieCount].$line;
		}
		if (($lineFlag>0) && ($line =~ /\<\/div\>/))  
		{
		$lineFlag--;
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
	print "<center><table border=2 style='text-align:center;'><tr><td colspan=4><font size=4><p><b>$thName</b></p></font><p><i>$thAdd</i></p></td></tr>";
	print "<tr><td>Cover</td><td>Title</td><td>Duration</td><td>Showtime</td></tr>";	
	
	#http://www.flixster.com/movie/dream-house-2011-photos
	#http://content9.flixster.com/movie/11/16/02/11160251_pro.jpg
	for ($i=1;$i<=$movieCount;$i++)
	{
	@movieImgURL[$i]="http://www.flixster.com/movie/".@movieURL[$i];#."-photos";
	$content = LWP::Simple::get(@movieImgURL[$i]);	
	open(MOV2,">mov.txt");	
	print MOV2 $content;
	close(MOV2);
	
	open(MOV2,"<mov.txt");	
	foreach $line (<MOV2>) 
	{		
	#<img src="http://content8.flixster.com/movie/11/15/87/11158706_pro.jpg" width="120" height="178"
	if ($line =~ /\<img\ssrc\=\"(.+)\"\swidth\=\"120\"/) 
		{
		@movieImageURL[$i]=$1;
		}
	}
#	close(MOV2);
	
	print "<tr>";	
	print "<td><img src=\"@movieImageURL[$i]\"></td>";
	print "<td>     @movieName[$i]     </td>";
	print "<td>   @movieSpan[$i]   </td>";
	print "<td>  @movieString[$i]  </td>";
	print "</tr>";
	}
	print "</table></center>";
	
	
	#Message to go back to Homepage
	print "<center><b></br><a href='http://cs-server.usc.edu:17418/hw6.html'>Go to Homepage</a></b></center>";
	exit;	
	
#From   name="submitButton" value="Go"  between <div class="theater"> and <div class="theater">
#End of File