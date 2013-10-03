package com.vj;

//Importing packages for Android 
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class SearchMovie extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main2);
        
        Button btnSearch = (Button) findViewById(R.id.btnSearch); 
        
        btnSearch.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {				
				EditText et = (EditText)findViewById(R.id.editTextZipCode);       		
				
				//Validations Start Here for Zip Code
				
        		int tempStr=et.getText().length();        		
        		if(tempStr==0)
        		{
        		 Toast.makeText(getBaseContext(), "Zip Code can not be null", 5).show();
        		}
        		else if(tempStr<5)
        		{
        		 Toast.makeText(getBaseContext(), "Zip Code length can not be less than 5 digits. ", 5).show();
        		}
        		else if(tempStr>5)
        		{
        		 Toast.makeText(getBaseContext(), "Zip Code length can not be more than 5 digits. ", 5).show();
        		}
        		else
        		{
        			int zippy=0;
        			try{
        				 zippy=Integer.parseInt(et.getText().toString());        			 
        			   }
     				catch (NumberFormatException nFE)
     				{
     					 Toast.makeText(getBaseContext(), nFE+ "Please enter digits for US Zip Code", 5).show();
     				}
        			 	if(zippy==0)
        			 	{
        			 		Toast.makeText(getBaseContext(), "Please enter only 5 Digit Numeric value for US Zip Code", 5).show();
        			 	}
        			 	else
        			 	{
						
						//Control reaches this part only and only when all validations are successful
						
        			 	Intent dispScreen = new Intent (SearchMovie.this, DisplayMovies.class);
        			 	
						//Using Buffer putExtra to pass 
        				dispScreen.putExtra("globalZip",zippy);
        				System.out.println("dispScreen.putExtraglobalZip,zippy)");
        				startActivity(dispScreen);   
						
        			 	}
        		 }				
			}
		});        
    }
}