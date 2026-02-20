<%
String role = (String)session.getAttribute("role");
String username = (String)session.getAttribute("userid");
%>

<!-- Inline modern style for header -->
<style>
  /* ======= Header Styling ======= */
  .header-bar {
    background: linear-gradient(90deg, #1a73e8, #4dabf7);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 40px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
    position: sticky;
    top: 0;
    z-index: 1000;
  }

  .header-left h2 {
    color: #fff;
    font-size: 22px;
    letter-spacing: 1px;
    margin: 0;
  }

  .nav-links {
    display: flex;
    gap: 22px;
  }

  .nav-links .nav-item {
    color: #fff;
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    transition: all 0.3s ease;
    position: relative;
  }

  /* Hover underline effect */
  .nav-links .nav-item::after {
    content: '';
    position: absolute;
    width: 0;
    height: 2px;
    left: 0;
    bottom: -4px;
    background-color: #fff;
    transition: 0.3s;
  }

  .nav-links .nav-item:hover::after {
    width: 100%;
  }

  .nav-links .nav-item:hover {
    color: #ffe082;
  }

  .header-right {
    display: flex;
    align-items: center;
    gap: 15px;
  }

  .user-name {
    color: #fff;
    font-weight: 500;
    background: rgba(255, 255, 255, 0.2);
    padding: 6px 12px;
    border-radius: 20px;
  }

  .logout-btn {
    background: #ff5252;
    color: white;
    text-decoration: none;
    font-weight: 500;
    padding: 8px 15px;
    border-radius: 20px;
    transition: 0.3s;
  }

  .logout-btn:hover {
    background: #e53935;
    transform: scale(1.05);
  }

  /* ======= Responsive Navbar ======= */
  @media (max-width: 850px) {
    .header-bar {
      flex-direction: column;
      align-items: flex-start;
      padding: 15px 25px;
    }

    .nav-links {
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 10px;
    }

    .header-right {
      margin-top: 10px;
      width: 100%;
      justify-content: flex-end;
    }
  }
</style>

<!-- ======= Header Layout ======= -->
<header class="header-bar">
  <div class="header-left">
    <h2>Placement Cell</h2>
  </div>

  <nav class="nav-links">
    <% if("Admin".equals(role)){ %>
      <a href="adminDashboard.jsp" class="nav-item">Dashboard</a>
      <a href="students.jsp" class="nav-item">Students</a>
      <a href="companies.jsp" class="nav-item">Companies</a>
      <a href="openings.jsp" class="nav-item">Openings</a>
      <a href="adminStatusView.jsp" class="nav-item">Selected</a>
    <% } else if("Student".equals(role)){ %>
      <a href="studentDashboard.jsp" class="nav-item">Home</a>

      <a href="studentOpenings.jsp" class="nav-item">Openings</a>
      <a href="appliedJobs.jsp" class="nav-item">Applied Jobs</a>
    <% } else if("Company".equals(role)){ %>
      <a href="companyDashboard.jsp" class="nav-item">Dashboard</a>
      <a href="addJob.jsp" class="nav-item">Add Job</a>
      <a href="appliedStudents.jsp" class="nav-item">Applied Students</a>
    <% } %>
  </nav>

  <div class="header-right">
    <span class="user-name"><%= username != null ? username : "" %></span>
    <a href="logout.jsp" class="logout-btn">Logout</a>
  </div>
</header>
