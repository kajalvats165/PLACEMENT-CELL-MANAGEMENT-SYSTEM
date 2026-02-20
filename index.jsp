<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Placement Cell Portal</title>
    <style>
        /* Reset defaults */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100%;
            font-family: 'Poppins', sans-serif;
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0, 0, 0, 0.6);
            color: #fff;
            padding: 20px 60px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 100;
        }

        .navbar h2 {
            font-size: 1.6em;
            letter-spacing: 1px;
        }

        .login-btn {
            background-color: #ffcc00;
            color: #000;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: bold;
            transition: 0.3s ease;
        }

        .login-btn:hover {
            background-color: #fff;
        }

        /* Hero Section */
        .hero {
            background-image: url('placement.png'); /* <-- Replace with your image name/path */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        /* Overlay for better text visibility */
        .hero-overlay {
            background: rgba(0, 0, 0, 0.5);
            padding: 60px;
            border-radius: 10px;
            text-align: center;
            color: white;
        }

        .hero-overlay h1 {
            font-size: 3em;
            margin-bottom: 15px;
        }

        .hero-overlay p {
            font-size: 1.2em;
            margin-bottom: 30px;
        }

        .hero-btn {
            background-color: #ffcc00;
            color: #000;
            text-decoration: none;
            padding: 12px 30px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 1.1em;
            transition: 0.3s ease;
        }

        .hero-btn:hover {
            background-color: #fff;
            color: #000;
        }
    </style>
</head>
<body>
    <div class="home-container">
        <!-- Navbar -->
        <nav class="navbar">
            <h2>Placement Cell Management System</h2>
            <a href="login.jsp" class="login-btn">Login</a>
        </nav>

        <!-- Hero Section -->
        <div class="hero">
            <div class="hero-overlay">
                <h1>Welcome to the Placement Portal</h1>
                <p>Manage Students, Companies, and Job Opportunities efficiently.</p>
                <a href="login.jsp" class="hero-btn">Get Started</a>
            </div>
        </div>
    </div>
</body>
</html>
