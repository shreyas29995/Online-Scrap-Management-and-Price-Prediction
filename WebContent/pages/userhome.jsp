<%@page import="com.beans.ProductModel"%>
<%@page import="com.helper.StringHelper"%>
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
	UserModel um = (UserModel) session.getAttribute("USER_MODEL");
	if(um==null){
		System.out.println("userhome");
		String userid = StringHelper.n2s(request.getParameter("uid"));
		String phone = StringHelper.n2s(request.getParameter("phone"));
		um = ConnectionManager.getUser(userid);
		if(phone.equalsIgnoreCase("1") && um!=null){
			session.setAttribute("USER_MODEL", um);
		}
	}else{
		System.out.println("else userhome");	
	}
%>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
	<jsp:include page="../tiles/header.jsp"></jsp:include>
  	<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>
 
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
	<!-- Content Header (Page header) -->
    <section class="content-header">   
      <h1>Dashboard </h1>
            <!-- search form -->
			<div class="row">
				<div class="col-lg-3 col-xs-6">
					<form action="#" method="get" class="sidebar-form">
						<div class="input-group">
							<input type="text" name="q" class="form-control" style="background-color: white;"
								placeholder="Search..."> <span class="input-group-btn">
								<button type="submit" name="search" id="search-btn"
									class="btn btn-flat">
									<i class="fa fa-search"></i>
								</button>
							</span>
						</div>
					</form>
				</div>
			</div>
			<!-- /.search form -->
    </section>

    <!-- Main content -->
    <section class="content">
      <!-- Small boxes (Stat box) -->
      <div class="row">    
      </div>
      <!-- /.row -->
      <!-- Main row -->
      
      
      <%
      
      %>

        <div class="row">

<%
String cid = "%";
String q= StringHelper.n2s(request.getParameter("q"));
%>

<section class="products"> <!-- Main row -->
			<div class="row">
    <%
    List list1=ConnectionManager.getCatWizeProducts(cid,q);
		for(int i=0;i<list1.size();i++){
			ProductModel p = null;
		p = (ProductModel) list1.get(i);
    System.out.println(p.getPname());
    %>
    
    <div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-aqua">
            <div class="inner">
            
              <h3><%=p.getPname() %> </h3>
             
              <p>  Price :<%=p.getScrapprice() %></p>
            </div>
<!--             <div class="icon"> -->
<!--               <i class="fa fa-shopping-cart"></i> -->
<!--             </div> -->
                        <div class="icon">      
           
             
                 <img style="margin-top: 30px;" width="80" height="80" src="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=showProductImage&pid=<%=p.getSpid()%>"/>
             
            </div>
<%--             <a href="<%=request.getContextPath()%>/pages/viewproduct.jsp?spid=<%=p.getSpid()%>" class="small-box-footer"> --%>
<!--              	View Specification -->
              
 <!--                <i class="fa fa-arrow-circle-right"></i> -->  
<!--             </a>  -->
          </div>  
        </div>
          
    <%
		}
    
    %>
    
    
   
    
    
    
    
    </div>
    </section>

        
        
        
        
        
        
        
        
        
        
        
        
        
        
      </div>
      <!-- /.row (main row) -->

    </section>    
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  
<%-- 		<jsp:include page="../tiles/footer.jsp"></jsp:include> --%>
</div>
<!-- ./wrapper -->

	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
</body>
</html>
