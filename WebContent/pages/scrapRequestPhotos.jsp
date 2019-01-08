<%@page import="com.constant.ServerConstants"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.helper.StringHelper"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%

HashMap parameters = StringHelper.displayRequest(request);
String requestId=StringHelper.n2s(parameters.get("requestId"));

File clientFilePath=new File(ServerConstants.REQUESTS_DIR+requestId);
if(clientFilePath.exists()){
File[] list=clientFilePath.listFiles();
for(int i=0;list!=null&&i<list.length;i++){
%>
<img style="margin-top: 30px;" width="80" height="80" src="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=showRequestImage&filePath=<%=list[i].getAbsolutePath()%>"/>
<%}
}else{
%>
<img style="margin-top: 30px;" width="80" height="80" src="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=showRequestImage&filePath=<%=ServerConstants.REQUESTS_DIR+"no-image.jpg"%>"/>
<%}%>