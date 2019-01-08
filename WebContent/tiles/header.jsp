<%@ page import="com.beans.UserModel" %>
<header class="main-header">
    <!-- Logo -->
    <a href="#" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>S</b>M</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>Scrap</b>Management</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav" >
<%
  	String name="User";
 	UserModel um = (UserModel) session.getAttribute("USER_MODEL");
	if (um != null){
		name=um.getFname();
%>        
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" style="height: 50px;">
              <img src="<%=request.getContextPath()%>/theme/dist/img/profile.jpg" class="user-image" alt="User Image">
              <span class="hidden-xs"><%=name %></span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <img src="<%=request.getContextPath()%>/theme/dist/img/profile.jpg" class="img-circle" alt="User Image">

                <p><%=um.getFname() + " " + um.getLname() %>
                  <small>Member</small>
                </p>
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left">
                  <a href="#" class="btn btn-default btn-flat">Profile</a>
                </div>
                <div class="pull-right">
                  <a href="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=logout" class="btn btn-default btn-flat">Sign out</a>
                </div>
              </li>
            </ul>
          </li>
<%
		}
%>          
        </ul>
      </div>
    </nav>
  </header>