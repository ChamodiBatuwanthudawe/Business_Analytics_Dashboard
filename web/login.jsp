<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Yinka Enoch Adedokun">
    <title>Login Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden;
        }

        .main-content {
            width: 70%;
            max-width: 900px;
            border-radius: 20px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            margin: 0 auto;
            display: flex;
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.5s ease;
        }

        .main-content:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        .company__info {
            background: linear-gradient(135deg, #008080 0%, #005959 100%);
            border-top-left-radius: 20px;
            border-bottom-left-radius: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            color: #fff;
            align-items: center;
            padding: 40px 20px;
            position: relative;
            overflow: hidden;
        }

        .company__info::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 60%);
            animation: pulse 15s infinite linear;
        }

        @keyframes pulse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .company__logo {
            margin-bottom: 20px;
            position: relative;
        }

        .company__logo img {
            max-width: 80%;
            height: auto;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        .company_title {
            font-weight: 600;
            letter-spacing: 1px;
            margin-top: 15px;
            position: relative;
        }

        .company_title::after {
            content: '';
            display: block;
            width: 50px;
            height: 2px;
            background: rgba(255, 255, 255, 0.6);
            margin: 10px auto 0;
            transition: width 0.5s ease;
        }

        .company__info:hover .company_title::after {
            width: 100px;
        }

        @media screen and (max-width: 768px) {
            .main-content {
                width: 90%;
                flex-direction: column;
            }

            .company__info {
                border-top-right-radius: 20px;
                border-bottom-left-radius: 0;
                padding: 20px;
            }

            .login_form {
                border-top-right-radius: 0;
                border-bottom-left-radius: 20px;
            }
        }

        .login_form {
            background-color: #fff;
            border-top-right-radius: 20px;
            border-bottom-right-radius: 20px;
            padding: 30px 0;
            flex: 1;
        }

        .login_form_title {
            color: #008080;
            margin-bottom: 30px;
            font-weight: 600;
            position: relative;
        }

        .login_form_title::after {
            content: '';
            display: block;
            width: 30px;
            height: 3px;
            background: #008080;
            margin: 8px auto 0;
            transition: width 0.3s ease;
        }

        .login_form:hover .login_form_title::after {
            width: 60px;
        }

        form {
            padding: 0 2.5em;
        }

        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form__input {
            width: 100%;
            border: none;
            border-bottom: 1px solid #ccc;
            padding: 10px 5px 10px 35px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
            background-color: transparent;
        }

        .form__input:focus {
            border-bottom: 2px solid #008080;
        }

        .form-group i {
            position: absolute;
            left: 5px;
            top: 14px;
            color: #aaa;
            transition: all 0.3s ease;
        }

        .form__input:focus + i {
            color: #008080;
        }

        .input-animation {
            position: relative;
        }

        .input-animation::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0%;
            height: 2px;
            background-color: #008080;
            transition: all 0.3s ease;
        }

        .input-animation.active::after {
            width: 100%;
        }

        .btn-login {
            width: 60%;
            height: 45px;
            border-radius: 30px;
            color: #fff;
            font-weight: 600;
            background: linear-gradient(135deg, #008080 0%, #006666 100%);
            border: none;
            letter-spacing: 1px;
            box-shadow: 0 5px 15px rgba(0, 128, 128, 0.3);
            transition: all 0.3s ease;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.5s ease;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 128, 128, 0.4);
            background: linear-gradient(135deg, #006666 0%, #004d4d 100%);
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .center-submit-btn {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 25px;
        }

        .forgot-password {
            text-align: center;
            margin-top: 15px;
        }

        .forgot-password a {
            color: #008080;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .forgot-password a:hover {
            color: #006666;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<!-- Main Content -->
<div class="container-fluid">
    <div class="row main-content animate__animated animate__fadeIn">
        <div class="col-md-4 company__info">
            <div class="company__logo animate__animated animate__fadeInDown">
                <img src="img/login.png" alt="Company Logo" onError="this.src='https://via.placeholder.com/150?text=IMS';">
            </div>
            <h4 class="company_title animate__animated animate__fadeInUp">Inventory Management System</h4>
        </div>
        <div class="col-md-8 login_form">
            <div class="container-fluid">
                <div class="row">
                    <h2 class="text-center login_form_title animate__animated animate__fadeIn">Welcome Back</h2>
                </div>
                <div class="row animate__animated animate__fadeIn animate__delay-1s">
                    <form action="Login" method="POST" class="form-group" id="loginForm">
                        <div class="form-group input-animation">
                            <input type="text" name="username" id="username" class="form__input" placeholder="Username" required>
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="form-group input-animation">
                            <input type="password" name="password" id="password" class="form__input" placeholder="Password" required>
                            <i class="fas fa-lock"></i>
                        </div>

                        <div class="row center-submit-btn">
                            <button type="submit" class="btn-login animate">
                                <i class="fas fa-sign-in-alt mr-2"></i> Login
                            </button>
                        </div>
                    </form>
                    <div class="forgot-password animate__animated animate__fadeIn animate__delay-2s">
                        <a href="#">Forgot Password?</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Add active class to input-animation when input receives focus
document.addEventListener('DOMContentLoaded', function() {
    const inputs = document.querySelectorAll('.form__input');
    
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('active');
        });
        
        input.addEventListener('blur', function() {
            if(this.value === '') {
                this.parentElement.classList.remove('active');
            }
        });
    });

    // Form submission with animation
    const loginForm = document.getElementById('loginForm');
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        
        // Validate credentials (would normally be done server-side)
        if(username === '' || password === '') {
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: 'Please enter both username and password',
                confirmButtonColor: '#008080'
            });
            return;
        }
        
        // Show loading animation
        Swal.fire({
            title: 'Logging in...',
            html: 'Please wait',
            timerProgressBar: true,
            didOpen: () => {
                Swal.showLoading();
                // Submit the form after animation (simulate server processing)
                setTimeout(() => {
                    this.submit();
                }, 1500);
            }
        });
    });
});

// Welcome animation when page loads
window.addEventListener('load', function() {
    setTimeout(() => {
        const mainContent = document.querySelector('.main-content');
        mainContent.classList.add('animate__fadeInUp');
    }, 300);
});
</script>

</body>
</html>