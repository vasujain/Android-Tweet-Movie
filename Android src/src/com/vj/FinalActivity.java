package com.vj;

//Importing packages from Twitter4J library
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;

//Importing packages for Android 
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.Toast;

public class FinalActivity extends Activity {
    
	//Setting up parameters and api tokens for the application
	public static final String CONSUMER_KEY = "sGHzinj2auQp9Mo8fUjIOA";
	public static final String CONSUMER_SECRET= "zdOik4YZVWMIY31zg1r24ITTlm1KLE0bXsFLRZhf84";
	private static final String CALLBACK_URL = "twitterapp://callback";// The url that Twitter will redirect to after a user log
	
	public static final String REQUEST_URL = "http://api.twitter.com/oauth/request_token";
	public static final String ACCESS_URL = "http://api.twitter.com/oauth/access_token";
	public static final String AUTHORIZE_URL = "http://api.twitter.com/oauth/authorize"; 
	private static final String PREF_ACCESS_TOKEN = "accessToken"; // Called when the activity is first created.      
	private static final String PREF_ACCESS_TOKEN_SECRET = "accessTokenSecret";// Name to store the users access token secret   

	private SharedPreferences mPrefs;     // Preferences to store a logged in users credentials 
	private Twitter mTwitter;			  // new TwitterFactory().getInstance(); 
	private RequestToken mReqToken; 	  // The request token signifies the unique ID of the request you are sending to twitter  
	 
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        //Retrieve and hold the contents of the preferences file, returning a SharedPreferences to retrieve and modify its values.
		mPrefs = getSharedPreferences("twitterPrefs", MODE_PRIVATE);        	
		//Creating a new instance of the TwitterFactory. 
        mTwitter = new TwitterFactory().getInstance();   
		//With OAuth authorization scheme, an application can access the user account without userid/password combination given.		
        mTwitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
        
        Button btnLogin = (Button)findViewById(R.id.btnLogin);
        btnLogin.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				loginNewUser();
			}
		});
	}
    
    //All Twitter Stuff goes down here
    //Access the user account without userid/password combination given.
	public void loginNewUser() {    	
    	try { 
    			//we point the callbackURL to the intent filter that we created in the application xml file.
				mReqToken = mTwitter.getOAuthRequestToken(CALLBACK_URL);
    			WebView twitterSite = new WebView(this);
    			System.out.println(twitterSite);
    			
    			twitterSite.loadUrl(mReqToken.getAuthenticationURL());
    			System.out.println(mReqToken.getAuthenticationURL());
    			
    			setContentView(twitterSite);
        	}
    	catch (TwitterException e) {
    		System.out.println("Exception is "+e);
        	Toast.makeText(this, "Twitter Login error, try again later", Toast.LENGTH_SHORT).show();
        }
    }
    
    @Override
    protected void onNewIntent(Intent intent) {    
    	super.onNewIntent(intent);           
            dealWithTwitterResponse(intent);
    }
    
	//
    private void dealWithTwitterResponse(Intent intent) { 
    	Uri uri = intent.getData();
        if (uri != null && uri.toString().startsWith(CALLBACK_URL)) { // If the user has just logged in
                String oauthVerifier = uri.getQueryParameter("oauth_verifier");
                authoriseNewUser(oauthVerifier);
        }
    }
    
    //Function to authorise a new user using its access token 
	private void authoriseNewUser(String oauthVerifier) {
    	AccessToken at ;
    	try {	        	
        	System.out.println("4. authoriseNewUser");
        	at = mTwitter.getOAuthAccessToken(mReqToken, oauthVerifier);
        	mTwitter.setOAuthAccessToken(at);
            saveAccessToken(at);                
            	//mTwitter.updateStatus("Successfully updated the status to Twitter from my First Android Application using #twiiter4j\n");
                //accessToken: AccessToken{screenName='vasujain', userId=35442559}
                // Set the content view to Screen2 after we changed to a webview
                Intent screenEnterZip = new Intent(FinalActivity.this, SearchMovie.class);
            	startActivity(screenEnterZip);// Perform action on click
        		} 
        catch (TwitterException e) {
        			System.out.println("Exception caught:  "+e);
        			Toast.makeText(this, "Twitter auth error x01, try again later", 5).show();
        		}
    }
    
    //Save access token and secret into prefernce files for later use
	public void saveAccessToken(AccessToken at) {	    	
        String token = at.getToken();
        String secret = at.getTokenSecret();
        SavePreferences("ATOKEN", token);
        SavePreferences("ASECRET", secret);
        Editor editor = mPrefs.edit();
        editor.putString(PREF_ACCESS_TOKEN, token);
        editor.putString(PREF_ACCESS_TOKEN_SECRET, secret);
        editor.commit();
    }  
    
    //Function ot save Preferences in TWITTER_PREF file
	private void SavePreferences(String key, String value)
    {
        SharedPreferences sharedPreferences = getSharedPreferences("TWITTER_PREF", MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(key, value);
        editor.commit();
    }    
}