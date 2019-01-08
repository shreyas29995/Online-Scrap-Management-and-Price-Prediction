<%@page import="com.database.ConnectionManager"%>
<%@ page import="com.beans.UserModel"%>
<!-- Left side column. contains the logo and sidebar -->
<aside class="main-sidebar">
	<!-- sidebar: style can be found in sidebar.less -->
	<section class="sidebar">
		<%
		boolean isAdmin=false;

			String name = "User";
			UserModel um = (UserModel) session.getAttribute("USER_MODEL");
			if (um != null) {
				name = um.getFname() + " " + um.getLname();
				String usertype = um.getUsertype();
				if(um.getUsertype().equalsIgnoreCase("1")){
					isAdmin=true;
				}
		%>
		<!-- Sidebar user panel -->
		<div class="user-panel">
			<div class="pull-left image">
				<img src="<%=request.getContextPath()%>/theme/dist/img/profile.jpg"
					class="img-circle" alt="User Image">
			</div>
			<div class="pull-left info">
				<p><%=name%></p>
				<a href="#"><i class="fa fa-circle text-success"></i> Online</a>
			</div>
		</div>

		<!-- sidebar menu: : style can be found in sidebar.less -->
		<ul class="sidebar-menu" data-widget="tree">
			<li class="header">MAIN NAVIGATION</li>
			<%
				if (usertype.equalsIgnoreCase("1")) {
			%>
			<li>
				<a href="<%=request.getContextPath()%>/pages/index.jsp">
					<i class="fa fa-dashboard"></i> <span>Dashboard</span>
				</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/addcategory.jsp">
					<i class="fa fa-fw  fa-server"></i> <span>Add Categories</span>
				</a>
			</li>  
			<li>
				<a href="<%=request.getContextPath()%>/pages/addproduct.jsp">
					<i class="fa fa-fw fa-plus-square"></i> <span>Add Products</span>
				</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/viewproducts.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span>View Products</span>
				</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/pickup_request.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span>Pickup Request</span>
				</a>  
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/viewPickupRequests.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span><%if(isAdmin) {%>View All Requests<%}else{ %>My Requests<%} %></span>
				</a>  
			</li>
				<li>
				<a href="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=logout">
					<i class="fa fa-fw fa-cubes"></i> <span>Logout</span>
				</a>  
			</li>
<!-- 			<li> -->
<%-- 			<a href="<%=request.getContextPath()%>/pages/maintainstock.jsp"> --%>
<!-- 					<i class="fa fa-fw fa-hourglass-o"></i> <span>Maintain Stock</span> -->
<!-- 			</a> -->
<!-- 			</li> -->
<!-- 			<li> -->
<%-- 			<a href="<%=request.getContextPath()%>/pages/map.jsp"> --%>
<!-- 					<i class="fa fa-fw fa-file-text-o"></i> <span>Map</span> -->
<!-- 			</a> -->
<!-- 			</li> -->
			
			
			<%
				} else if (usertype.equalsIgnoreCase("2")) {
			%>
			<li>
				<a href="<%=request.getContextPath()%>/pages/userhome.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span>Dashboard</span>
				</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/pickup_request.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span>Pickup Request</span>
				</a>  
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/pages/viewPickupRequests.jsp">
					<i class="fa fa-fw fa-cubes"></i> <span>My Requests</span>
				</a>  
			</li>
				<li>
				<a href="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=logout">
					<i class="fa fa-fw fa-cubes"></i> <span>Logout</span>
				</a>  
			</li>
			<%
				}
				}
			%>
		</ul>
	</section>
	<!-- /.sidebar -->
</aside>