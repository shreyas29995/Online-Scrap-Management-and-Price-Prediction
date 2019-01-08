<%@page import="com.beans.*"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:include page="../tiles/header_files.jsp"></jsp:include>

<style type="text/css">form img {
        height: 64px;
        order: 1;
      }
       form li, div > p {
        background: #eee;
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
        list-style-type: none;
        border: 1px solid black;
      }
       form ol {
        padding-left: 0;
      }form p {
        line-height: 32px;
        padding-left: 10px;
      }
      
</style>
</head> 
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<jsp:include page="../tiles/header.jsp"></jsp:include>
		<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<section class="content-header">
			<h1>Add New Product</h1>
			</section>

			<!-- Main content -->
			<section class="content"> <!-- Main row -->
			<div class="row">
				<!-- Left col -->
				<section class="col-lg-4 connectedSortable"> <!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">Enter Product details</h3>
					</div>
					<!-- /.box-header -->
					<!-- form start -->
					<form role="form" name="myform" id="myform" method="post" enctype="multipart/form-data" 
						action="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=addProduct">
						<div class="box-body">
							<div class="form-group">
								<label class="text-primary">Product Name</label>
								 <input type="text" class="form-control" id="productname" name="productname"
									placeholder="Product Name" required="required">
							</div>
							<div class="form-group">
								<label class="text-primary">Category</label> <select
									class="form-control" id="cid" name="cid" onchange="getcid1()"
									required="required">
									<option value="">Select Category</option>
									<%
										CategoryModel c = null;
										List list = ConnectionManager.getcategory();
										if (list.size() > 0) {
											for (int i = 0; i < list.size(); i++) {
												c = (CategoryModel) list.get(i);
									%>
									<option value="<%=c.getCid()%>"><%=c.getCategory()%></option>
									<%
										}
										}
									%>
								</select>
							</div>
							<div class="form-group">
								<label class="text-primary">Product Price</label> <input
									type="number" class="form-control" id="price" name="price"
									placeholder="Product Price" required="required">
							</div>
							<div class="form-group">
								<label class="text-primary">Specification</label> <input
									type="text" class="form-control" id="specification"
									name="specification" placeholder="Specification">
							</div>
							<div class="form-group">
								<label class="text-primary">Weight</label> <input type="text"
									class="form-control" id="weight" name="weight"
									placeholder="Specification">
							</div>
							<div>
										<label for="image_uploads">Choose Multiple images to upload
											(PNG, JPG)</label> <input type="file" id="image_uploads"
											name="image_uploads" accept=".jpg, .jpeg, .png" multiple>
									</div>
									
										
									

						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<button type="submit" class="btn btn-primary">Submit</button>
						</div>
					</form>
					
					<!-- form end -->
				</div>
				<!-- /.box --> </section>
				<!-- /.Left col -->

				<!-- right col (We are only adding the ID to make the widgets sortable)-->

				<!-- right col -->
			</div>
			<!-- /.row (main row) --> </section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->
		<%-- 		<jsp:include page="../tiles/footer.jsp"></jsp:include> --%>
	</div>
	<!-- ./wrapper -->

	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
</body>
<script>
function getcid(){
	var e = document.getElementById("cid");
	var cid = e.options[e.selectedIndex].value;
// 	alert(cid);
	$('#sub_category').load("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=getsubcategory&cid="+cid);
	
	fnsectionrack(cid);
}

function fnsectionrack(cid){
	var str = "";
	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=sectionrack&cid="+cid,
			str, function(data) {
// 				alert(data);
				if(data!=null){
					document.getElementById("sectionid").value = data.split("_")[0];
					document.getElementById("rackid").value = data.split("_")[1];			
				}
			});
}

function fnSubmit(){	
	var str = $("#myform" ).serialize();
//   	alert(str);
  	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=addproduct",
			str, function(data) {
				data = $.trim(data);
// 				alert(data);
				if (data==1) {
					window.location.href="<%=request.getContextPath()%>/pages/addproduct.jsp";
							} else {
								alert("Something is wrong");
							}
							$('#myform')[0].reset();
						});
	}


	
	
 
</script>
</html>