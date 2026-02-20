<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Company")){
    response.sendRedirect("login.jsp");
}
String email = (String)session.getAttribute("userid");

// Get company ID
PreparedStatement psid = con.prepareStatement("SELECT id FROM company WHERE email=?");
psid.setString(1, email);
ResultSet rsid = psid.executeQuery();
int cid = 0;
if(rsid.next()) cid = rsid.getInt("id");
%>

<!DOCTYPE html>
<html>
<head>
<title>Applied Students</title>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #e0f7ff, #f9f9f9);
    margin: 0;
    padding: 0;
    color: #333;
}

.container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 30px 40px;
    background-color: #fff;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 123, 255, 0.15);
}

h2 {
    text-align: center;
    color: #007bff;
    margin-bottom: 25px;
    font-size: 28px;
}

/* Table Styling */
.select-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 6px 25px rgba(0, 123, 255, 0.1);
    font-size: 15px;
}

.select-table th {
    background: linear-gradient(135deg, #007bff, #00bfff);
    color: white;
    text-align: left;
    padding: 14px 16px;
    font-weight: 600;
    letter-spacing: 0.5px;
}

.select-table td {
    padding: 12px 15px;
    border-bottom: 1px solid #f0f0f0;
    background-color: #fff;
    color: #333;
}

.select-table tr:nth-child(even) td {
    background-color: #f3faff;
}

.select-table tr:hover td {
    background-color: #e6f0ff;
    transform: scale(1.01);
    transition: 0.3s;
}

/* Form inside table */
.select-table form {
    display: flex;
    gap: 8px;
    align-items: center;
}

.select-table select {
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 14px;
    transition: 0.3s;
}

.select-table select:focus {
    border-color: #007bff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
    outline: none;
}

.select-table button {
    padding: 6px 14px;
    border: none;
    border-radius: 20px;
    background-color: #28a745;
    color: white;
    font-weight: 500;
    cursor: pointer;
    transition: 0.3s;
}

.select-table button:hover {
    background-color: #218838;
}

/* Status badges */
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-weight: 500;
    font-size: 13px;
    color: white;
    text-align: center;
    display: inline-block;
}

.status-applied { background-color: #ffc107; color: #333; }
.status-selected { background-color: #28a745; }
.status-rejected { background-color: #dc3545; }

/* Responsive Table */
@media (max-width: 768px) {
    .container {
        margin: 20px;
        padding: 20px;
    }
    .select-table th, .select-table td {
        font-size: 13px;
        padding: 8px 10px;
    }
    .select-table form {
        flex-direction: column;
        gap: 5px;
    }
}
</style>

</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Students Applied to Your Jobs</h2>

    <%
    // ✅ Update Status Logic
    if(request.getParameter("updateStatus")!=null){
        int appId = Integer.parseInt(request.getParameter("appId"));
        String status = request.getParameter("status");

        PreparedStatement ps = con.prepareStatement("UPDATE application SET status=? WHERE id=?");
        ps.setString(1, status);
        ps.setInt(2, appId);
        ps.executeUpdate();
        out.println("<script>alert('Status Updated!');window.location='appliedStudents.jsp';</script>");
    }

    // ✅ Show Applied Students
    String q = "SELECT a.id AS appid, s.name AS sname, s.email, j.designation, a.date_of_apply, a.status " +
               "FROM application a " +
               "JOIN student s ON a.student_id=s.id " +
               "JOIN job j ON a.job_id=j.id " +
               "WHERE j.company_id=?";
    PreparedStatement ps = con.prepareStatement(q);
    ps.setInt(1, cid);
    ResultSet rs = ps.executeQuery();
    %>

    <table border="1" class="select-table">
        <tr>
            <th>App ID</th><th>Student</th><th>Email</th><th>Designation</th><th>Date</th><th>Status</th><th>Action</th>
        </tr>
        <% while(rs.next()){ %>
        <tr>
            <td><%= rs.getInt("appid") %></td>
            <td><%= rs.getString("sname") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("designation") %></td>
            <td><%= rs.getDate("date_of_apply") %></td>
            <td>
    <span class="status-badge 
        <%= rs.getString("status").equals("Applied") ? "status-applied" : 
            rs.getString("status").equals("Selected") ? "status-selected" : "status-rejected" %>">
        <%= rs.getString("status") %>
    </span>
</td>

            <td>
                <form method="post">
                    <input type="hidden" name="appId" value="<%= rs.getInt("appid") %>">
                    <select name="status">
                        <option value="Applied" <%= rs.getString("status").equals("Applied") ? "selected" : "" %>>Applied</option>
                        <option value="Selected" <%= rs.getString("status").equals("Selected") ? "selected" : "" %>>Selected</option>
                        <option value="Rejected" <%= rs.getString("status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                    <button type="submit" name="updateStatus">Update</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>

</body>
</html>
