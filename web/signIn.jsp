<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join IMS - User Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
            min-height: 100vh;
        }
        
        .registration-container {
            padding: 2rem 0;
        }
        
        .registration-card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border: none;
            overflow: hidden;
        }
        
        .card-body {
            padding: 2.5rem;
        }
        
        .registration-title {
            font-size: 2rem;
            font-weight: 700;
            color: #3b71ca;
            margin-bottom: 1.5rem;
            position: relative;
            display: inline-block;
        }
        
        .registration-title:after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #3b71ca, #8bb9ff);
            margin-top: 0.5rem;
            border-radius: 2px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            box-shadow: none;
            transition: all 0.3s ease;
            margin-bottom: 0.5rem;
            background-color: #f8fafc;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #3b71ca;
            box-shadow: 0 0 0 3px rgba(59, 113, 202, 0.2);
            background-color: #fff;
        }
        
        .input-group {
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #6c757d;
            z-index: 10;
            transition: all 0.3s ease;
        }
        
        .input-with-icon {
            padding-left: 45px;
        }
        
        .input-group:focus-within .input-icon {
            color: #3b71ca;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .form-text {
            color: #6c757d;
            font-size: 0.85rem;
        }
        
        .btn-register {
            background: linear-gradient(90deg, #3b71ca, #5085db);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 5px 15px rgba(59, 113, 202, 0.3);
            transition: all 0.3s ease;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 113, 202, 0.4);
            background: linear-gradient(90deg, #3466b8, #3b71ca);
        }
        
        .terms-text {
            font-size: 0.9rem;
        }
        
        .terms-text a {
            color: #3b71ca;
            text-decoration: none;
            font-weight: 600;
        }
        
        .terms-text a:hover {
            text-decoration: underline;
        }
        
        .form-check-input:checked {
            background-color: #3b71ca;
            border-color: #3b71ca;
        }
        
        .registration-image {
            padding: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8fafc;
        }
        
        .animated-image {
            max-width: 90%;
            height: auto;
            filter: drop-shadow(0 10px 15px rgba(0, 0, 0, 0.1));
            transition: all 0.5s ease;
        }
        
        .animated-image:hover {
            transform: translateY(-5px);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 14px;
            cursor: pointer;
            color: #6c757d;
            z-index: 10;
        }
        
        .password-toggle:hover {
            color: #3b71ca;
        }
        
        .login-link {
            margin-top: 1rem;
            text-align: center;
            font-size: 0.95rem;
        }
        
        .login-link a {
            color: #3b71ca;
            font-weight: 600;
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 992px) {
            .registration-image {
                display: none;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="components/navbar.jsp" />
    
    <div class="container registration-container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card registration-card">
                    <div class="row g-0">
                        <div class="col-lg-6 registration-image d-none d-lg-block">
                            <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-registration/draw1.webp" 
                                 class="animated-image img-fluid" alt="Registration illustration">
                        </div>
                        <div class="col-lg-6">
                            <div class="card-body">
                                <h2 class="registration-title text-center">Create Account</h2>
                                <p class="text-center text-muted mb-4">Join our inventory management system</p>
                                
                                <form action="SignIn" method="POST">
                                    <!-- Full Name -->
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">Full Name</label>
                                        <div class="position-relative">
                                            <i class="fas fa-user input-icon"></i>
                                            <input type="text" class="form-control input-with-icon" id="fullName" name="fullName" 
                                                   placeholder="Enter your full name" required />
                                        </div>
                                    </div>
                                    
                                    <!-- Username -->
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <div class="position-relative">
                                            <i class="fas fa-user-circle input-icon"></i>
                                            <input type="text" class="form-control input-with-icon" id="username" name="username" 
                                                   placeholder="Choose a username" required />
                                        </div>
                                        <small class="form-text">You'll use this to login to your account</small>
                                    </div>
                                    
                                    <!-- Email -->
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email Address</label>
                                        <div class="position-relative">
                                            <i class="fas fa-envelope input-icon"></i>
                                            <input type="email" class="form-control input-with-icon" id="email" name="email" 
                                                   placeholder="Enter your email address" required />
                                        </div>
                                    </div>
                                    
                                    <!-- Password -->
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Password</label>
                                        <div class="position-relative">
                                            <i class="fas fa-lock input-icon"></i>
                                            <input type="password" class="form-control input-with-icon" id="password" name="password" 
                                                   placeholder="Create a secure password" required />
                                            <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                                        </div>
                                    </div>
                                    
                                    <!-- Repeat Password -->
                                    <div class="mb-3">
                                        <label for="repeatPassword" class="form-label">Confirm Password</label>
                                        <div class="position-relative">
                                            <i class="fas fa-key input-icon"></i>
                                            <input type="password" class="form-control input-with-icon" id="repeatPassword" name="repeatPassword" 
                                                   placeholder="Confirm your password" required />
                                            <i class="fas fa-eye password-toggle" id="toggleRepeatPassword"></i>
                                        </div>
                                    </div>
                                    
                                    <!-- Department -->
                                    <div class="mb-4">
                                        <label for="department" class="form-label">Department</label>
                                        <div class="position-relative">
                                            <i class="fas fa-briefcase input-icon"></i>
                                            <select class="form-select input-with-icon" id="department" name="department" required>
                                                <option value="" selected disabled>Select your department</option>
                                                <option value="1">Human Resources</option>
                                                <option value="2">Finance</option>
                                                <option value="3">Sales</option>
                                                <option value="4">Marketing</option>
                                                <option value="5">IT Support</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <!-- Terms and Conditions -->
                                    <div class="form-check mb-4">
                                        <input class="form-check-input" type="checkbox" id="terms" name="terms" required />
                                        <label class="form-check-label terms-text" for="terms">
                                            I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms of Service</a> and <a href="#">Privacy Policy</a>
                                        </label>
                                    </div>
                                    
                                    <!-- Submit Button -->
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-register">
                                            <i class="fas fa-user-plus me-2"></i> Create Account
                                        </button>
                                    </div>
                                    
                                    <!-- Login Link -->
                                    <div class="login-link">
                                        Already have an account? <a href="login.jsp">Sign In</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Terms of Service Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="termsModalLabel">Terms of Service</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h6>1. Acceptance of Terms</h6>
                    <p>By accessing or using the Inventory Management System (IMS), you agree to be bound by these Terms of Service.</p>
                    
                    <h6>2. User Accounts</h6>
                    <p>You are responsible for maintaining the confidentiality of your account information and password.</p>
                    
                    <h6>3. Privacy Policy</h6>
                    <p>Your use of the IMS is also governed by our Privacy Policy.</p>
                    
                    <h6>4. Modifications to the Service</h6>
                    <p>We reserve the right to modify or discontinue the service at any time.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
        
        document.getElementById('toggleRepeatPassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('repeatPassword');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
        
        // Password validation
        const password = document.getElementById('password');
        const repeatPassword = document.getElementById('repeatPassword');
        
        function validatePassword() {
            if(password.value !== repeatPassword.value) {
                repeatPassword.setCustomValidity('Passwords do not match');
            } else {
                repeatPassword.setCustomValidity('');
            }
        }
        
        password.onchange = validatePassword;
        repeatPassword.onkeyup = validatePassword;
        
        // Display error message from the server (if any)
        const errorMessage = '<%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>';
        if (errorMessage) {
            Swal.fire({
                icon: "error",
                title: "Registration Failed",
                text: errorMessage,
                confirmButtonColor: '#3b71ca'
            });
        }
    </script>
</body>
</html>