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

 

<%

    
    if (posts.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' is empty.</p>

        <%

    } else {

        %>

        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (Post post : posts) {

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

 

    <form action="/ofysign" method="post">

      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Post Greeting" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>

 

  </body>

</html>