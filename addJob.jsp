<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Company")){
    response.sendRedirect("login.jsp");
}
String email = (String)session.getAttribute("userid");


// Fetch company ID
PreparedStatement psid = con.prepareStatement("SELECT id FROM company WHERE email=?");
psid.setString(1, email);
ResultSet rsid = psid.executeQuery();
int companyId = 0;
if(rsid.next()) companyId = rsid.getInt("id");

// ✅ Add Job Logic (with Try-Catch for safety)
if(request.getParameter("add") != null){
    try {
        String designation = request.getParameter("designation");
        String description = request.getParameter("description");
        String experience = request.getParameter("experience");
        // Safe parsing with try-catch
        float twelfth_percent = Float.parseFloat(request.getParameter("twelfth_percent"));
        float grad_percent = Float.parseFloat(request.getParameter("grad_percent"));
        int seats = Integer.parseInt(request.getParameter("seats"));

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO job(company_id, designation, description, experience, twelfth_percent, grad_percent, seats) VALUES(?,?,?,?,?,?,?)");
        ps.setInt(1, companyId);
        ps.setString(2, designation);
        ps.setString(3, description);
        ps.setString(4, experience);
        ps.setFloat(5, twelfth_percent);
        ps.setFloat(6, grad_percent);
        ps.setInt(7, seats);
        ps.executeUpdate();
        out.println("<script>alert('Job Added Successfully!');window.location='addJob.jsp';</script>");
    } catch(NumberFormatException e) {
        out.println("<script>alert('Error: Please check all percentage and seat fields for correct numeric data.');</script>");
    } catch(SQLException e) {
        out.println("<script>alert('Database Error: Job could not be added. Check if table structure is correct.');</script>");
    }
}


// ✅ Delete Job Logic
if(request.getParameter("deleteId") != null){
    try {
        int deleteId = Integer.parseInt(request.getParameter("deleteId"));
        PreparedStatement ps = con.prepareStatement("DELETE FROM job WHERE id=? AND company_id=?");
        ps.setInt(1, deleteId);
        ps.setInt(2, companyId); // Restrict to own jobs
        ps.executeUpdate();
        out.println("<script>alert('Job Deleted!');window.location='addJob.jsp';</script>");
    } catch(Exception e) {
         out.println("<script>alert('Error deleting job: " + e.getMessage() + "');</script>");
    }
}


// ✅ Update Job Logic
if(request.getParameter("update") != null){
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String designation = request.getParameter("designation");
        String description = request.getParameter("description");
        String experience = request.getParameter("experience");
        float twelfth_percent = Float.parseFloat(request.getParameter("twelfth_percent"));
        float grad_percent = Float.parseFloat(request.getParameter("grad_percent"));
        int seats = Integer.parseInt(request.getParameter("seats"));

        PreparedStatement ps = con.prepareStatement(
            "UPDATE job SET designation=?, description=?, experience=?, twelfth_percent=?, grad_percent=?, seats=? WHERE id=? AND company_id=?");
        ps.setString(1, designation);
        ps.setString(2, description);
        ps.setString(3, experience);
        ps.setFloat(4, twelfth_percent);
        ps.setFloat(5, grad_percent);
        ps.setInt(6, seats);
        ps.setInt(7, id);
        ps.setInt(8, companyId); // Restrict to own jobs
        ps.executeUpdate();
        out.println("<script>alert('Job Updated Successfully!');window.location='addJob.jsp';</script>");
    } catch(NumberFormatException e) {
        out.println("<script>alert('Error: Please check all percentage and seat fields for correct numeric data.');</script>");
    } catch(SQLException e) {
        out.println("<script>alert('Database Error: Job could not be updated.');</script>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Jobs</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f4f7fc;
        margin: 0;
        padding: 0;
        color: #333;
    }

    .container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }

    h2, h3 {
        text-align: center;
        color: #007bff;
        margin-bottom: 20px;
    }

    hr {
        border: 0;
        height: 1px;
        background: #ddd;
        margin: 30px 0;
    }

    /* Form Styling */
    .job-form {
        display: flex;
        flex-direction: column;
        gap: 15px;
        margin-bottom: 30px;
    }

    .job-form input, 
    .job-form select, 
    .job-form textarea {
        padding: 12px 15px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
        width: 100%;
        transition: 0.3s;
    }

    .job-form input:focus,
    .job-form select:focus,
    .job-form textarea:focus {
        border-color: #007bff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        outline: none;
    }

    .job-form button {
        padding: 12px 25px;
        background-color: #007bff;
        color: white;
        font-size: 16px;
        font-weight: 600;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        transition: 0.3s;
    }

    .job-form button:hover {
        background-color: #0056b3;
    }

    .job-form .cancel-btn {
        display: inline-block;
        padding: 10px 20px;
        background-color: #dc3545;
        color: white;
        border-radius: 25px;
        text-decoration: none;
        font-weight: 600;
        margin-top: 10px;
        transition: 0.3s;
    }

    .job-form .cancel-btn:hover {
        background-color: #a71d2a;
    }

    /* Table Styling */
    .job-table {
        width: 100%;
        border-collapse: collapse;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
    }

    .job-table th {
        background: linear-gradient(135deg, #007bff, #00bfff);
        color: white;
        text-align: left;
        padding: 12px 15px;
        font-weight: 600;
    }

    .job-table td {
        padding: 12px 15px;
        border-bottom: 1px solid #f0f0f0;
        color: #333;
        background-color: #fff;
    }

    .job-table tr:nth-child(even) td {
        background-color: #f8faff;
    }

    .job-table tr:hover td {
        background-color: #eef5ff;
        transition: 0.3s;
    }

    .job-table a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
    }

    .job-table a:hover {
        text-decoration: underline;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .container {
            margin: 20px;
            padding: 15px;
        }
        h2, h3 {
            font-size: 22px;
        }
        .job-form input, .job-form button {
            font-size: 14px;
        }
    }
