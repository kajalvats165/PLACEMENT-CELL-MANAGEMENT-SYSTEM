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
    <title>Selected Students</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">

    <%
    // ✅ Update Status Logic
    if(request.getParameter("updateStatus") != null){
        int appId = Integer.parseInt(request.getParameter("appId"));
        String status = request.getParameter("status");

        PreparedStatement ps = con.prepareStatement("UPDATE application SET status=? WHERE id=?");
        ps.setString(1, status);
        ps.setInt(2, appId);
        ps.executeUpdate();

        out.println("<script>alert('Status Updated Successfully!');window.location='selected.jsp';</script>");
    }
    %>

    <!-- ✅ Table of All Applications -->
    <table border="1" class="select-table">
        <tr>
            <th>Application ID</th>
            <th>Student Name</th>
            <th>Email</th>
            <th>Company</th>
            <th>Designation</th>
            <th>Date of Apply</th>
            <th>Status</th>
            <th>Action</th>
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
            <td>
                <form method="post" style="display:inline;">
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