<%@ include file="header.jsp" %>
<%
if(session.getAttribute("role")==null || !session.getAttribute("role").equals("Admin")){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
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

<h2>Welcome Admin</h2>
<div class="cards">
    <a href="students.jsp" class="card">Manage Students</a>
    <a href="companies.jsp" class="card">Manage Companies</a>
    <a href="openings.jsp" class="card">View Openings</a>
    <a href="adminStatusView.jsp" class="card">Selected Students</a>
</div>

</body>
</html>  