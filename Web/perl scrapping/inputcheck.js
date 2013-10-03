function testInput(form)
{
	//Validations for name & address
	if ((form.fname.value) == "")
	{	alert("First Name can not be blank. Please enter a value.");return false;	}
	if ((form.lname.value) == "") 
	{ 	alert("Last Name can not be blank. Please enter a value.");return false;	 	}
	if ((form.addr.value) == "")
	{	alert("Address can not be blank. Please enter a value.");return false;	 	}
	if ((form.city.value) == "")
	{	alert("City can not be blank. Please enter a value.");return false;	 	    }
	
	//Functions to check Zip Code
	if ((form.zip.value) == "")
	{	alert("Zip Code can not be blank. Please enter a value.");return false;	 	}
	if(!(parseInt(form.zip.value)))
	{	alert("Zip Code must have only Digits. Please enter a proper value.");return false;}		
	if (parseInt(form.zip.value) < 10000)
	{	alert("Zip Code must have only 5 Digits. Please enter a proper value.");return false;}	
	if (parseInt(form.zip.value) > 99999)
	{	alert("Zip Code must have only 5 Digits. Please enter a proper value.");return false;}		
	
	if ((form.login.value) == "")
	{	alert("Login Name can not be blank. Please enter a value.");return false;	}
	
	//Functions to check Passwords
	var pwd1Val=form.pwd1.value;
	var pwd2Val=form.pwd2.value;		
	if (pwd2Val!=pwd1Val)
	{ alert("Password & Confirm Passwords do not match");return false;}
	if ((form.pwd1.value) == "")
	{	alert("Password can not be blank. Please enter a value.");return false;	}
	if ((form.pwd2.value) == "")
	{	alert("Confirm Password can not be blank. Please enter a value.");return false;	}	
	
	return true;
	alert("Your Entry is being processed with us ... !!");
	
	
}