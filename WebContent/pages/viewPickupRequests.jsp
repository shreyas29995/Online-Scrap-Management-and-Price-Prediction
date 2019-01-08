<%@page import="com.helper.ScrapRequestModel"%>
<%@page import="com.beans.*"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:include page="../tiles/header_files.jsp"></jsp:include>

<style type="text/css">
form img {
	height: 64px;
	order: 1;
}

form li,div>p {
	background: #eee;
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
	list-style-type: none;
	border: 1px solid black;
}

form ol {
	padding-left: 0;
}

form p {
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
			<%
				boolean isAdmin = false;
				UserModel um = (UserModel) session.getAttribute("USER_MODEL");
				if (um != null) {
					if (um.getUsertype().equalsIgnoreCase("1")) {
						isAdmin = true;
					}
				}
			%>

			<!-- Main content -->
			<section class="content"> <!-- Main row -->
			<div class="row">
				<!-- Left col -->
				<section class="connectedSortable"> <!-- general form elements -->
				<div class="box">
					<div class="box-header with-border">
						<h3 class="box-title">View Pickup Requests</h3>
					</div>
					<!-- /.box-header -->
					<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
					<div class="box-body">
						<table class="table table-bordered">
							<tr>
								<th style="width: 10px">PickupId</th>
								<th>Items</th>

								<th>Pickup Address</th>
								<th>Status</th>
								<%
									if (isAdmin) {
								%>

								<th>MakePayment</th>
								<%
									}
								%>

								<!-- 								<th>Upload Photos</th> -->

							</tr>

							<%
								List list1 = ConnectionManager.getScrapRequests("", "");
								for (int i = 0; i < list1.size(); i++) {
									ScrapRequestModel p = null;
									p = (ScrapRequestModel) list1.get(i);
							%>
							<tr>
								<td><%=i + 1%></td>
								
								<td><h3 class="timeline-header no-border" style="text-align: left;font-size: 16px;font-weight: normal;"><%=p.getDisplayProductIds()%><BR></h3>
							
								
								<BR>
								
									<span class="badge bg-red" style="font-size: 16px;font-weight: normal;"><%=p.getTotalAmount()%></span>
									<BR>
									
								
									
									</td>  




								<td><span class="badge bg-green">&nbsp;<%=p.getAddress()%></span></td>

								<td>
									<%
										if (isAdmin) {
									%>
									<div class="form-group">
										<select class="form-control select2"
											id="status_<%=p.getRequestid()%>"
											<%if (p.getPickupstatus().equalsIgnoreCase("paid")) {%>
											disabled="disabled" <%}%> style="width: 100%;">
											<option value="raised">Scrap Request Raised</option>
											<option value="picked">Scrap-Picked</option>
											<option value="paid">Amount-Paid</option>
										</select>
									</div> <script>
					  				$('#status_<%=p.getRequestid()%> option[value=<%=p.getPickupstatus()%>]').attr('selected','selected');
					  				</script> <%
 	} else {
 %> <%=p.getPickupstatus()%> <%
 	}
 %>   
								</td>
								<%
									if (isAdmin) {
								%>
								<td>
									<div class="box-footer">
										<button type="button" class="btn btn-primary"
											<%if (p.getPickupstatus()!=null&& p.getPickupstatus().equalsIgnoreCase("paid")) {%>
											disabled="disabled" <%}%>
											onclick="updateScrapStatus(<%=p.getRequestid()%>,<%=p.getUserid()%>)">Update
											Status</button>
									</div>
								</td>
								<%
									}
								%>
								<td>
<%-- 									<span class="btn btn-block btn-default" style="width: 40%" onclick="javascript:uploadPhotos('<%=p.getRequestid()%>');" data-toggle="modal"  data-target="#modal-info">	Upload Photos</span> --%>
<!-- 									<span class="btn btn-block btn-default" style="width: 40%"  -->
<%-- 									onclick="javascript:window.JSInterface.pickImage('<%=p.getRequestid()%>')">	Upload Photos</span> --%>
										<span class="btn btn-block btn-default" style="width: 40%" 
									onclick="javascript:uploadPhotos('<%=p.getRequestid()%>')" >	Upload Photos</span>
									<jsp:include page="scrapRequestPhotos.jsp">
									<jsp:param value="<%=p.getRequestid() %>" name="requestId"/>
									</jsp:include>
								
								</td>
							</tr>
							<%
								}
							%>
						</table>
					</div>
					<!-- /.box-body -->


					<div class="modal modal-info fade" id="modal-info">
						<div class="modal-dialog">
							<div class="modal-content">
								<form role="form" name="myform" id="myform" method="post"
									enctype="multipart/form-data"
									
									action="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=uploadimg">
<!-- 									uploadimg, requestId-->
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
										<h4 class="modal-title">Upload Photo</h4>
									</div>
									<div class="modal-body">  

										<div>
											<label for="image_uploads">Choose Multiple images to
												upload (PNG, JPG)</label> <input type="file" id="uploadimg"
												name="uploadimg" accept=".jpg, .jpeg, .png" >
										</div>

<input type="hidden" id="requestId"
												name="requestId" value="1" />





									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-outline pull-left"
											data-dismiss="modal">Close</button>
										<button type="submit" class="btn btn-outline" 	>Upload Images</button>
									</div>
								</form>
							</div>
							<!-- /.modal-content -->
						</div>
						<!-- /.modal-dialog -->
					</div>
					<!-- /.modal -->

				</div>
				<!-- /.box --> <!-- /.box --> </section>
				<!-- /.Left col -->

				<!-- right col (We are only adding the ID to make the widgets sortable)-->

				<!-- right col -->
			</div>
			<!-- /.row (main row) --> </section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->
		<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
				<jsp:include page="../tiles/footer.jsp"></jsp:include>
	</div>
	<!-- ./wrapper -->  


</body>
<script>
function uploadPhotos(rid){
	
	try{
	//	$('#modal-info').modal('hide');
		alert(1+":"+rid);
		window.JSInterface.pickImage(rid);
		 
		setTimeout(function(){ window.location.reload(); }, 10000);
		
	}catch(e){		
		$('#requestId').val(rid);
		alert(2+":"+rid);
		//var modal = document.getElementById('modal-info').showModal();
// 		$('#modal-info').modal('toggle');
		$('#modal-info').modal('show');
// 		modal.style.display = "block";
// 		data-toggle="modal" data-target="#modal-info"
	}
}

function updateScrapStatus(cid,uid){
	var str = "";
	p=0;
	 if($("#status_"+cid).val()=='paid'){
		 p=prompt('Please enter the amount to be paid');
	 }
	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=updateScrapStatus&cid="+cid+"&uid="+uid,
			'status='+$("#status_"+cid).val()+"&requestid="+cid+"&paid="+p, function(data) {
 				alert('Status Updated Successfully');
				
			});
}

</script>
</html>