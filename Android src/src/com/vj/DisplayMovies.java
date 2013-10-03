package com.vj;

//Importing Apache Packages
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

//Importing JSON Handler Packages
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

//Importing Twitter Packages
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

//Importing JAVA regex,io Packages
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

//Importing Android Packages
import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.TableRow.LayoutParams;
import android.content.SharedPreferences;

//For SAX Parsing of The XML uncomment from here and include these imports
/*
//Importing jdom packages
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import java.net.MalformedURLException;
import java.util.List;
*/

public class DisplayMovies extends Activity {
	
	//Intialization of variables used in program
	
	public static final String CONSUMER_KEY = "sGHzinj2auQp9Mo8fUjIOA";
	public static final String CONSUMER_SECRET= "zdOik4YZVWMIY31zg1r24ITTlm1KLE0bXsFLRZhf84";
	
	public String flixURL="";
	public String servletURL="";
	public int btnFlag= 0;
	int indexRB =0;
	int myzip=0;
	int movieLength = 0;

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main3);
        
        //Parsing data bundled from oither class
		Bundle extras = getIntent().getExtras();        
        myzip = extras.getInt("globalZip");        
        
		//Setting up PERL request URL
		flixURL=("http://cs-server.usc.edu:17418/cgi-bin/movielog.pl?zip=" + myzip);
        displayAllMovieList();                
    }
        
    public void displayAllMovieList()
    {
    	
    	//JSONXML Stuff
		//Calling Servlet
    	 servletURL = "http://cs-server.usc.edu:17419/examples/servlet/HelloWorldExample?search="+myzip;
         final JSONArray moviesArray;
			
         //Retrieving Servlet result in a JSON Object and store them in array data structures
		 try {
      	   	DefaultHttpClient dhc = new DefaultHttpClient();
  	    	ResponseHandler<String> rh = new BasicResponseHandler();
  	    	HttpGet getMethod = new HttpGet("http://cs-server.usc.edu:17419/examples/servlet/HelloWorldExample?search="+myzip);
  	    	String response = dhc.execute(getMethod, rh);  
  	    	JSONObject json = new JSONObject(response);
  	    	moviesArray  = json.getJSONObject("movies").getJSONArray("movie");
  	    	System.out.println("We got moviesArray: "+moviesArray);
  	    	movieLength = moviesArray.length();
  	    	System.out.println("movieLength :"+movieLength);
  	    	
  	    	JSONObject tempObj = (JSONObject)moviesArray.get(0);
  	 
  	    	final String[] MovieNameJ=new String[movieLength]; //Initialize a String 
    		final String[] MovieCoverJ=new String[movieLength];					        			
			final String[] ShowTimeJ=new String[movieLength];        			
			final String[] MovieURLJ=new String[movieLength];
			final String TheatereNameJ = ((tempObj.getString("theatre")));;					        			
      		
			System.out.println("movieLength is "+movieLength);
			System.out.println("Theatre : "+TheatereNameJ+"  "+(tempObj.getString("theatre")));
			
			final TableLayout myTableJ = (TableLayout)findViewById(R.id.movieListLayout);
			
  	    	for(int i=0;i<moviesArray.length();i++){
  	    		JSONObject movieObj = (JSONObject)moviesArray.get(i);
  	    		
    			MovieNameJ[i]=((movieObj.getString("tile")));
				MovieCoverJ[i]=((movieObj.getString("cover")));
				MovieURLJ[i]=((movieObj.getString("url")));
				
				//To get Showtime RegEx
				Pattern p= Pattern.compile("(\\d*):(\\d*)\\s(AM|PM)");
				Matcher m = p.matcher(movieObj.getString("showtime"));
				if(m.find())
				{
					 String hours = m.group(1);
					 String minutes = m.group(2);
					 String timeFormat = m.group(3);
					 ShowTimeJ[i]= hours+":"+minutes+" "+timeFormat;
				}
				//To get Showtime RegEx				
				
				//Table Layout
				//Display of the Movie Layout starts Here        				
				final TableRow tr = new TableRow(this);
	    		tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
	    		
	    		TextView movieName = new TextView(this);
	    		movieName.setText(MovieNameJ[i]);
	    		movieName.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT));
	    		movieName.setWidth(340);
	    		
	    		ImageView movieCover = new ImageView(this);
	    		Drawable d = LoadImageFromWebOperations(MovieCoverJ[i]);
	    		movieCover.setImageDrawable(d);
	    		movieCover.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT));
	    		
	    		RadioButton rb = new RadioButton(this);
	    		rb.setChecked(false);
	    		rb.setId(i);
	    		
	    		rb.setOnClickListener(new OnClickListener() {
	    			public void onClick(View v) {
	    			
	    				indexRB=v.getId();
	    				for(int i=0;i<movieLength ;i++)
	    					{
	    					RadioButton rb = (RadioButton)findViewById(i);
							rb.setChecked(false);
	    					}
	    				RadioButton rb = (RadioButton)findViewById(indexRB);
						rb.setChecked(true);
						
						if(btnFlag<1){
							btnFlag++;
							Button btnTweet = new Button(v.getContext());
							btnTweet.setText("Tweet");
							LayoutParams btnParams = new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT);
							btnParams.span = 3;
							btnTweet.setLayoutParams(btnParams);
							
							btnTweet.setOnClickListener(new OnClickListener() {
								
								public void onClick(View v) {
									v.setEnabled(false);
										String TweetingText="I will see "+MovieNameJ[indexRB]+" at "+TheatereNameJ+ " at " + ShowTimeJ[indexRB] + "\nLink: " + MovieURLJ[indexRB];
										//Toast.makeText(getBaseContext(),TweetingText,5).show();	
					        			System.out.println(TweetingText);
//
					        			//The code that gets Twitter Running
					        			SharedPreferences sharedPreferences = getSharedPreferences("TWITTER_PREF", MODE_PRIVATE);
					        	    	String aToken = sharedPreferences.getString("ATOKEN", "");
					        	        String aSecret = sharedPreferences.getString("ASECRET", "");
					        	        Twitter mTwitter = new TwitterFactory().getInstance();
					        			mTwitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
					        			AccessToken mAccToken = new AccessToken(aToken, aSecret);
					        			mTwitter.setOAuthAccessToken(mAccToken);
					        			//The code that gets Twitter Running
					        			
					        			try
					        			{
					        				//Update status on Twitter
											mTwitter.updateStatus(TweetingText);
											
											//Display a Toast message on user Screen
					        				Toast.makeText(getBaseContext(),"Tweet Successful",5).show();
					        			}
					        			catch (TwitterException twE)
					        			{
					        				Toast.makeText(getBaseContext(),"Error: "+twE,5).show();	
						        			System.out.println("Error: "+twE);	
					        			}
					        			catch (IllegalStateException isE)
					        			{
					        				Toast.makeText(getBaseContext(),"Error: "+isE,8).show();	
						        			System.out.println("Error: "+isE);	
					        			}
					        			
					        			v.setEnabled(true);
								}
							});
						TableLayout myTable = (TableLayout)findViewById(R.id.movieListLayout);
						TableRow btnRow = new TableRow(v.getContext());	
						btnRow.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
						btnRow.addView(btnTweet);
						myTable.addView(btnRow, new TableLayout.LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT));
						}
						
					}
	    		});
				
	    		rb.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT));
	    		tr.addView(movieName);
	    		tr.addView(movieCover);
	    		tr.addView(rb);        	    		
	    		myTableJ.addView(tr, new TableLayout.LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.WRAP_CONTENT));
				
	    		//Display of the Movie Layout Ends here
	    		//Table Layout
				
				String TweetingTextJ="I will see "+MovieNameJ[i]+" at "+TheatereNameJ+ " at " + ShowTimeJ[i] + "\nLink: " + MovieURLJ[i]+"\nMovieCoverURL: "+MovieCoverJ[i];				
    			System.out.println(TweetingTextJ);  	    		
  	    		}
  	    	
  		} 
     		catch (IOException e) {
     			System.out.println("Exception: "+e);}
     		catch(RuntimeException rtE){
     			System.out.println("Exception: "+rtE);} 
     		catch (JSONException jsonE) {
     			System.out.println("Exception: "+jsonE);
     			
     			TextView NoMovies = new TextView(this);
	    		NoMovies.setText("There are no Movies for this Zip Code. \nPress Going back to Search Movie screen to try Another Zip Code\n\n");
	    		setContentView(NoMovies);
	    		
				}
  		//JSONXML Stuff
    }
    
    //To draw Image from a URL of the image
	public static Drawable LoadImageFromWebOperations(String url) 
    {
	    try 
	    {
		    InputStream is = (InputStream) new URL(url).getContent();
		    Drawable d = Drawable.createFromStream(is, "src name");
		    return d;
	    } 
	    catch (Exception e) 
	    {
	    	return null;
	    }
    }    
}