<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db.jsp" %>

<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Student")){
    response.sendRedirect("login.jsp");
    return;
}

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
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
}

/* Heading */
.container h2 {
    text-align: center;
    color: #007bff;
    margin-bottom: 30px;
}

/* Job Card Styling */
.job-card {
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 5px 20px rgba(0, 123, 255, 0.1);
    padding: 20px;
    margin-bottom: 25px;
    transition: transform 0.3s, box-shadow 0.3s;
}

.job-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 123, 255, 0.2);
}

/* Job Card Heading */
.job-card h3 {
    color: #007bff;
    margin-bottom: 15px;
}

/* Job Details Paragraph */
.job-card p {
    margin: 8px 0;
    color: #333;
}

/* Apply Button */
.job-card button {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: background 0.3s, transform 0.2s;
}

.job-card button:hover {
    background-color: #0056b3;
    transform: scale(1.05);
}

/* Responsive */
@media screen and (max-width: 768px) {
    .job-card {
        padding: 15px;
    }
    .job-card h3 {
        font-size: 1.1em;
    }
    .job-card button {
        width: 100%;
    }
}
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Available Job Openings</h2>

    <%
    // Fetch all job openings with company names
    PreparedStatement ps = con.prepareStatement(
        "SELECT j.*, c.name AS cname FROM job j JOIN company c ON j.company_id=c.id");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
        int jid = rs.getInt("id");
    %>
    <div class="job-card">
        <h3><%= rs.getString("designation") %> at <%= rs.getString("cname") %></h3>
        <p><b>Description:</b> <%= rs.getString("description") %></p>
        <p><b>Experience:</b> <%= rs.getString("experience") %></p>
        <p><b>Required 12th %:</b> <%= rs.getFloat("twelfth_percent") %></p>
        <p><b>Required Grad %:</b> <%= rs.getFloat("grad_percent") %></p>
        <p><b>Seats:</b> <%= rs.getInt("seats") %></p>
        <form method="post">
            <input type="hidden" name="job_id" value="<%= jid %>">
            <button type="submit" name="apply">Apply</button>
        </form>
    </div>
    <% } %>

    <%
    if(request.getParameter("apply") != null){
        int job_id = Integer.parseInt(request.getParameter("job_id"));

        PreparedStatement pscheck = con.prepareStatement(
            "SELECT * FROM application WHERE student_id=? AND job_id=?");
        pscheck.setInt(1, sid);
        pscheck.setInt(2, job_id);
        ResultSet rscheck = pscheck.executeQuery();

        if(rscheck.next()){
            out.println("<script>alert('Already Applied!');</script>");
        } else {
            PreparedStatement psapply = con.prepareStatement(
                "INSERT INTO application(student_id, job_id, date_of_apply, status) VALUES(?,?,CURDATE(),'Applied')");
            psapply.setInt(1, sid);
            psapply.setInt(2, job_id);
            psapply.executeUpdate();
            out.println("<script>alert('Application Submitted!');window.location='appliedJobs.jsp';</script>");
        }
    }
    %>
</div>

</body>
</html>
