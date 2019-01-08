<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../tiles/header_files.jsp"></jsp:include>
</head>
<body class="hold-transition register-page">
<div class="register-box">
  <div class="register-logo">
    <a href="#"><b>Scrap</b>Management</a>
  </div>

  <div class="register-box-body">
    <p class="login-box-msg">Register a new membership</p>

    <form method="post" name="myform" id="myform" action="javascript:fnSubmit();">
      <div class="form-group has-feedback">
        <input type="text" class="form-control" name="fname" id="fname" placeholder="Fisrt Name" required="required">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="text" class="form-control" name="lname" id="lname" placeholder="Last Name" required="required">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="email" class="form-control" name="email" id="email" placeholder="Email" required="required">
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="text" class="form-control" name="mobileno" id="mobileno" placeholder="Mobile No" pattern="[0-9]{10,12}">
        <span><i class="fa fa-phone form-control-feedback"></i></span>
      </div>  
      <div class="form-group has-feedback" style="display: none;">
        <input type="hidden" class="form-control" name="imei" id="imei" placeholder="IMEI No" value="1234" >
        <span><i class="fa fa-phone form-control-feedback"></i></span>
      </div>
      <div class="form-group has-feedback">
        <input type="text" class="form-control" name="uname" id="uname" placeholder="Username" required="required">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" name="pwd" id="pwd" placeholder="Password" >
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
		<input type="password" class="form-control" name="pass" id="pass" placeholder="Retype password"> 
		<span class="glyphicon glyphicon-log-in form-control-feedback"></span>
      </div>
      <div class="row">
         <div class="col-xs-8">
          
        </div>
        <!-- /.col -->
        <div class="col-xs-4">
          <button type="submit" class="btn btn-primary btn-block btn-flat">Register</button>
        </div>
        <!-- /.col -->
      </div>
    </form>
    <a href="<%=request.getContextPath()%>/pages/login.jsp" class="text-center">I already have a membership</a>
  </div>
  <!-- /.form-box -->
</div>
<!-- /.register-box -->
	<jsp:include page="../tiles/footer_files.jsp"></jsp:include>
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
  });
  
function fnSubmit(){	
  	if($('#pwd').val()!=$('#pass').val()){
  		alert('Password and retype password do not match!');
  		return;
  	}
	var str = $("#myform" ).serialize();
//   	alert(str);
  	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=registerNewUser",
			str, function(data) {
				data = $.trim(data);
// 				alert(data);
				if (data==1) {
					window.location.href="<%=request.getContextPath()%>/pages/login.jsp";
				}else{
					alert(data);
				}
				$('#myform')[0].reset();
			});
}
</script>
</body>
</html>