</style>

</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Manage Job Openings</h2>

    <form method="post" class="job-form">
        <h3>Add New Job</h3>
        <input type="text" name="designation" placeholder="Designation" required>
        <input type="text" name="description" placeholder="Description" required>
        <input type="text" name="experience" placeholder="Experience Required" required>
        <input type="text" name="twelfth_percent" placeholder="Min 12th %" required>
        <input type="text" name="grad_percent" placeholder="Min Graduation %" required>
        <input type="number" name="seats" placeholder="No. of Seats" required>
        <button type="submit" name="add">Add Job</button>
    </form>
    
    <hr>
    
    <%
    if(request.getParameter("editId")!=null){
        int editId = 0;
        try {
            editId = Integer.parseInt(request.getParameter("editId"));
        } catch(NumberFormatException e) {
             // Handled
        }
        
        PreparedStatement ps2 = con.prepareStatement("SELECT * FROM job WHERE id=? AND company_id=?");
        ps2.setInt(1, editId);
        ps2.setInt(2, companyId); // Restrict to own jobs
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()){
    %>
    <form method="post" class="job-form">
        <h3>Edit Job</h3>
        <input type="hidden" name="id" value="<%= rs2.getInt("id") %>">
        <input type="text" name="designation" value="<%= rs2.getString("designation") %>" required>
        <input type="text" name="description" value="<%= rs2.getString("description") %>" required>
        <input type="text" name="experience" value="<%= rs2.getString("experience") %>" required>
        <input type="text" name="twelfth_percent" value="<%= rs2.getFloat("twelfth_percent") %>" required>
        <input type="text" name="grad_percent" value="<%= rs2.getFloat("grad_percent") %>" required>
        <input type="number" name="seats" value="<%= rs2.getInt("seats") %>" required>
        <button type="submit" name="update">Update</button>
        <a href="addJob.jsp" class="cancel-btn">Cancel</a>
    </form>
    <%
        } else if (editId != 0) {
            out.println("<p style='color:red;'>Job not found or you do not have permission to edit.</p>");
        }
    }
    %>
    
    <hr>

    <h3>Your Current Openings</h3>
    
    <table border="1" class="job-table">
        <tr>
            <th>ID</th>
            <th>Designation</th>
            <th>Description</th>
            <th>Experience</th>
            <th>12th %</th>
            <th>Grad %</th>
            <th>Seats</th>
            <th>Action</th>
        </tr>
        <%
        PreparedStatement ps = con.prepareStatement("SELECT * FROM job WHERE company_id=? ORDER BY id DESC");
        ps.setInt(1, companyId);
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            int jid = rs.getInt("id");
        %>
        <tr>
            <td><%= jid %></td>
            <td><%= rs.getString("designation") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= rs.getString("experience") %></td>
            <td><%= rs.getFloat("twelfth_percent") %></td>
            <td><%= rs.getFloat("grad_percent") %></td>
            <td><%= rs.getInt("seats") %></td>
            <td>
                <a href="addJob.jsp?editId=<%= jid %>">Edit</a> |
                <a href="addJob.jsp?deleteId=<%= jid %>" onclick="return confirm('Delete this job?')">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>

</div>

</body>
</html>