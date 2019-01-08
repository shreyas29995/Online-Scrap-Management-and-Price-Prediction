<%@page import="com.beans.ProductModel"%>
<%@page import="com.beans.CategoryModel"%>
<%@page import="com.helper.StringHelper"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="com.beans.UserModel"%>
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
	if (um != null) {
%>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<jsp:include page="../tiles/header.jsp"></jsp:include>
		<jsp:include page="../tiles/left_sidebar.jsp"></jsp:include>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<section class="content-header">
			<h1>Pickup Request For Scrap</h1>
			</section>

			<%
				CategoryModel c = null;
					List list = ConnectionManager.getcategory();
			%>


			<!-- Main content -->
			<section class="content"> <!-- Small boxes (Stat box) -->
			<div class="row"></div>
			<!-- /.row --> <!-- Main row -->


			<div class="row">
				<section class="content"> <!-- Main row -->
				<div class="row">
					<!-- Left col -->
					<section class="col-lg-6 connectedSortable">
					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Select Category to Pick</h3>
						</div>
						<!-- /.box-header -->
						<!-- form start -->
						<form role="form" name="myform1" id="myform1"
							action="<%=request.getContextPath()%>/pages/viewproducts.jsp">
							<div class="box-body">
								<div class="form-group">
									<label class="text-primary">Product Category</label> <select
										class="form-control" id="category" name="category"
										required="required" onchange="javascript:fnSwitchData(this.value);">
										<option value="">Select Category</option>
										<option value="All">All</option>
										<%
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
							</div>
							<!-- 						<div class="box-footer"> -->
							<!-- 							<button type="submit" class="btn btn-primary">Select</button> -->
							<!-- 						</div> -->
						</form>
					</div>

					</section>
					<!--  Pickup Reqyest Start -->
					<section class="col-lg-6 connectedSortable">

					<div class="box box-primary">
						<div class="box-header with-border">
							<h3 class="box-title">Pick Request Details</h3>
						</div>
						 <div class="">
          <div class="box" style="width: 100%;">
    
            <div class="box-body">
              <table class="table table-bordered" id='pickUpRequest'>
                <tr>
                  <th style="width: 20px">Sr.No</th>
                  <th>Item Name</th>
                  <th  style="width: 40px">Quantity</th>
                  <th>Price</th>
                    <th style="width: 40px">Delete</th>
                </tr>    
<!--                 <tr> -->
<!--                   <td>1.</td> -->
<!--                   <td>Update software</td> -->
<!--                   <td> -->
<!--                     <div class="progress progress-xs"> -->
<!--                       <div class="progress-bar progress-bar-danger" style="width: 55%"></div> -->
<!--                     </div> -->
<!--                   </td> -->
<!--                   <td><span class="badge bg-red">55%</span></td> -->
<!--                 </tr> -->
 <tr id='totalRow'>
                  <th style="width: 20px">&nbsp;&nbsp;</th>
                  <th colspan="2" style="text-align: right;">Total Amount</th>
                  <th style="width: 40px" id="total">Price</th>
                  <th style="width: 40px">&nbsp;</th>
                </tr>

   
              </table>
              <!--  Please check sub jsp for javascript functions  -->
              <button class="btn btn-block btn-primary" type="button" data-toggle="modal" data-target="#modal-default">Raise Pickup Request</button>
               <!-- Popup start -->
                 <div class="modal fade" id="modal-default">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Pickup Address</h4>
              </div>
              <div class="modal-body">
                <p><textarea rows="3" cols="50" class="form-control" name="address" id='address'></textarea>&hellip;</p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary"  onclick="fnAddRequest();" data-dismiss="modal">Raise Request</button>
              </div>
            </div>
            <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
        </div>
        <!-- /.modal -->
        <!--  Popup End -->
            </div>
						<!-- /.box-header -->
					</div>
					<!--  Pickup Reqyest ENd--> </section>
				</div>
				</section>
			</div>
			<!-- /.row (main row) -->


			<div class="row" id='dataDiv'></div>
			</section>
		</div>
		<div></div>








		<!-- /.content-wrapper -->

		<%-- 		<jsp:include page="../tiles/footer.jsp"></jsp:include> --%>
	</div>
	<!-- ./wrapper -->

	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
</body>
<%
	} else {
%>
<jsp:include page="../pages/login.jsp"></jsp:include>
<%  
	}
%>

<script>
$(document).ready(function() {
	  // Handler for .ready() called.
	fnSwitchData();
	});
//javascript:fnSwitchData();

function fnSwitchData(pid){   
	
	$('#dataDiv').load('<%=request.getContextPath()%>/pages/viewProducts_sub.jsp?category='+pid+"&pickup=1");
	
	
}

  function fnDeleteProduct(pid){	
	  if(confirm('Are you sure you want to delete the product?')){
		$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=deleteProduct",
							'pid=' + pid, function(data) {
								data = $.trim(data);
								if (data == 'true') {
									alert('Product Deleted successfully!');
									window.location.reload();
								} else {
									alert('Error deleting the Product !');
								}
							});
		}
	}
</script>
</html>
