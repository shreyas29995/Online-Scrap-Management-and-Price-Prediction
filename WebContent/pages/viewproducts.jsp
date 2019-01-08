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
String category = StringHelper.n2s(request.getParameter("category"));
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
      	<%if(category.length()==0){ %>
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
								<select class="form-control" id="category" name="category" required="required" onblur="javascript:fnSwitchData();">
									<option value="">Select Category</option>
										<option value="All">All</option>
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
<!-- 						<div class="box-footer"> -->
<!-- 							<button type="submit" class="btn btn-primary">Select</button> -->
<!-- 						</div> -->
					</form>
				
				</div>
				</section>
				</div>
				</section>
					<%}else{ %>
					
					<%} %>
      </div>
      <!-- /.row (main row) -->


<div class="row" id='dataDiv'>

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

<script>
function fnSwitchData(){
	
	//$('#dataDiv').load('<%=request.getContextPath()%>/pages/viewProducts_sub.jsp?category='+$('#category').val());
	fnLoad($('#category').val());
	
}
function fnLoad(category){
	
	$('#dataDiv').load('<%=request.getContextPath()%>/pages/viewProducts_sub.jsp?category='+category);
	
	
}
  function fnDeleteProduct(pid){	
	  if(confirm('Are you sure you want to delete the product?')){
		$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=deleteProduct",
				'pid='+pid, function(data) {
					data = $.trim(data);
					if (data=='true') {
						alert('Product Deleted successfully!');
						window.location.reload();
					}else {
						alert('Error deleting the Product !');
					} }
					);
	  }
	}
</script>
<%if(category.length()>0){ %>
<script>
					fnLoad('<%=category%>');
					</script>
					<%} %>
					
					
</html>
