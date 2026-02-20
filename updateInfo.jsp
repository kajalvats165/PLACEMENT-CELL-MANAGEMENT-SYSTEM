<%@ page import="java.sql.*, java.io.*, java.nio.file.*, jakarta.servlet.http.*, jakarta.servlet.annotation.*" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("role") == null || !session.getAttribute("role").equals("Student")) {
    response.sendRedirect("login.jsp");
    return;
}
String email = (String) session.getAttribute("userid");
%>

<!DOCTYPE html>
<html>
<head>
<title>Update Information</title>
<style>
/* Container Styling */
.container {
    max-width: 500px;
    margin: 50px auto;
    padding: 30px;
    background-color: #f8f9fc;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
}

/* Heading */
.container h2 {
    text-align: center;
    color: #007bff;
    margin-bottom: 30px;
}

/* Form Fields */
form input[type="text"], form input[type="file"] {
    width: 100%;
    padding: 12px 15px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 8px;
    box-sizing: border-box;
    font-size: 16px;
    transition: border-color 0.3s, box-shadow 0.3s;
}

form input[type="text"]:focus, form input[type="file"]:focus {
    border-color: #007bff;
    box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
    outline: none;
}

/* Submit Button */
form button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
}

form button:hover {
    background-color: #0056b3;
    transform: scale(1.05);
}

/* Responsive */
@media screen and (max-width: 600px) {
    .container {
        padding: 20px;
        margin: 30px 10px;
    }

    form input[type="text"],
    form input[type="file"],
    form button {
        font-size: 14px;
    }
}
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Update Your Information</h2>

    <%
        // Fetch existing details
        String ty="", tp="", gy="", gp="", resume="";
        try {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM student WHERE email=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ty = rs.getString("twelfth_year") == null ? "" : rs.getString("twelfth_year");
                tp = rs.getString("twelfth_percent") == null ? "" : rs.getString("twelfth_percent");
                gy = rs.getString("grad_year") == null ? "" : rs.getString("grad_year");
                gp = rs.getString("grad_percent") == null ? "" : rs.getString("grad_percent");
                resume = rs.getString("resume") == null ? "" : rs.getString("resume");
            }
            rs.close(); ps.close();
        } catch (Exception e) {
            out.println("<pre style='color:red;'>"+e+"</pre>");
        }
    %>

    <form method="post" enctype="multipart/form-data">
        <input type="text" name="twelfth_year" placeholder="12th Pass Year" value="<%=ty%>" required>
        <input type="text" name="twelfth_percent" placeholder="12th Percentage" value="<%=tp%>" required>
        <input type="text" name="grad_year" placeholder="Graduation Year" value="<%=gy%>" required>
        <input type="text" name="grad_percent" placeholder="Graduation Percentage" value="<%=gp%>" required>
        <input type="file" name="resumeFile" accept=".pdf,.doc,.docx">
        <button type="submit" name="update">Submit</button>
    </form>

    <%
    // ====================== UPDATE SECTION ======================
    if (request.getParameter("update") != null) {
        try {
            String tyNew = request.getParameter("twelfth_year");
            float tpNew = Float.parseFloat(request.getParameter("twelfth_percent"));
            String gyNew = request.getParameter("grad_year");
            float gpNew = Float.parseFloat(request.getParameter("grad_percent"));

            // ✅ Handle File Upload
            String resumeNew = resume; // Keep old resume if new not uploaded
            jakarta.servlet.http.Part filePart = request.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = application.getRealPath("/resumes/");
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();
                filePart.write(uploadDir + File.separator + fileName);
                resumeNew = "resumes/" + fileName;
            }

            PreparedStatement psUpdate = con.prepareStatement(
                "UPDATE student SET twelfth_year=?, twelfth_percent=?, grad_year=?, grad_percent=?, resume=? WHERE email=?"
            );
            psUpdate.setString(1, tyNew);
            psUpdate.setFloat(2, tpNew);
            psUpdate.setString(3, gyNew);
            psUpdate.setFloat(4, gpNew);
            psUpdate.setString(5, resumeNew);
            psUpdate.setString(6, email);

            int rows = psUpdate.executeUpdate();
            psUpdate.close();

            if (rows > 0) {
                out.println("<script>alert('✅ Information Updated Successfully!');window.location='studentDashboard.jsp';</script>");
            } else {
                out.println("<script>alert('⚠️ No record found for update!');</script>");
            }

        } catch (Exception e) {
            out.println("<pre style='color:red;'>"+e+"</pre>");
        }
    }
    %>
</div>

</body>
</html>