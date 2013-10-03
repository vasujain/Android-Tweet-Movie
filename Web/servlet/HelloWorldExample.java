/* $Id: HelloWorldExample.java 2011/11/06 @uthored by: Vasu Jain	*/

import java.io.*;
import java.net.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

public class HelloWorldExample extends HttpServlet {
	
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException, ServletException
    {
        ResourceBundle rb =ResourceBundle.getBundle("LocalStrings",request.getLocale());
        response.setContentType("text/plain;charset=ISO-8859-1");
        PrintWriter out = response.getWriter();

        //out.println("<html>");
        //out.println("<head>");
	    String title = rb.getString("helloworld.title");

	    //out.println("<title>" + title + "</title>");
        //out.println("</head>");
        //out.println("<body bgcolor=\"white\">");
 //javac -classpath /home/scf-17/vasujain/Tomcat/jakarta-tomcat-4.1.27/common/lib/servlet.jar:/home/scf-17/vasujain/Tomcat/jakarta-tomcat-4.1.27/common/lib/jdom-1.1.2.jar HelloWorldExample.java

 // cd ~vasujain/Tomcat/jakarta-tomcat-4.1.27/bin/

	    //out.println("<a href=\"/examples/servlets/helloworld.html\">");
        //out.println("<img src=\"/examples/images/code.gif\" height=24 " +
        //            "width=24 align=right border=0 alt=\"view code\"></a>");
        //out.println("<a href=\"/examples/servlets/index.html\">");
        //out.println("<img src=\"/examples/images/return.gif\" height=24 " +
          //          "width=24 align=right border=0 alt=\"return\"></a>");
        //out.println("<h1>" + title + "</h1>");
		//out.println("<h1>" + request.getParameter("search") + "</h1>");
		
		//XML from PERL is Parsed using SAXBuilder & JDOM
		SAXBuilder builder = new SAXBuilder();
		URL url= new URL("http://cs-server.usc.edu:17418/cgi-bin/movielog.pl?zip="+request.getParameter("search"));	
		Document doc = null;		
		try 
		{
		doc=builder.build(url);				
		Element root = doc.getRootElement();
		List children = root.getChild("movies").getChildren("movie");					
		String JSONstr="";
			if(children.size()==0)
			{
			out.print("Movies Not found");	
			}		
			else 
			{
			JSONstr="{\"movies\": { \"total\": "+ children.size()+", \"movie\":[";
				for (int i = 0; i < children.size(); i++) 
					{
						Element movieAtt = (Element)doc.getRootElement().getChild("movies").getChildren("movie").get(i);		
						//Element movieAtt = (Element)doc.getRootElement().getChildren("movie").get(i);
						//Element movieAtt = movieAtt1.get(i);	 
						//JSONstr+=movieAtt;
						
						 JSONstr+="{\"cover\":\""+movieAtt.getAttributeValue( "cover" )+"\",";
						JSONstr+="\"tile\":\""+movieAtt.getAttributeValue( "Title" )+"\",";
						JSONstr+="\"MovieDuration\":\""+movieAtt.getAttributeValue( "MovieDuration" )+"\",";
						JSONstr+="\"showtime\":\""+movieAtt.getAttributeValue( "showtime" )+"\",";
						JSONstr+="\"theatre\":\""+movieAtt.getAttributeValue( "theatre" )+"\",";				
						if(i==(children.size()-1))
						{JSONstr+="\"url\":\""+movieAtt.getAttributeValue( "url" )+"\"}";}
						else
						{JSONstr+="\"url\":\""+movieAtt.getAttributeValue( "url" )+"\"},";}			 
					}	
				JSONstr+="]}}";
				out.println(JSONstr);		
			}	
		}
		// indicates a well-formedness error
		catch (JDOMException e) 
		{ 
		out.println(url + " is not well-formed.");
		out.println(e.getMessage());
		}  
		catch (IOException e) 
		{ 
		out.println("Could not check " + url);
		out.println(" because " + e.getMessage());
		}  
			
		//Code to parse the XML into JSON

		
		//out.println("</body>");
        //out.println("</html>");
    }
}
