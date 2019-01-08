<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="com.constant.ServerConstants"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="com.helper.HttpHelper"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.beans.UserModel"%>
<%@page import="com.helper.StringHelper"%>
<%@ page trimDirectiveWhitespaces="true"%>   
<%
	String sMethod = StringHelper.n2s(request.getParameter("methodId"));
	String returnString = "";
	System.out.println("HIIIII");   
	boolean bypasswrite = false;
	HashMap parameters = StringHelper.displayRequest(request);
	HashMap hm = null; 

	if (sMethod.equalsIgnoreCase("registerNewUser")) {
		returnString = ConnectionManager.insertUser(parameters); 
		System.out.println(returnString.length());
		if (returnString.length() == 28)
			returnString = "1";
		else
			returnString = returnString;
	} 
	else if (sMethod.equalsIgnoreCase("checkLogin")) {
		UserModel um = ConnectionManager.checkLogin(parameters);
		if (um != null) {
			session.setAttribute("USER_MODEL", um);
			String utype = um.getUsertype();
			returnString = utype;
		} else {
			returnString = "0";
		}
	}
	else if (sMethod.equalsIgnoreCase("checkLoginPhone")) 
	{     
		System.out.println("loginPhone :"+parameters);  
		UserModel um = ConnectionManager.checkLoginPhone(parameters);    
		if(um!=null){
			returnString = um.getUserid();
		}
	}
	else if (sMethod.equalsIgnoreCase("addcategory")) {
		returnString = ConnectionManager.insertcategory(parameters);
		if (returnString.equalsIgnoreCase("1")) {
			returnString = "1";
			
		} else {
			returnString = "0"; 
		}
	}
	
	else if (sMethod.equalsIgnoreCase("addRequest")) {
		UserModel um=(UserModel)session.getAttribute("USER_MODEL");
		parameters.put("userid", um.getUserid());
		parameters.put("mobileno", um.getMobileno());
		parameters.put("name", um.getFname());
		returnString = ConnectionManager.addRequest(parameters); 
	}
	else if (sMethod.equalsIgnoreCase("updateScrapStatus")) {
		UserModel um=(UserModel)session.getAttribute("USER_MODEL");
		parameters.put("userid", um.getUserid());
		parameters.put("mobileno", um.getMobileno());
		parameters.put("name", um.getFname());
		ConnectionManager.updateScrapStatus(parameters); 
	}
	else if (sMethod.equalsIgnoreCase("getsubcategory")) {
		String cid = StringHelper.n2s(request.getParameter("cid"));
		String query = "select sub_category from subcategory where category like '%"+cid+"%'";
		String subcategory = ConnectionManager.getDBCombo(query); 
		returnString =subcategory;		
	}
	else if (sMethod.equalsIgnoreCase("addProduct")) {
		HashMap uploadMap=HttpHelper.parseMultipartRequest(request); 
	String	pid = ConnectionManager.insertProduct(uploadMap); 
	String cid = StringHelper.n2s(uploadMap.get("cid"));
		String filePath=StringHelper.n2s(uploadMap.get("image_uploads"));
		File clientFilePath=new File(filePath);
		FileItem fi= (FileItem) uploadMap.get("image_uploadsITEM");
		System.out.println("File = "+fi);
		System.out.println("in uplooad file");
		System.out.println(fi.getName());
		fi.write(new File(ServerConstants.PRODUCTS_DIR+"/"+pid+".jpg"));
		System.out.println("data"+uploadMap);
		request.getRequestDispatcher("/pages/viewproducts.jsp?category="+cid).forward(request, response);
		
	}
	else if (sMethod.equalsIgnoreCase("uploadimg")) { 
		HashMap uploadMap=HttpHelper.parseMultipartRequest(request); 
		uploadMap.putAll(parameters);  
		System.out.println("in uplooad file");
		if(session.getAttribute("USER_MODEL")==null){
			 request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
		}
		UserModel um=(UserModel)session.getAttribute("USER_MODEL");
		FileItem fi= (FileItem) uploadMap.get("uploadimgITEM");
		String requestId=StringHelper.n2s(uploadMap.get("requestId"));
		String filePath=StringHelper.n2s(uploadMap.get("uploadimg"));
		File clientFilePath=new File(filePath);
		System.out.println("File = "+fi);
		System.out.println("in uplooad file");
		System.out.println(fi.getName());
		File dir=new File(ServerConstants.REQUESTS_DIR+"/"+requestId);
		dir.mkdirs();
		fi.write(new File(dir.getAbsolutePath()+"/"+clientFilePath.getName()));
		System.out.println("data"+uploadMap);
// 		System.out.println(um.getUid());
		try{
		System.out.println("file path"+dir.getAbsolutePath()+"/"+clientFilePath.getName());   
		}catch(Exception e){
			   
		}
		System.out.println("in uplooad file");
 
		
		request.getRequestDispatcher("/pages/viewPickupRequests.jsp").forward(request, response);
	}
	else if (sMethod.equalsIgnoreCase("editproduct")) {
		returnString = ConnectionManager.editProduct(parameters);  
		if (returnString.equalsIgnoreCase("1")) { 
			returnString = "1";
			
		} else {   
			returnString = "0"; 
		}
	}
