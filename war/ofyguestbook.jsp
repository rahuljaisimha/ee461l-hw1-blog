<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="guestbook.Post" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="java.util.Collections" %>

<%@ page import="com.googlecode.objectify.*" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

   <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
   
   	<script type="text/javascript">
   		var showAll = false;
   		
   		
   		
   		function showAllOn(){
   			showAll = true;
   		}
   		
   		function showAllOff(){
   			showAll = false;
   		}
   		
   		function getShowAll(){
   			return showAll;
   		}
	</script>
   
 </head>

 

  <body>
 

<%
       
	ObjectifyService.register(Post.class);
	
	List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();   
	
	Collections.sort(posts); 

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();
%>
			<div id="header">
				<img src="nishanths.jpg" height="80px">
				<h1>BlogName</h1>
			
<%

    if (user != null) {

      pageContext.setAttribute("user", user);

%>			


<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to post.</p>

<%

    }

%>



</div>

<div id="main">

<%

    
    if (posts.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' is empty.</p>

        <%

    } else {

        %>

        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (Post post : posts.subList(0, 3)) {

            pageContext.setAttribute("greeting_content",

                                     post.getContent());

            if (post.getUser() == null) {

                %>

                <p>An anonymous person wrote:</p>

                <%

            } else {

                pageContext.setAttribute("greeting_user",

                                         post.getUser());

                %>

                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>

                <%

            }

            %>

            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>

            <%

        }

    }

%>

	<button onclick="showAllOn()">Show All</button>
    
<!--
	<form action="/ofysign" method="post">

      <div><textarea name="title" rows="1" cols="60"></textarea></div>
      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Post Blogpost" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>
-->

 
	</div>
  </body>

</html>