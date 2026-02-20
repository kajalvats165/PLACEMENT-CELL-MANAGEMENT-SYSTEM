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
    <title>Job Openings</title>
    <style>
    /* Container Styling */
.container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 20px;
    background-color: #f8f9fc;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Heading */
.container h2 {
    text-align: center;
    color: #007bff;
    margin-bottom: 25px;
}

/* Table Styling */
.job-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 5px 20px rgba(0, 123, 255, 0.1);
}

/* Table Header */
.job-table th {
    background: linear-gradient(135deg, #007bff, #00bfff);
    color: white;
    text-align: left;
    padding: 12px 15px;
    font-weight: 600;
}

/* Table Body */
.job-table td {
    padding: 12px 15px;
    border-bottom: 1px solid #e0e0e0;
    color: #333;
    background-color: #fff;
}

/* Zebra Stripes */
.job-table tr:nth-child(even) td {
    background-color: #f4f7fc;
}

/* Hover Effect */
.job-table tr:hover td {
    background-color: #e6f0ff;
    transition: 0.3s;
}

/* Responsive Table */
@media screen and (max-width: 768px) {
    .job-table, .job-table thead, .job-table tbody, .job-table th, .job-table td, .job-table tr {
        display: block;
    }
    .job-table tr {
        margin-bottom: 15px;
    }
    .job-table td {
        text-align: right;
        padding-left: 50%;
        position: relative;
    }
    .job-table td::before {
        content: attr(data-label);
        position: absolute;
        left: 15px;
        width: 45%;
        padding-left: 10px;
        font-weight: bold;
        text-align: left;
    }
}
   </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Job Openings (Posted by Companies)</h2>
    
    <table border="1" class="job-table">
        <tr>
            <th>ID</th>
            <th>Company</th>
            <th>Designation</th>
            <th>Description</th>
            <th>Experience</th>
            <th>12th %</th>
            <th>Grad %</th>
            <th>Seats</th>
            </tr>
        <%
        try{
            PreparedStatement ps = con.prepareStatement(
                "SELECT j.*, c.name AS cname FROM job j JOIN company c ON j.company_id=c.id ORDER BY j.id DESC");
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                int jid = rs.getInt("id");
        %>
        <tr>
            <td><%= jid %></td>
            <td><%= rs.getString("cname") %></td>
            <td><%= rs.getString("designation") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= rs.getString("experience") %></td>
            <td><%= rs.getFloat("twelfth_percent") %></td>
            <td><%= rs.getFloat("grad_percent") %></td>
            <td><%= rs.getInt("seats") %></td>
        </tr>
        <% } 
        } catch(Exception e) {
            out.println("<tr><td colspan='8' style='color:red;'>Error fetching jobs: " + e.getMessage() + "</td></tr>");
        }
        %>
    </table>

</div>

</body>
</html>