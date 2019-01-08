<%@page import="com.beans.PredictModel"%>
<%@page import="com.helper.DBUtils"%>
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
      <h1>Dashboard </h1>
    </section>
	
    <!-- Main content -->
    <section class="content">
      <!-- Small boxes (Stat box) -->
      <div class="col-mb-3">  
      <%

CategoryModel c = null;
List list = ConnectionManager.getcategory();
String category = StringHelper.n2s(request.getParameter("category"));
String val= StringHelper.n2s(request.getParameter("val"));

List table = null;
if(category.length()==0)
	table = DBUtils.getBeanList(PredictModel.class, "select * from monthlyvalue");
else
	table = DBUtils.getBeanList(PredictModel.class, "select * from monthlyvalue where material like '%"+category+"%'");
 
%>  
      <form role="form" name="myform1" id="myform1" action="javascript:fnSubmit();">
						<div class="box-body">
							<div class="form-group">
								<label class="text-primary">Product Category</label> 
								<select class="form-control" id="category" name="category" required="required" ">
									<option value="">Select Category</option>
										
<%
	if(list.size()>0){   
		for(int i=0;i<list.size();i++){
			c = (CategoryModel) list.get(i);
%>							
									<option value="<%=StringHelper.n2s(c.getCategory())%>"><%=c.getCategory()%></option>
<%
		}
	}
%>								  
								</select>	
								
								
							
							</div>
							 <button type="submit" class="btn btn-primary btn-block btn-flat">Show Prediction</button>
							  <div class="form-group has-feedback">
        Predicted Result :<input type="text" class="form-control" name="predict" id="predict" placeholder="Select Product to show value"  value="<%=val%>">
          
      </div>
						</div>
<!-- 						<div class="box-footer"> -->
<!-- 							<button type="submit" class="btn btn-primary">Select</button> -->
<!-- 						</div> -->
					</form>
      </div>
   
      <!-- /.row -->
      <!-- Main row -->
      <div class="row">
                  <div class="box">
            <div class="box-header">
              <h3 class="box-title">Product Prices</h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <table class="table table-condensed">
                <tr>
                  <th style="width: 10px">#</th>
                  <th>Product Name</th>
                  <th>Price</th>
                  
                </tr>
                <%if(table.size()>0){
                	for(int i=0;i<table.size();i++){
                	PredictModel pm = (PredictModel) table.get(i);
                	%>
                
                <tr>
                  <td><%=i+1 %></td>
                  <td><%=pm.getMaterial() %></td>
                  <td><%=pm.getPrice() %></td>
                  
                </tr>
               <%}} %>
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
      </div>
      <!-- /.row (main row) -->

    </section> 
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
<script type="text/javascript">


function fnSubmit(){	
	var str = $("#myform1" ).serialize();

	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=getPredicted",
			str, function(data) {
				data = $.trim(data);
				
				
					document.getElementById("predict").value= data;
					window.location.href="<%=request.getContextPath()%>/pages/index.jsp?category="+$('#category').val()+"&val="+data;
					
				
				
		});
}

</script>
</html>
