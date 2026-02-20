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
    <title>Manage Students</title>
    <style>
    /* ================= Container Styling ================= */
.container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 25px 30px;
    background-color: #f8f9fc;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* ================= Headings ================= */
.container h2, .student-form h3 {
    text-align: center;
    color: #007bff;
    margin-bottom: 25px;
}

/* ================= Form Styling ================= */
.student-form {
    background-color: #fff;
    padding: 20px 25px;
    margin: 25px 0;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0,123,255,0.1);
}

.student-form input[type="text"],
.student-form input[type="email"],
.student-form input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 15px;
    transition: border-color 0.3s, box-shadow 0.3s;
}

.student-form input:focus {
    border-color: #007bff;
    box-shadow: 0 0 8px rgba(0,123,255,0.3);
    outline: none;
}

.student-form button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background: #007bff;
    color: #fff;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
}

.student-form button:hover {
    background: #0056b3;
    transform: scale(1.03);
}

.student-form .cancel-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 10px 15px;
    color: #555;
    background: #e0e0e0;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s;
}

.student-form .cancel-btn:hover {
    background: #d0d0d0;
}

/* ================= Table Styling ================= */
.student-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    box-shadow: 0 5px 15px rgba(0,123,255,0.05);
}

.student-table th, .student-table td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #e0e0e0;
    font-size: 14px;
}

.student-table th {
    background: linear-gradient(135deg, #007bff, #00bfff);
    color: white;
    font-weight: 600;
}

.student-table tr:nth-child(even) td {
    background-color: #f4f7fc;
}

.student-table tr:hover td {
    background-color: #e6f0ff;
    transition: 0.3s;
}

.student-table a {
    color: #007bff;
    text-decoration: none;
    font-weight: 500;
    transition: color 0.3s;
}

.student-table a:hover {
    color: #0056b3;
}

/* Resume link button style */
.student-table a[target="_blank"] {
    background-color: #1a73e8;
    color: white !important;
    padding: 5px 10px;
    border-radius: 5px;
    text-decoration: none;
    font-weight: 500;
    transition: 0.3s;
}

.student-table a[target="_blank"]:hover {
    background-color: #155bb5;
}

/* ================= Responsive ================= */
@media screen and (max-width: 768px) {
    .student-table, .student-table thead, .student-table tbody, .student-table th, .student-table td, .student-table tr {
        display: block;
    }

    .student-table tr {
        margin-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }

    .student-table td {
        text-align: right;
        padding-left: 50%;
        position: relative;
    }

    .student-table td::before {
        content: attr(data-label);
        position: absolute;
        left: 15px;
        width: 45%;
        padding-left: 10px;
        font-weight: bold;
        text-align: left;
    }

    .student-form input, .student-form button {
        font-size: 14px;
    }
}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Manage Students</h2>

    <!-- ✅ Add Student Form -->
    <form method="post" class="student-form">
        <h3>Add New Student</h3>
        <input type="text" name="name" placeholder="Name" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="phone" placeholder="Phone" required>
        <input type="text" name="branch" placeholder="Branch" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="text" name="twelfth_year" placeholder="12th Year">
        <input type="text" name="twelfth_percent" placeholder="12th %">
        <input type="text" name="grad_year" placeholder="Graduation Year">
        <input type="text" name="grad_percent" placeholder="Graduation %">
        <input type="text" name="resume" placeholder="Resume URL">
        <button type="submit" name="add">Add Student</button>
    </form>

    <%
    // ✅ Add Student Logic
    if(request.getParameter("add") != null){
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String branch = request.getParameter("branch");
        String password = request.getParameter("password");
        String twelfthYear = request.getParameter("twelfth_year");
        String twelfthPercent = request.getParameter("twelfth_percent");
        String gradYear = request.getParameter("grad_year");
        String gradPercent = request.getParameter("grad_percent");
        String resume = request.getParameter("resume");

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO student(name,address,email,phone,branch,password,twelfth_year,twelfth_percent,grad_year,grad_percent,resume) VALUES(?,?,?,?,?,?,?,?,?,?,?)"
        );
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, branch);
        ps.setString(6, password);
        ps.setString(7, twelfthYear);
        ps.setString(8, twelfthPercent);
        ps.setString(9, gradYear);
        ps.setString(10, gradPercent);
        ps.setString(11, resume);
        ps.executeUpdate();
        out.println("<script>alert('Student Added Successfully!');window.location='students.jsp';</script>");
    }

    
    // ✅ Delete Student Logic (Fixed)
