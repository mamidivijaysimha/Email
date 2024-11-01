<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<%
String driver = "com.mysql.jdbc.Driver";
String connectionUrl = "jdbc:mysql://localhost:3306/";
String database = "emailsoftware";
String userid = "root";
String password = "PHW#84#vijay";
try {
Class.forName(driver);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
ResultSet resultSet = null;

String mfrom = session.getAttribute("email").toString(); 

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>

        *{
          padding: 0px;
          margin: 0px;
          box-sizing: border-box;
        }

        body{
          width: 100vw;
          height: 100vh;
        }

        p{
            color: blue;
        }

        .btn{
          text-decoration: none;
          color:white;
          width: 100px;
          height: 30px;
          background-color: black;
          padding: 5px 10px;
          border-radius: 3px;
        }

        .nav-menu li a{
          color: black;
        }

        .btn:hover{
          color: black;
          background-color: #fff;
          transition: ease-in-out 10ms;
          box-shadow: rgba(0, 0, 0, 0.3) 0px 0px 1px 2px;
        }

        .container{
          width: 100%;
          display: flex;
          height: 100%;
        }

        .sidebar{
          padding: 10px;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          gap: 50px;
          flex: 0.2;
          background-color: rgba(0, 0, 0, 0.1);
          border-radius: 1rem;
          box-shadow: rgba(0, 0, 0, 0.3) 0px 0px 1px 1px;
        }

        ul {
          display: flex;
          flex-direction: column;
          gap: 5px;
        }

        li{
          list-style-type: none;
        }

        .active{
          color: red !important;
        }

        .main-container{
          flex: 1;
          padding: 20px;
        }

        .header{
          width: 100%;
          display: flex;
          justify-content: space-between;
          background-color: rgba(0, 0, 0, 0.1);
          padding: 10px;
          box-shadow: rgba(0, 0, 0, 0.3) 0px 0px 1px 2px;
          border-radius: 3px;
        }

        .header > span{
          font-size: 1.5rem;
          font-weight: 600;
        }

        .inbox{
          padding: 20px;
        }
        
        .content{
          width: 100%;
          display: flex;
          justify-content: space-between;
          margin-bottom: 8px;
        }
    </style>
</head>
<body>

    <%
        String user;

        if(session.getAttribute("email") != null)
        {
          user = session.getAttribute("email").toString();
        %>
        
      <div class="container">
      <section class="sidebar">
        <div class="user">
          <h3><%=user%></h3>
          <%}%>
        </div>
        <ul class="nav-menu">
          <li><a href="inbox.jsp" class="active">Inbox</a></li>
          <li><a href="sentbox.jsp">Sent</a></li>
          <li><a href="./trash.jsp">Trash</a></li>
          <li><a href="compose.jsp">Compose</a></li>
        </ul>

        <div class="logout">
          <a href="logout.jsp" class="btn">Logout</a>
        </div>
      </section>
      <section class="main-container">
        <div class="header">
          <span>From</span>
          <span>Message</span>
          <span>Delete</span>
        </div>
        <div class="inbox">
          <% 
          
          int flag = 0;
          try{
            connection = DriverManager.getConnection(connectionUrl+database, userid, password);
            statement=connection.createStatement();
            String sql ="select * from emails where mto='"+mfrom+"' and inbox=1";
            resultSet= statement.executeQuery(sql);
          
            while(resultSet.next())
            {
              int id = resultSet.getInt("id");
              flag = 1;
              %>
              <div class="content">
                <span><%=resultSet.getString("mfrom")%></span>
                <%
                  String mf = resultSet.getString("mfrom");
                  String mto = resultSet.getString("mto");
                  String subject = resultSet.getString("subject");
                  String message = resultSet.getString("content");
                  %>
                <a href="viewMail.jsp?mfrom=<%=mf%>&mto=<%=mto%>&subject=<%=subject%>&message=<%=message%>"><span><%=resultSet.getString("content")%></span></a>
                <a href="deleteMail.jsp?id=<%=id%>&inbox=1">Delete</a>
              </div>
  
            <%}

            if(flag == 0)
            {
              out.println("Empty");
            }
            connection.close();
          }
          catch(Exception e){
              out.println(e.getMessage());
          }
          %>
        </div>
      </section>
    </div>
</body>
</html>