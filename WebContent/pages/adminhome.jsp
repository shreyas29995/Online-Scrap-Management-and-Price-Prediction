<%@page import="com.database.ConnectionManager" %>
<%@page import="com.beans.UserModel" %>
<%@page import="java.util.*"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../tiles/header_files.jsp"></jsp:include>
</head>
<%
	String name="User";
	UserModel um = (UserModel) session.getAttribute("USER_MODEL");
	String userid = um.getUserid();
	if (um != null){
%>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
	<jsp:include page="../tiles/header.jsp"></jsp:include>
  	<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>
 
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>Admin Dashboard </h1>
    </section>

    <!-- Main content -->
    <section class="content">
      <!-- Small boxes (Stat box) -->
      <div class="row">    
      </div>
      <!-- /.row -->
      <!-- Main row -->
      <div class="row">
        
      </div>
      <!-- /.row (main row) -->

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  
		<jsp:include page="../tiles/footer.jsp"></jsp:include>
  
</div>
<!-- ./wrapper -->

	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
</body>
<%
	}else{
%>
		<jsp:include page="../pages/login.jsp"></jsp:include>
<%		
	}
%>
</html>
