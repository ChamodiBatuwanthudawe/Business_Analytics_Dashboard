<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Retrieve session data
    Integer userId = (Integer) session.getAttribute("id");
    String userImagePath = null;
    String userRole = (String) session.getAttribute("role");

    if (userId != null) {
        try (Connection connection = DBConnection.dbConn()) {
            String query = "SELECT img_path FROM users WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(query)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userImagePath = rs.getString("img_path");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    String profileImage = userImagePath != null ? "../" + userImagePath : "https://mdbcdn.b-cdn.net/img/new/avatars/2.webp";
    String homeLink = "User".equals(userRole) ? 
        request.getContextPath() + "/USER/items.jsp" : 
        request.getContextPath() + "/USER/dashboard.jsp";
%>

<!-- Modern, Beautiful Navbar -->
<nav class="navbar navbar-expand-lg shadow-sm sticky-top" style="background-color: #ffffff; padding: 10px 20px;">
    <div class="container-fluid">
        <!-- Logo section -->
        <a class="navbar-brand d-flex align-items-center" href="<%= homeLink%>">
            <img src="${pageContext.request.contextPath}/img/logo.png" height="35" alt="IMS Logo" loading="lazy" class="me-2"/>
            <span style="font-weight: 700; font-size: 1.4rem; color: #3b71ca;">IMS</span>
        </a>
        
        <!-- Mobile toggle button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" 
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Nav links -->
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 rounded-pill hover-overlay ripple" 
                       href="${pageContext.request.contextPath}/USER/issued_items.jsp"
                       style="transition: all 0.3s ease; color: #4f4f4f;">
                       <i class="fas fa-clipboard-list me-1"></i> Issued Items
                    </a>
                </li>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 rounded-pill hover-overlay ripple" 
                       href="${pageContext.request.contextPath}/USER/stock.jsp"
                       style="transition: all 0.3s ease; color: #4f4f4f;">
                       <i class="fas fa-box me-1"></i> Stock
                    </a>
                </li>

                <% if ("Admin".equals(userRole)) { %>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 rounded-pill hover-overlay ripple" 
                       href="${pageContext.request.contextPath}/USER/items.jsp"
                       style="transition: all 0.3s ease; color: #4f4f4f;">
                       <i class="fas fa-cubes me-1"></i> Available Items
                    </a>
                </li>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 rounded-pill hover-overlay ripple" 
                       href="${pageContext.request.contextPath}/InventoryController"
                       style="transition: all 0.3s ease; color: #4f4f4f;">
                       <i class="fas fa-tasks me-1"></i> Inventory Management
                    </a>
                </li>
                <li class="nav-item dropdown mx-1">
                    <a class="nav-link dropdown-toggle px-3 rounded-pill hover-overlay ripple" 
                       href="#" id="navbarDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false"
                       style="transition: all 0.3s ease; color: #4f4f4f;">
                       <i class="fas fa-users-cog me-1"></i> User Management
                    </a>
                    <ul class="dropdown-menu shadow border-0 animated fadeIn" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/signIn.jsp">
                            <i class="fas fa-user-plus me-2"></i> Add User
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/UserController">
                            <i class="fas fa-user-edit me-2"></i> Manage Users
                        </a></li>
                    </ul>
                </li>
                <% } %>
            </ul>
            
            <!-- User profile section -->
            <div class="d-flex align-items-center">
                <span class="me-3 d-none d-md-block" style="color: #4f4f4f; font-weight: 500;">
                    <%= session.getAttribute("full_name")%>
                </span>
                <div class="dropdown">
                    <a class="dropdown-toggle d-flex align-items-center hidden-arrow" 
                       href="#" id="navbarDropdownMenuAvatar" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="<%= profileImage%>" class="rounded-circle shadow-sm" 
                             height="38" width="38" alt="User Avatar" loading="lazy"
                             style="object-fit: cover; border: 2px solid #f8f9fa;"/>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 animated fadeIn" 
                        aria-labelledby="navbarDropdownMenuAvatar" 
                        style="min-width: 200px; border-radius: 10px;">
                        <li class="px-3 py-2 d-md-none text-center">
                            <span style="font-weight: 600; color: #3b71ca;"><%= session.getAttribute("full_name")%></span>
                        </li>
                        <li class="d-md-none"><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/USER/profile.jsp">
                                <i class="fas fa-id-card me-2"></i> My Profile
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item py-2 text-danger" onclick="confirmLogout()" style="cursor: pointer;">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<script>
    function confirmLogout() {
        Swal.fire({
            title: 'Are you sure?',
            text: "You will be logged out.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, logout!',
            heightAuto: false,
            backdrop: 'rgba(0,0,0,0.4)',
            customClass: {
                confirmButton: 'btn btn-primary px-4',
                cancelButton: 'btn btn-outline-danger px-4',
                popup: 'rounded-4'
            },
            buttonsStyling: false
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/Logout';
            }
        });
    }
    
    // Add active class to current page link
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.navbar .nav-link');
        
        navLinks.forEach(link => {
            if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
                link.style.backgroundColor = '#e3f2fd';
                link.style.color = '#1266f1';
                link.style.fontWeight = '600';
            }
            
            // Hover effect
            link.addEventListener('mouseenter', function() {
                if (!this.classList.contains('active')) {
                    this.style.backgroundColor = '#f8f9fa';
                }
            });
            
            link.addEventListener('mouseleave', function() {
                if (!this.classList.contains('active')) {
                    this.style.backgroundColor = '';
                }
            });
        });
    });
</script>