if(request.getParameter("deleteId") != null){
    int id = Integer.parseInt(request.getParameter("deleteId"));
    
    // Step 1: Delete related applications first (child table)
    PreparedStatement ps1 = con.prepareStatement("DELETE FROM application WHERE student_id=?");
    ps1.setInt(1, id);
    ps1.executeUpdate();

    // Step 2: Delete student (parent table)
    PreparedStatement ps2 = con.prepareStatement("DELETE FROM student WHERE id=?");
    ps2.setInt(1, id);
    ps2.executeUpdate();

    out.println("<script>alert('Student Deleted Successfully!');window.location='students.jsp';</script>");
}


    // ✅ Update Student Logic
    if(request.getParameter("update") != null){
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String branch = request.getParameter("branch");
        String password = request.getParameter("password");
        String twelfthYear = request.getParameter("twelfth_year");
        String twelfthPercent = request.getParameter("twelfth_percent");
        String gradYear = request.getParameter("grad_year");
        String gradPercent = request.getParameter("grad_percent");
        String resume = request.getParameter("resume");

        PreparedStatement ps = con.prepareStatement(
            "UPDATE student SET name=?, address=?, email=?, phone=?, branch=?, password=?, twelfth_year=?, twelfth_percent=?, grad_year=?, grad_percent=?, resume=? WHERE id=?"
        );
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, branch);
        ps.setString(6, password);
        ps.setString(7, twelfthYear);
        ps.setString(8, twelfthPercent);
        ps.setString(9, gradYear);
        ps.setString(10, gradPercent);
        ps.setString(11, resume);
        ps.setInt(12, id);
        ps.executeUpdate();
        out.println("<script>alert('Student Updated Successfully!');window.location='students.jsp';</script>");
    }
    %>

    <!-- ✅ Student List Table -->
    <table class="student-table">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Address</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Branch</th>
            <th>12th Year</th>
            <th>12th %</th>
            <th>Graduation Year</th>
            <th>Graduation %</th>
            <th>Resume</th>
            <th>Password</th>
            <th>Action</th>
        </tr>

        <%
        PreparedStatement ps = con.prepareStatement("SELECT * FROM student");
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            int sid = rs.getInt("id");
        %>
        <tr>
            <td><%= sid %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("branch") %></td>
            <td><%= rs.getString("twelfth_year") != null ? rs.getString("twelfth_year") : "-" %></td>
            <td><%= rs.getString("twelfth_percent") != null ? rs.getString("twelfth_percent") : "-" %></td>
            <td><%= rs.getString("grad_year") != null ? rs.getString("grad_year") : "-" %></td>
            <td><%= rs.getString("grad_percent") != null ? rs.getString("grad_percent") : "-" %></td>
            <td>
                <% if(rs.getString("resume")!=null && !rs.getString("resume").isEmpty()){ %>
                    <a href="<%= rs.getString("resume") %>" target="_blank">📄 View</a>
                <% } else { %>
                    -
                <% } %>
            </td>
            <td><%= rs.getString("password") %></td>
            <td>
                <a href="students.jsp?editId=<%= sid %>">Edit</a> |
                <a href="students.jsp?deleteId=<%= sid %>" onclick="return confirm('Delete this student?')">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>

    <!-- ✅ Edit Student Form -->
    <%
    if(request.getParameter("editId") != null){
        int editId = Integer.parseInt(request.getParameter("editId"));
        PreparedStatement ps2 = con.prepareStatement("SELECT * FROM student WHERE id=?");
        ps2.setInt(1, editId);
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()){
    %>
    <form method="post" class="student-form">
        <h3>Edit Student</h3>
        <input type="hidden" name="id" value="<%= rs2.getInt("id") %>">
        <input type="text" name="name" value="<%= rs2.getString("name") %>" required>
        <input type="text" name="address" value="<%= rs2.getString("address") %>" required>
        <input type="email" name="email" value="<%= rs2.getString("email") %>" required>
        <input type="text" name="phone" value="<%= rs2.getString("phone") %>" required>
        <input type="text" name="branch" value="<%= rs2.getString("branch") %>" required>
        <input type="text" name="password" value="<%= rs2.getString("password") %>" required>
        <input type="text" name="twelfth_year" value="<%= rs2.getString("twelfth_year") %>">
        <input type="text" name="twelfth_percent" value="<%= rs2.getString("twelfth_percent") %>">
        <input type="text" name="grad_year" value="<%= rs2.getString("grad_year") %>">
        <input type="text" name="grad_percent" value="<%= rs2.getString("grad_percent") %>">
        <input type="text" name="resume" value="<%= rs2.getString("resume") %>">
        <button type="submit" name="update">Update</button>
        <a href="students.jsp" class="cancel-btn">Cancel</a>
    </form>
    <% } } %>

</div>

</body>
</html> 