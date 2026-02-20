<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Company")){
    response.sendRedirect("login.jsp");
}
String email = (String)session.getAttribute("userid");
PreparedStatement ps = con.prepareStatement("SELECT * FROM company WHERE email=?");
ps.setString(1, email);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Company Dashboard</title>
    <style>
        /* === Global Styles (Same as Admin Dashboard) === */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #1a73e8;
            margin: 25px 0;
        }

        /* === Navbar === */
        .navbar {
            background: linear-gradient(135deg, #1a73e8, #4dabf7);
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(26,115,232,0.2);
        }

        .navbar h2 {
            margin: 0;
            font-size: 1.5em;
        }

        .navbar a {
            background-color: #fff;
            color: #1a73e8;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 6px;
            font-weight: bold;
            transition: 0.3s;
        }

        .navbar a:hover {
            background-color: #e3f2fd;
        }

        /* === Profile Card === */
        .profile-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            padding: 25px 30px;
            max-width: 600px;
            margin: 30px auto;
        }

        .profile-card h3 {
            text-align: center;
            color: #1a73e8;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            width: 35%;
            color: #1e2a38;
        }

        /* === Cards Section (Same as Admin Dashboard) === */
        .cards {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 25px;
            padding: 20px;
        }

        .card {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 220px;
            height: 140px;
            background: linear-gradient(135deg, #1a73e8, #4dabf7);
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(26, 115, 232, 0.2);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: 0 15px 25px rgba(26, 115, 232, 0.3);
            background: linear-gradient(135deg, #155bb5, #1e90ff);
        }

        /* === Footer === */
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #fff;
            border-top: 1px solid #ddd;
            color: #666;
            font-size: 0.9em;
            margin-top: 40px;
        }

        @media screen and (max-width: 768px) {
            .cards {
                flex-direction: column;
                align-items: center;
            }

            .card {
                width: 80%;
            }
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <h2>Company Dashboard</h2>
        <a href="logout.jsp">Logout</a>
    </div>

    <!-- Welcome Message -->
    <%
        if(rs.next()){
    %>
    <h2>Welcome, <%= rs.getString("name") %></h2>

    <!-- Profile Card -->
    <div class="profile-card">
        <h3>Your Company Details</h3>
        <table>
            <tr><th>Name</th><td><%= rs.getString("name") %></td></tr>
            <tr><th>Address</th><td><%= rs.getString("address") %></td></tr>
            <tr><th>Email</th><td><%= rs.getString("email") %></td></tr>
            <tr><th>Phone</th><td><%= rs.getString("phone") %></td></tr>
        </table>
    </div>
    <% } %>

    <!-- Dashboard Cards -->
    <div class="cards">
        <a href="addJob.jsp" class="card">Add / Manage Jobs</a>
        <a href="appliedStudents.jsp" class="card">View Applied Students</a>
    </div>

    <!-- Footer -->
    <div class="footer">
        © 2025 Placement Portal | All Rights Reserved
    </div>

</body>
</html>
