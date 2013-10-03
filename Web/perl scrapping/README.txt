Name: Vasu Jain
ClassID: 17418 
Homework URL: http://www-scf.usc.edu/~vasujain/vjhwawt571

This Assignment consists of 5 HTML files, 1 Javascript File, 1 Readme File and 2 Perl Script Files.

HTML Page description:
----------------------

1.) hw6.html page contains the Input form having 3 links. User can register, login or check registration history using this page. Reg History page is linked to a copy alluserlist.xml of the index.xmlfile.

2.) hw6page2.html page is used to register a user in the system. This form asks for user details and submit them to server.

3.) hw6page3.html page contains username,password authentication. If connected it will take user to hw6page4.html

JavaScript Code description:
----------------------------

1.) inputcheck.js file is used in hw6page2.html to check input validations like zip code must be 5 digits, passwords must match, no empty field.


JavaScript Functions on hw6page2.html
-------------------------------------

1.) testInput : For input validations in the page.


Perl scripts Description
------------------------

1.) test.pl script uses the input to parse it and store in the XML file. It also checks duplicate user accounts.

2.) login.pl used to authenticate user & display header for the final output.

3.) dispaly.pl parses finally all the text from flixter to show them in a table.


Total Number of files 
---------------------

1.) hw6.html (File linked to the Homework Page)
2.) hw6page2.html
3.) hw6page3.html
4.) inputcheck.js
5.) info.pl
6.) login.pl
7.) display.pl 
8.) README.txt
9.) index.xml (containing the user entries)

*****************
*	NOTE	*  
*****************

My code is built in a way that it writes two small intermediatry files, "shrt.txt" and "flixcode.txt" in between the processing.
These files are created by the PERL scripts and are necessary for the program processing.