<%@page import="com.beans.*"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../tiles/header_files.jsp"></jsp:include>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<jsp:include page="../tiles/header.jsp"></jsp:include>
		<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<section class="content-header">
			<h1>Category Details</h1>
			</section>
<%
CategoryModel c = null;
List list = ConnectionManager.getcategory(); 
%>
			<!-- Main content -->
			<section class="content"> <!-- Main row -->
			<div class="row">
				<!-- Left col -->
<!-- 				<section class="col-lg-6 connectedSortable"> -->
<!-- 					<div class="box box-primary"> -->
<!-- 					<div class="box-header with-border"> -->
<!-- 						<h3 class="box-title">Add Sub Category</h3> -->
<!-- 					</div> -->
					<!-- /.box-header -->
					<!-- form start -->
<!-- 					<form role="form" name="myform1" id="myform1" action="javascript:fnSubmit2();"> -->
<!-- 						<div class="box-body"> -->
<!-- 							<div class="form-group"> -->
<!-- 								<label class="text-primary">Product Category</label>  -->
<!-- 								<select class="form-control" id="category" name="category" required="required"> -->
<!-- 									<option></option> -->
<%
	
// 	if(list.size()>0){
// 		for(int i=0;i<list.size();i++){
// 			c = (CategoryModel) list.get(i);
%>							
<%-- 									<option value="<%=c.getCategory()%>"><%=c.getCategory()%></option> --%>
<%
// 		}
// 	}
%>								
<!-- 								</select>	 -->
<!-- 							</div> -->
							<!-- <div class="form-group">
								<label class="text-primary">Sub Category</label> 
								<input type="text" class="form-control" id="sub_category" name="sub_category"
									placeholder="Sub Category" required="required">
							</div> -->
<!-- 						</div> -->
<!-- 						/.box-body -->
<!-- 						<div class="box-footer"> -->
<!-- 							<button type="submit" class="btn btn-primary">Add</button> -->
<!-- 						</div> -->
<!-- 					</form> -->
<!-- 					form end -->
<!-- 				</div> -->
<!-- 				</section> -->
				<!-- /.Left col -->

				<!-- right col (We are only adding the ID to make the widgets sortable)-->
				<section class="col-lg-6 connectedSortable"> <!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Add Category</h3>
					</div>
					<!-- /.box-header -->
					<!-- form start -->
					<form role="form" name="myform" id="myform" action="javascript:fnSubmit();">
						<div class="box-body">
							<div class="form-group">
								<label class="text-primary">Product Category</label> 
								<input type="text" class="form-control" id="category" name="category"
									placeholder="Product Category" required="required">
							</div>
						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<button type="submit" class="btn btn-primary">Add</button>
						</div>
					</form>
					<!-- form end -->
				</div>
				<!-- /.box --> 
				</section>
				<!-- right col -->
			</div>
			<!-- /.row (main row) -->
			
			<div class="row">
				<div class="col-sm-12" style="width:100%; height:500px; overflow: auto">
              			<table id="example1" class="table table-bordered table-striped dataTable" 
              			role="grid" aria-describedby="example1_info">
		                <thead>
		                <tr role="row">
		                	<th>Sr. No.</th>
		                	<th>Category</th>
<!-- 		                	<th>Sub Category</th> -->
		                </tr>
		                </thead>
		                <tbody>
<%
	int n = 0;
// 	List list2 = ConnectionManager.getallcategory();
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			c = (CategoryModel) list.get(i);
%>
							<tr>
								<td><%= ++n %></td>
								<td><%= c.getCategory() %></td>
<%-- 								<td><%= c.getSub_category() %></td> --%>
							</tr>
<%
		}
	}
%>
		                </tbody>
		                </table>
		              </div>
		              <div>
              	</div>
			</div> 
			</section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->
<%-- 		<jsp:include page="../tiles/footer.jsp"></jsp:include> --%>
	</div>
	<!-- ./wrapper -->

	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
</body>
<script>
function fnSubmit(){	
	var str = $("#myform" ).serialize();
//   	alert(str);
  	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=addcategory",
			str, function(data) {
				data = $.trim(data);
// 				alert(data);
				if (data==1) {
					window.location.href="<%=request.getContextPath()%>/pages/addcategory.jsp";
				}else{
					alert("Something is wrong");
				}
				$('#myform')[0].reset();
			});
}

function fnSubmit2(){	
	var str = $("#myform1" ).serialize();
//   	alert(str);
  	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=addsubcategory",
			str, function(data) {
				data = $.trim(data);
// 				alert(data);
				if (data==1) {
					window.location.href="<%=request.getContextPath()%>/pages/addcategory.jsp";
				}else{
					alert("Something is wrong");
				}
				$('#myform1')[0].reset();
			});
}
</script>
</html>