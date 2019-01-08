<%@page import="com.beans.ProductModel"%>
<%@page import="com.beans.CategoryModel"%>
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
	if(um!=null){
		
%>	
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
	<jsp:include page="../tiles/header.jsp"></jsp:include>
  	<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>
 
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper"> 
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>List Of Products </h1>
    </section>

<%
CategoryModel c = null;
List list = ConnectionManager.getcategory(); 
%>


    <!-- Main content -->
    <section class="content">
      <!-- Small boxes (Stat box) -->
      <div class="row">    
      </div>
      <!-- /.row -->
      <!-- Main row -->
    
    
      <div class="row">
        <section class="content"> <!-- Main row -->
			<div class="row">
				<!-- Left col -->
				<section class="col-lg-6 connectedSortable">
					<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Select Category</h3>
					</div>
					<!-- /.box-header -->
					<!-- form start -->
					<form role="form" name="myform1" id="myform1" action="<%=request.getContextPath()%>/pages/viewproducts.jsp">
						<div class="box-body">
							<div class="form-group">
								<label class="text-primary">Product Category</label> 
								<select class="form-control" id="category" name="category" required="required">
									<option value="">Select Category</option>
<%
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			c = (CategoryModel) list.get(i);
%>							
									<option value="<%=c.getCid()%>"><%=c.getCategory()%></option>
<%
		}
	}
%>								
								</select>	
							</div>
						</div>
						<div class="box-footer">
							<button type="submit" class="btn btn-primary">Select</button>
						</div>
					</form>
				</div>
				</section>
				</div>
				</section>
      </div>
      <!-- /.row (main row) -->


<div class="row">

<%
String cid = request.getParameter("category");
%>

<section class="products"> <!-- Main row -->
			<div class="row">
    <%
    List list1=ConnectionManager.getCatWizeProducts(cid);
		for(int i=0;i<list1.size();i++){
			ProductModel p = null;
		p = (ProductModel) list1.get(i);
    System.out.println(p.getPname());
    %>
    
    <div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-aqua">
            <div class="inner">
              <h3><%=p.getPname() %></h3>
              <p>  Price :<%=p.getScrapprice() %></p>
            </div>
            <div class="icon">
              <i class="fa fa-shopping-cart"></i>
            </div>
            <a href="#" class="small-box-footer">
            Specification:
              <%=p.getSpecification() %>
              
<!--                <i class="fa fa-arrow-circle-right"></i> -->
            </a>
          </div>
        </div>
        
    <%
		}
    
    %>
    
    
   
    
    
    
    
    </div>
    </section>
</div>












    </section> 
    </div>
    <div>
    
     
    </div>
    
    
    
    
    
    
    
    
  <!-- /.content-wrapper -->
  
<%-- 		<jsp:include page="../tiles/footer.jsp"></jsp:include> --%>
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
