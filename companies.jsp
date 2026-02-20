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
    <title>Manage Companies</title>
    
    <style>
    /* ================= Container Styling ================= */
.container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 25px 30px;
    background-color: #f9fafc;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* ================= Headings ================= */
.container h2, .company-form h3 {
    text-align: center;
    color: #1a73e8;
    margin-bottom: 25px;
}

/* ================= Form Styling ================= */
.company-form {
    background-color: #fff;
    padding: 20px 25px;
    margin: 25px 0;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(26,115,232,0.1);
}

.company-form input[type="text"],
.company-form input[type="email"],
.company-form input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 15px;
    transition: border-color 0.3s, box-shadow 0.3s;
}

.company-form input:focus {
    border-color: #1a73e8;
    box-shadow: 0 0 8px rgba(26,115,232,0.3);
    outline: none;
}

.company-form button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background: #1a73e8;
    color: #fff;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
}

.company-form button:hover {
    background: #155bb5;
    transform: scale(1.03);
}

.company-form .cancel-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 10px 15px;
    color: #555;
    background: #e0e0e0;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s;
}

.company-form .cancel-btn:hover {
    background: #d0d0d0;
}

/* ================= Table Styling ================= */
.company-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    box-shadow: 0 5px 15px rgba(26,115,232,0.05);
}

.company-table th, .company-table td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #e0e0e0;
    font-size: 14px;
}

.company-table th {
    background: linear-gradient(135deg, #1a73e8, #4dabf7);
    color: white;
    font-weight: 600;
}

.company-table tr:nth-child(even) td {
    background-color: #f4f7fc;
}

.company-table tr:hover td {
    background-color: #e3f0ff;
    transition: 0.3s;
}

.company-table a {
    color: #1a73e8;
    text-decoration: none;
    font-weight: 500;
    transition: color 0.3s;
}

.company-table a:hover {
    color: #155bb5;
}

/* ================= Responsive ================= */
@media screen and (max-width: 768px) {
    .company-table, .company-table thead, .company-table tbody, .company-table th, .company-table td, .company-table tr {
        display: block;
    }

    .company-table tr {
        margin-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
    }

    .company-table td {
        text-align: right;
        padding-left: 50%;
        position: relative;
    }

    .company-table td::before {
        content: attr(data-label);
        position: absolute;
        left: 15px;
        width: 45%;
        padding-left: 10px;
        font-weight: bold;
        text-align: left;
    }

    .company-form input, .company-form button {
        font-size: 14px;
    }
}
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Manage Companies</h2>

    <!-- ✅ Add New Company Form -->
    <form method="post" class="company-form">
        <h3>Add New Company</h3>
        <input type="text" name="name" placeholder="Company Name" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="phone" placeholder="Phone" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit" name="add">Add Company</button>
    </form>

    <%
    // ✅ Add Company Logic
    if(request.getParameter("add") != null){
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO company(name, address, email, phone, password) VALUES(?,?,?,?,?)");
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, password);
        ps.executeUpdate();
        out.println("<script>alert('Company Added Successfully!');window.location='companies.jsp';</script>");
    }

    // ✅ Delete Company Logic
   // ✅ Safe Delete for Company
if(request.getParameter("deleteId") != null){
    int id = Integer.parseInt(request.getParameter("deleteId"));

    // Step 1: Delete related jobs first
    PreparedStatement ps1 = con.prepareStatement("DELETE FROM job WHERE company_id=?");
    ps1.setInt(1, id);
    ps1.executeUpdate();

    // Step 2: Now delete the company
    PreparedStatement ps2 = con.prepareStatement("DELETE FROM company WHERE id=?");
    ps2.setInt(1, id);
    ps2.executeUpdate();

    out.println("<script>alert('Company Deleted Successfully!');window.location='companies.jsp';</script>");
}


    // ✅ Update Company Logic
    if(request.getParameter("update") != null){
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        PreparedStatement ps = con.prepareStatement(
            "UPDATE company SET name=?, address=?, email=?, phone=?, password=? WHERE id=?");
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, password);
        ps.setInt(6, id);
        ps.executeUpdate();
        out.println("<script>alert('Company Updated Successfully!');window.location='companies.jsp';</script>");
    }
    %>

    <!-- ✅ Display Companies Table -->
    <table border="1" class="company-table">
        <tr>
            <th>ID</th><th>Name</th><th>Address</th><th>Email</th><th>Phone</th><th>Password</th><th>Action</th>
        </tr>
        <%
        PreparedStatement ps = con.prepareStatement("SELECT * FROM company");
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            int cid = rs.getInt("id");
        %>
        <tr>
            <td><%= cid %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("password") %></td>
            <td>
                <a href="companies.jsp?editId=<%= cid %>">Edit</a> |
                <a href="companies.jsp?deleteId=<%= cid %>" onclick="return confirm('Delete this company?')">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>

    <!-- ✅ Edit Company Form -->
    <%
    if(request.getParameter("editId") != null){
        int editId = Integer.parseInt(request.getParameter("editId"));
        PreparedStatement ps2 = con.prepareStatement("SELECT * FROM company WHERE id=?");
        ps2.setInt(1, editId);
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()){
    %>
    <form method="post" class="company-form">
        <h3>Edit Company</h3>
        <input type="hidden" name="id" value="<%= rs2.getInt("id") %>">
        <input type="text" name="name" value="<%= rs2.getString("name") %>" required>
        <input type="text" name="address" value="<%= rs2.getString("address") %>" required>
        <input type="email" name="email" value="<%= rs2.getString("email") %>" required>
        <input type="text" name="phone" value="<%= rs2.getString("phone") %>" required>
        <input type="text" name="password" value="<%= rs2.getString("password") %>" required>
        <button type="submit" name="update">Update</button>
        <a href="companies.jsp" class="cancel-btn">Cancel</a>
    </form>
    <% } } %>
</div>

</body>
</html>
