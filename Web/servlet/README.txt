Name: Vasu Jain
ClassID: 17418 
Homework URL: http://www-scf.usc.edu/~vasujain/vjhwawt571
Homework # 8

This Assignment consists of 1 HTML file, 1 Perl Script File, 1 Readme File and 1 Servlet Files.

HTML Page description:
----------------------

1.) hw8.html page contains the Input form having search box to enter the data. It also has the javascript validations.One of the Javascript function used to make an AJAX call. While other one parses JSON & displays the variables in tabular format. 


Perl scripts Description
------------------------

1.) movielog.pl script parses all the text from flixter to send them as a XML to servlet.


Servlet Description
------------------------

1.) HelloWorld.java Servlet parses all the xml text from the PERL file, converts it into JSON to send them to Javascript function.


Total Number of files 
---------------------

1.) hw8.html (File linked to the Homework Page)
2.) movielog.pl 
3.) HelloWorldExample.java


**************
*****NOTE*****
**************

The homework link page by me is setup at : http://www-scf.usc.edu/~vasujain/vjhwawt571/

Here when you click on #hw8 it will point to http://cs-server.usc.edu:17419/hw8    

Now, when you have reached hw8 page on clicking the link above, it will take you to a page a input field to enter Zip code: 

a) Enter the Zip code in the input box and press submit.

b) While the Result set is being processed and fetched from the server, an intermediate message "Result set is Loading...Please wait!!
" will be shown.

c) There after if the results are fetched successfully, it will show the result of all the movies in near by theater with a tweet button. else it will display an error message "Movies not found in the area".