// 	getPredicted
else if (sMethod.equalsIgnoreCase("getPredicted")) {
		returnString = ConnectionManager.getPredictedPrice(parameters);  
	
	}
	else if (sMethod.equalsIgnoreCase("deleteProduct")) {
		returnString = ConnectionManager.deleteProduct(parameters)+"";  
	
	}
	else if (sMethod.equalsIgnoreCase("showRequestImage")) {  
		String filePath = StringHelper.n2s(parameters.get("filePath"));
		//System.out.println(f.getAbsolutePath());
		BufferedImage bi=ImageIO.read(new File(filePath));
		ImageIO.write(bi, "jpg", response.getOutputStream());
		return;  
	   
	}
	else if (sMethod.equalsIgnoreCase("showProductImage")) {  
		String pid = StringHelper.n2s(parameters.get("pid"));
		String filePath=ServerConstants.PRODUCTS_DIR+pid+".jpg" ;
		File f=new File(filePath);
		System.out.println(f.getAbsolutePath());
		BufferedImage bi=ImageIO.read(f);
		ImageIO.write(bi, "jpg", response.getOutputStream());
		return;  
	   
	}
	else if (sMethod.equalsIgnoreCase("isverify")) {
		returnString = ConnectionManager.verifyList(parameters);   
		if (returnString.equalsIgnoreCase("1")) {
			returnString = "1";
			
		} else {
			returnString = "0"; 
		}
	}
	else if (sMethod.equalsIgnoreCase("selectProduct")) {		
		returnString = ConnectionManager.selectProduct(parameters);   
		System.out.println(returnString);
	}
	
	else if (sMethod.equalsIgnoreCase("gettbldata")) {
		UserModel um = (UserModel) session.getAttribute("USER_MODEL");
		String userid = um.getUserid();
		String listname = StringHelper.n2s(request.getParameter("listname"));
		
		String query = "select pd.pid, pd.name, pd.price, pd.imgpath from productdetails pd,userproductlist upl " +
				"where upl.pid = pd.pid and upl.userid = "+userid+" and upl.listname like '%" + listname + "%'";
		String path = null;
		
		returnString = ConnectionManager.getDBTable(query); 
	}
	else if (sMethod.equalsIgnoreCase("getImgCo")) {
		UserModel um = (UserModel) session.getAttribute("USER_MODEL");		
		returnString = ConnectionManager.getImgCo(parameters,um); 
		System.out.println(returnString);
	}
	else if (sMethod.equalsIgnoreCase("getBTCo")) {		
		returnString = ConnectionManager.getBTCo(parameters);  
		System.out.println(returnString);
	}
	else if (sMethod.equalsIgnoreCase("getListCo")) {		
		returnString = ConnectionManager.getListCo(parameters);  
		System.out.println(returnString);
	}
	else if (sMethod.equalsIgnoreCase("logout")) {
		UserModel um1 = (UserModel) session.getAttribute("USER_MODEL");    
		session.removeAttribute("USER_MODEL");
		bypasswrite = true;
%>
	<script>
		window.location.href='<%=request.getContextPath()%>/pages/login.jsp';
	</script>
<%
	}
	if (!bypasswrite) {
		out.println(returnString);
	}
%>
 