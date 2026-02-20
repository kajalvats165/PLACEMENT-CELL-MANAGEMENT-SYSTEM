<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
if(request.getParameter("login") != null){
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    
    if(role.equals("Admin")){
        if(userid.equals("admin") && password.equals("admin123")){
            session.setAttribute("role", "Admin");
            response.sendRedirect("adminDashboard.jsp");
        } else {
            out.print("<p style='color:red; text-align:center;'>Invalid Admin Credentials</p>");
        }
    } else if(role.equals("Student")){
        PreparedStatement ps = con.prepareStatement("select * from student where email=? and password=?");
        ps.setString(1, userid);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            session.setAttribute("role", "Student");
            session.setAttribute("student_id", rs.getInt("id"));
            session.setAttribute("userid", userid);  // Add this line under Student login

            response.sendRedirect("studentDashboard.jsp");
        } else {
            out.print("<p style='color:red; text-align:center;'>Invalid Student Credentials</p>");
        }
    } else if(role.equals("Company")){
        PreparedStatement ps = con.prepareStatement("select * from company where email=? and password=?");
        ps.setString(1, userid);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            session.setAttribute("role", "Company");
            session.setAttribute("company_id", rs.getInt("id"));
            session.setAttribute("userid", userid);  // ✅ Add this line
            response.sendRedirect("companyDashboard.jsp");
        } else {
            out.print("<p style='color:red; text-align:center;'>Invalid Company Credentials</p>");
        }
    }

}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Placement Portal</title>
    
    <style>
    /* Login Page Body */
/* Login Page Body with Background Image */
body.login-body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    height: 100vh;
    margin: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    /* Background image */
    background: url('imagee.jpg') no-repeat center center fixed;
    background-size: cover;
    position: relative;
}

/* Optional overlay for readability */
body.login-body::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5); /* dark overlay */
    z-index: 1;
}

/* Login Container */
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    padding: 20px;
    position: relative;
    z-index: 2; /* above overlay */
}

/* Login Box */
.login-box {
    background-color: rgba(255, 255, 255, 0.95); /* semi-transparent white */
    padding: 40px 30px;
    border-radius: 12px;
    box-shadow: 0 15px 30px rgba(0,0,0,0.3);
    width: 100%;
    max-width: 400px;
    text-align: center;
}

/* Login Heading */
.login-box h2 {
    margin-bottom: 30px;
    color: #1a73e8;
}

/* Input Groups */
.input-group {
    margin-bottom: 20px;
}

.input-group input,
.input-group select {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ccc;
    border-radius: 8px;
    box-sizing: border-box;
    font-size: 16px;
    transition: 0.3s;
}

.input-group input:focus,
.input-group select:focus {
    border-color: #1a73e8;
    outline: none;
    box-shadow: 0 0 5px rgba(26, 115, 232, 0.5);
}

/* Login Button */
.login-btn {
    width: 100%;
    padding: 12px;
    background-color: #1a73e8;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.login-btn:hover {
    background-color: #155ab6;
}

/* Error Message */
p[style*="color:red"] {
    margin-top: 10px;
    font-weight: bold;
}

/* Responsive */
@media screen and (max-width: 480px) {
    .login-box {
        padding: 30px 20px;
    }
}

    </style>
</head>
<body class="login-body">
    <div class="login-container">
        <div class="login-box">
            <h2>Placement Portal Login</h2>
            <form method="post">
                <div class="input-group">
                    <input type="text" name="userid" placeholder="Enter Email / User ID" required>
                </div>
                <div class="input-group">
                    <input type="password" name="password" placeholder="Enter Password" required>
                </div>
                <div class="input-group">
                    <select name="role" required>
                        <option value="" disabled selected>Select Role</option>
                        <option>Admin</option>
                        <option>Student</option>
                        <option>Company</option>
                    </select>
                </div>
                <button type="submit" name="login" class="login-btn">Login</button>
            </form>
        </div>
    </div>
</body>
</html>
