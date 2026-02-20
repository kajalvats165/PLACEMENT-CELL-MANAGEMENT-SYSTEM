<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Admin")){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Application Status</title>
  
    <style>
    /* General Body Styles */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f5f7fa;
    margin: 0;
    padding: 0;
}

/* Container for Pages */
.container {
    max-width: 1200px;
    margin: 40px auto;
    padding: 25px;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}

/* Headings */
h2 {
    text-align: center;
    color: #1a73e8;
    margin-bottom: 25px;
}

/* Forms */
form input[type="text"],
form input[type="email"],
form input[type="password"],
form button {
    display: block;
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border-radius: 8px;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

form button {
    background-color: #1a73e8;
    color: #fff;
    border: none;
    cursor: pointer;
    font-weight: bold;
    transition: 0.3s;
}

form button:hover {
    background-color: #155ab6;
}

/* Cancel Button */
.cancel-btn {
    display: inline-block;
    padding: 10px 20px;
    margin-top: 10px;
    text-decoration: none;
    color: #fff;
    background-color: #f44336;
    border-radius: 8px;
    transition: 0.3s;
}

.cancel-btn:hover {
    background-color: #d32f2f;
}

/* Tables */
table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 5px 20px rgba(26, 115, 232, 0.1);
}

th {
    background: linear-gradient(135deg, #1a73e8, #4dabf7);
    color: #fff;
    text-align: left;
    padding: 12px 15px;
    font-weight: 600;
}

td {
    padding: 12px 15px;
    border-bottom: 1px solid #e0e0e0;
    color: #333;
    background-color: #fff;
}

tr:nth-child(even) td {
    background-color: #f4f7fc;
}

tr:hover td {
    background-color: #e6f0ff;
    transition: 0.3s;
}

/* Cards (Admin Dashboard Links) */
.cards {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 20px;
    margin-top: 30px;
}

.card {
    flex: 1 1 200px;
    max-width: 220px;
    padding: 20px;
    background-color: #1a73e8;
    color: #fff;
    text-align: center;
    border-radius: 12px;
    text-decoration: none;
    font-weight: bold;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    transition: 0.3s;
}

.card:hover {
    background-color: #155ab6;
    transform: translateY(-5px);
}

/* Responsive Table for Mobile */
@media screen and (max-width: 768px) {
    table, thead, tbody, th, td, tr {
        display: block;
    }
    td {
        padding-left: 50%;
        position: relative;
    }
    td::before {
        content: attr(data-label);
        position: absolute;
        left: 15px;
        width: 45%;
        padding-left: 10px;
        font-weight: bold;
    }
}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Student Applications Status</h2>

    <table border="1" class="select-table">
        <tr>
            <th>Application ID</th>
            <th>Student Name</th>
            <th>Email</th>
            <th>Company</th>
            <th>Designation</th>
            <th>Date of Apply</th>
            <th>Status</th>
        </tr>

        <%
        String query = "SELECT a.id AS appid, s.name AS sname, s.email, c.name AS cname, j.designation, a.date_of_apply, a.status " +
                       "FROM application a " +
                       "JOIN student s ON a.student_id = s.id " +
                       "JOIN job j ON a.job_id = j.id " +
                       "JOIN company c ON j.company_id = c.id";

        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
        %>
        <tr>
            <td><%= rs.getInt("appid") %></td>
            <td><%= rs.getString("sname") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("cname") %></td>
            <td><%= rs.getString("designation") %></td>
            <td><%= rs.getDate("date_of_apply") %></td>
            <td><%= rs.getString("status") %></td>
        </tr>
        <% } %>
    </table>
</div>

</body>
</html>
