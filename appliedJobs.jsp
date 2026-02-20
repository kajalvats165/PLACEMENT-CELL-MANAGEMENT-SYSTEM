<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Student")){
    response.sendRedirect("login.jsp");
    return;
}

// Get student_id directly from session
int sid = 0;
if(session.getAttribute("student_id") != null){
    sid = (int)session.getAttribute("student_id");
} else {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Applied Jobs</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<!-- Inline CSS -->
<!-- Inline CSS -->
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f4f7fc;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 1100px; /* slightly wider */
        margin: 50px auto; /* more top margin */
        padding: 0 25px; /* a bit more padding */
    }
    h2 {
        text-align: center;
        color: #007bff;
        margin-bottom: 15px;
        font-size: 32px; /* bigger heading */
    }
    .subtitle {
        text-align: center;
        color: #555;
        margin-bottom: 30px;
        font-size: 18px; /* slightly larger */
    }
    .table-container {
        overflow-x: auto;
    }
    .job-table {
        width: 100%;
        border-collapse: collapse;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0, 123, 255, 0.15);
        font-size: 16px; /* bigger text */
    }
    .job-table th {
        background: linear-gradient(135deg, #007bff, #00bfff);
        color: white;
        text-align: left;
        padding: 15px 20px; /* bigger cells */
        font-weight: 600;
        font-size: 17px;
    }
    .job-table td {
        padding: 15px 20px; /* bigger cells */
        border-bottom: 1px solid #e0e0e0;
        color: #333;
        background-color: #fff;
    }
    .job-table tr:nth-child(even) td {
        background-color: #f8faff;
    }
    .job-table tr:hover td {
        background-color: #e6f0ff;
        transition: 0.3s;
    }
    .badge {
        padding: 8px 16px; /* bigger badges */
        border-radius: 25px; /* more rounded */
        color: white;
        font-weight: 600;
        font-size: 14px; /* slightly bigger text */
        text-align: center;
        display: inline-block;
        min-width: 80px; /* make badges more consistent in size */
    }
    .badge-selected { background-color: #28a745; }
    .badge-rejected { background-color: #dc3545; }
    .badge-applied { background-color: #ffc107; color: #333; }
</style>

</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2> Your Applied Jobs</h2>
    <p class="subtitle">Track the status of all the jobs you have applied for.</p>

    <%
    PreparedStatement ps = con.prepareStatement(
        "SELECT a.id, c.name AS cname, j.designation, a.date_of_apply, a.status " +
        "FROM application a " +
        "JOIN job j ON a.job_id = j.id " +
        "JOIN company c ON j.company_id = c.id " +
        "WHERE a.student_id = ? ORDER BY a.id DESC"
    );
    ps.setInt(1, sid);
    ResultSet rs = ps.executeQuery();
    %>

    <div class="table-container">
        <table class="job-table">
            <thead>
                <tr>
                    <th>Application ID</th>
                    <th>Company</th>
                    <th>Designation</th>
                    <th>Date of Apply</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% while(rs.next()){ 
                    String status = rs.getString("status");
                    String badgeClass = "";
                    if(status.equals("Selected")) badgeClass = "badge-selected";
                    else if(status.equals("Rejected")) badgeClass = "badge-rejected";
                    else badgeClass = "badge-applied";
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("cname") %></td>
                    <td><%= rs.getString("designation") %></td>
                    <td><%= rs.getDate("date_of_apply") %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
