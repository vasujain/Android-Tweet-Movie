Project Description:

The Android Mobile application does the following sequence of actions:
a) Authorizes (logs in) the user to Twitter. using Twitter API and oAuth Authentication Protocol
b) Validate user input in the edit box provided to enter a ZIP code. When "Get Movies" button is clicked, the JSON data from Tomcat is retrieved.
c) Data about the Flixster movies in the first listed theater and images are displayed, and the UI allows to select one of the movies through a set of radio buttons.
d) Tweet about the movie you selected: the information to be tweeted includes: The title
of the movie, the name of the theater and the first show time listed for that movie. 

Flow of Data:
The app calls a java servlet which in-turn calls a perl script which give xml data to the servlet, the servlet sends the JSON data to the app and JSON is parsed in the app.

The 3 classes used for 3 different Screens:
"DisplayMovies.java"
"FinalActivity.java"
"SearchMovie.java"

The 3 corrosponding Layout XMLs for above classes:
"main.xml"
"main2.xml"
"main3.xml"

One manifest XML file programmed:
"AndroidManifest.xml"

Also contains Android application package file (APK) to distribute and install this application software onto Google's Android operating system.
"Tweet Flixster Movies.apk"

Video Link : http://www.youtube.com/watch?v=oB-XCtMokkc