<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../tiles/header_files.jsp"></jsp:include>
</head>
<body class="hold-transition login-page">
<div class="login-box">
  <div class="login-logo">
    <a href="#"><b>Scrap</b>Management</a>
  </div>
  <!-- /.login-logo -->
  <div class="login-box-body">
    <p class="login-box-msg">Sign in to start your session</p>

    <form name="myform" id="myform" action="javascript:fnSubmit();">
      <div class="form-group has-feedback">
        <input type="text" class="form-control" name="uname" id="uname" placeholder="Username" value="admin" required="required">
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
        <input type="password" class="form-control" name="pass" id="pass" placeholder="Password" value="admin" required="required">
      </div>
      <div class="row">
        <div class="col-xs-8">
         
        </div>
        <!-- /.col -->
        <div class="col-xs-4">
          <button type="submit" class="btn btn-primary btn-block btn-flat">Sign In</button>
        </div>
        <!-- /.col -->
      </div>
    </form>
    <!-- /.social-auth-links -->

    <a href="<%=request.getContextPath()%>/pages/register.jsp" class="text-center">Register a new membership</a>

  </div>
  <!-- /.login-box-body -->
</div>
<!-- /.login-box -->

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
		var str = $("#myform" ).serialize();
	
		$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=checkLogin",
				str, function(data) {
					data = $.trim(data);
					if (data==1) {
						window.location.href="<%=request.getContextPath()%>/pages/index.jsp";
					}else if(data==2){
						window.location.href="<%=request.getContextPath()%>/pages/userhome.jsp";
					} 
					else {
						alert("Please Enter Valid credentials");
					}
					$('#myform')[0].reset();
			});
	}
</script>
</body>
</html>
