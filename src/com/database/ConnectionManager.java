package com.database;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Array;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.swing.JOptionPane;
import javax.swing.plaf.basic.BasicScrollPaneUI.HSBChangeListener;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FileUtils;
import org.apache.commons.math3.analysis.function.Logistic;

import Regression.LogisticRegression;

import com.beans.CategoryModel;
import com.beans.ProductModel;
import com.beans.UserModel;
import com.constant.ServerConstants;
import com.helper.DBUtils;
import com.helper.SMSSender;
import com.helper.ScrapRequestModel;
import com.helper.StringHelper;

public class ConnectionManager {

	public static HashMap hm = null;
	public static ArrayList al = null;
	public static FileWriter writer = null;

	public static Connection getDBConnection() {
		Connection conn = null;
		try {
			Class.forName(ServerConstants.db_driver);
			conn = DriverManager.getConnection(ServerConstants.db_url,
					ServerConstants.db_user, ServerConstants.db_pwd);
			System.out.println("Got Connection" + ServerConstants.db_url);
		} catch (SQLException ex) {
			ex.printStackTrace();
			JOptionPane.showMessageDialog(
					null,
					"Please start the mysql Service from XAMPP Console.\n"
							+ ex.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		return conn;
	}

	public static UserModel checkLogin(HashMap parameters) {
		String uname = StringHelper.n2s(parameters.get("uname"));
		String pass = StringHelper.n2s(parameters.get("pass"));

		String query = "SELECT * FROM useraccounts where uname like ? and pass = ?";
		UserModel um = null;
		List list = DBUtils.getBeanList(UserModel.class, query, uname, pass);
		if (list.size() > 0) {
			um = (UserModel) list.get(0);
		}
		return um;
	}

	public static UserModel checkLoginPhone(HashMap parameters) {
		String imei = StringHelper.n2s(parameters.get("imei"));

		String query = "SELECT * FROM useraccounts where imei like ?";
		UserModel um = null;
		List list = DBUtils.getBeanList(UserModel.class, query, imei);
		if (list.size() > 0) {
			um = (UserModel) list.get(0);
		}
		return um;
	}

	public static UserModel getUser(String userid) {

		String query = "SELECT * FROM useraccounts where userid = ?";
		UserModel um = null;
		List list = DBUtils.getBeanList(UserModel.class, query, userid);
		if (list.size() > 0) {
			um = (UserModel) list.get(0);
		}
		return um;
	}

	public static String insertUser(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		final String fname = StringHelper.n2s(parameters.get("fname"));
		String lname = StringHelper.n2s(parameters.get("lname"));
		String email = StringHelper.n2s(parameters.get("email"));
		final String mobileno = StringHelper.n2s(parameters.get("mobileno"));
		final String uname = StringHelper.n2s(parameters.get("uname"));
		final 		String pass = StringHelper.n2s(parameters.get("pass"));
		String imei = StringHelper.n2s(parameters.get("imei"));

		String q = "Select 1 from useraccounts where pass like '" + pass
				+ "' AND uname like '" + uname + "' AND imei like '" + imei
				+ "'";
		boolean b = DBUtils.dataExists(q);
		if (b) {
			success = "Change Username & Password";
		} else {
			System.out.println("param = " + fname + lname + email + mobileno
					+ uname + pass + imei);
			String sql = "insert into useraccounts (fname, lname, email, mobileno, uname, pass, imei) values(?,?,?,?,?,?,?)";

			int list = DBUtils.executeUpdate(sql, fname, lname, email,
					mobileno, uname, pass, imei);
			if (list > 0) {
				success = "User registered Successfully";
				new Thread(){
					public void run() {
						String message="Hello "+fname+", Thank you for registering with us.Your User Id - "+uname+" and pwd is "+pass+" Please feel free to raise a request for scrap pickup and easy payment.";
						try {
							new SMSSender(mobileno, message).send();
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}.start();
			} else {
				success = "Error adding user to database";
			}
		}
		return success;
	}

	public static String insertcategory(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		String category = StringHelper.n2s(parameters.get("category"));

		System.out.println("param = " + category);
		String sql = "insert into categories (category) values(?)";

		int list = DBUtils.executeUpdate(sql, category);
		if (list > 0) {
			success = "1";

		} else {
			success = "0";
		}
		return success;
	}

	public static String addRequest(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		String pid = StringHelper.n2s(parameters.get("pid"));
		final String mobileno = StringHelper.n2s(parameters.get("mobileno"));
		final String name= StringHelper.n2s(parameters.get("name"));
		
		String qty = StringHelper.n2s(parameters.get("qty"));
		String total = StringHelper.n2s(parameters.get("total"));
		String userid = StringHelper.n2s(parameters.get("userid"));
		String address = StringHelper.n2s(parameters.get("address"));
		String sql = "insert into scraprequests (userid, totalAmount, scrapIds, qty, address) values(?,?,?,?,?)";

		int list = DBUtils.executeUpdate(sql, userid, total,pid,qty,address);
		
		final String r="SELECT coalesce(max(requestid),1) FROM scraprequests";
		final String  referenceNo =DBUtils.getMaxValueStr(r);
		new Thread(){
			public void run() {
				String message="Hello "+name+", Thank you for raising a pickup request "+referenceNo+". Our Serviceman will contact you for pickup and payment on successful pickup.";
				try {
					new SMSSender(mobileno, message).send();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}.start();
		return referenceNo;
	}

//	public static List getallcategory() {
//		List list = null;
//
//		String sql = "select c.category, sc.sub_category from category c , subcategory sc where c.category = sc.category";
//
//		list = DBUtils.getBeanList(CategoryModel.class, sql);
//		if (list != null) {
//
//		}
//		return list;
//	}
	public static List getallcategory() {
		List list = null;

		String sql = "select c.category, sc.sub_category from category c , subcategory sc where c.category = sc.category";

		list = DBUtils.getBeanList(CategoryModel.class, sql);
		if (list != null) {

		}
		return list;
	}

	public static List getScrapRequests(String userId,String status) {
		List list = null;
		String criteria="";
		if(userId!=null&&userId.length()>0){
			criteria="userid ="+userId;
		}
		if(status!=null&&status.length()>0){
			if(criteria.length()>0){
				criteria+=" AND ";
			}
			criteria+=" pickupstatus like '"+status+"'";
		}
		HashMap products=DBUtils.getQueryMap("SELECT spid, pname FROM `scrapproductdetails`");
		String sql = "select * from scraprequests  ";
		if(criteria.length()>0){
			sql+=" WHERE "+criteria;
		}
		sql+=" order by requestid desc";
		list = DBUtils.getBeanList(ScrapRequestModel.class, sql);
		
		for (int i = 0; list!=null&& i < list.size(); i++) {
			ScrapRequestModel model= (ScrapRequestModel) list.get(i);
			String scrapIds=model.getScrapIds();
			if(scrapIds.startsWith(","))
				scrapIds=scrapIds.substring(1);
			if(model.getQty().startsWith(","))
				model.setQty(model.getQty().substring(1));
			
			String[] tokens=scrapIds.split(",");
			String[] qty_array=model.getQty().split(",");
			String name="";
			for (int j = 0; j < tokens.length; j++) {
				if(products.get(tokens[j])!=null){
					name+=StringHelper.n2s(products.get(tokens[j]))+"-"+qty_array[j]+"<BR>";
				}
			}
			if(name.endsWith("<BR>")){
				name=name.substring(0,name.length()-4);
			}
			model.setDisplayProductIds(name);
			model.setDisplayQty(model.getQty().replace(",", "<BR>"));
		}
		return list;
	}
	public static List getcategory() {
		List list = null;

		String sql = "select * from categories";

		list = DBUtils.getBeanList(CategoryModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static List getProducts() {
		List list = null;

		String sql = "select * from scrapproductdetails";

		list = DBUtils.getBeanList(ProductModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static List getsubcategory(String category) {
		List list = null;

		String sql = "select sub_category from subcategory where category like '%"
				+ category + "%'";

		list = DBUtils.getBeanList(CategoryModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static String ADMIN_PHONE_NO="";
	static{
		ADMIN_PHONE_NO=DBUtils.getMaxValueStr("SELECT group_concat(mobileno SEPARATOR ',') FROM `useraccounts` where usertype=1");
	}
	public static void updateScrapStatus(HashMap parameters) {
		final String requestid = StringHelper.n2s(parameters.get("requestid"));
		String status= StringHelper.n2s(parameters.get("status"));
		final String paid= StringHelper.n2s(parameters.get("paid"));
		final String admin_mobileno = StringHelper.n2s(parameters.get("mobileno"));
		final String admin_name= StringHelper.n2s(parameters.get("name"));
		final String uid= StringHelper.n2s(parameters.get("uid"));
		final UserModel user=getUser(uid);	
		
		if(paid.length()>0){
			new Thread(){
				public void run() {
					// User Message
					String message="Hello "+user.getFname()+", You have been paid amount "+paid+" for scraprequest"+requestid+". Please reach us in future for any scrap requests. Thank you! ";
					try {
						new SMSSender(user.getMobileno(), message).send();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					// Admin Message
					message="Hello Admin ,Scrap has been picked up for user "+user.getFname()+" "+user.getLname()+". Amount "+paid+" has been paid for scraprequest"+requestid+".  Thank you! ";
					try {
						new SMSSender(admin_mobileno, message).send();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}.start();
			
		}
		String sql="update scraprequests set pickupstatus=?,paymentPaid=? where requestid=?";
		DBUtils.executeUpdate(sql, status,paid,requestid);
		
		
	}
	public static String insertProduct(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		String name = StringHelper.n2s(parameters.get("productname"));
		String price = StringHelper.n2s(parameters.get("price"));
		String specification = StringHelper.n2s(parameters.get("specification"));
		String cid = StringHelper.n2s(parameters.get("cid"));
		String weight = StringHelper.n2s(parameters.get("weight"));
		
		

		System.out.println("param = " + name + specification + price +  cid);
		String sql = "insert into scrapproductdetails ( pname, cid, specification, scrapprice,weight) "
				+ "values(?,?,?,?,?)";

		int list = DBUtils.executeUpdate(sql, name, cid, specification, price,weight);
		if (list > 0) {
			success =DBUtils.getMaxValueStr("SELECT max(spid) FROM `scrapproductdetails`");

		} 
		return success;
	}
	public static String getPredictedPrice(HashMap parameter){
		
		String material = StringHelper.n2s(parameter.get("category"));
		System.out.println("material = "+material);
		String sql = "select * from monthlyvalue where material like ?";
		List list = DBUtils.getMapList(sql, material);
		if (list.size()>0) {
			double[][] predictable = LogisticRegression.logisticParser(list, "price");
			String predict = LogisticRegression.logisticPredict(predictable, 1);
			return predict;
		}
		
//		System.out.println(LogisticRegression.logisticPredict(predictable, 1));
		
		return null;
	}
	private static String writeFile(BufferedImage image, String pid,String name) {
		// TODO Auto-generated method stub
		String path = "";
		 try{
			 
			 
		      File f = new File(ServerConstants.REQUESTS_DIR+ name+pid+".png");  //output file path
//		      new FileOutputStream(f).write("sadfasd".getBytes());
//		      f.createNewFile();
		      ImageIO.write(image, "png", f);
		      System.out.println("Writing complete."+f.getAbsolutePath().toString());
		      path += f.getName().toString();
		    }catch(IOException e){
		      System.out.println("Error: "+e);
		      e.printStackTrace();
		    }
		return path;
	}

	private static BufferedImage readFile(File f ,int width,int height) {
		 BufferedImage image = null;
		// TODO Auto-generated method stub
		try{
			
		      image = new BufferedImage(width, height, BufferedImage.TYPE_INT_BGR);
		      image = ImageIO.read(f);
		      System.out.println("Reading complete.");
		    }catch(IOException e){
		      System.out.println("Error: "+e);
		    }
		return image;
	}
	
	public static String uploadDocument(FileItem fi, UserModel um,
			HashMap uploadmap) {
		// docId, docName, docSize, docData, udate
		// documents
		
		try {
			File f = new File(ServerConstants.LOCAL_UPLOAD);
			if (!f.exists()) {
				f.mkdirs();
			}
			String fileName = fi.getName();
			
			
			
			fi.write(new File(ServerConstants.LOCAL_UPLOAD + "/" + fileName));
//			StringBuffer fileContent = FileHelper
//					.getFileContent(ServerConstants.LOCAL_UPLOAD + "/"
//							+ fileName);
				
				String query = "insert into books (bname, aname, price, category, type, offerprize, pdf, uid,  pdfsize, pdfname) values (?,?,?,?,?,?,?,?,?,?)";
//				executeUpdate(query, uploadmap.get("bname"),
//						uploadmap.get("aname"), uploadmap.get("price"),
//						uploadmap.get("categories"), uploadmap.get("type"),
//						uploadmap.get("price"), bytes, um.getUid(),
//						fi.getSize(), fileName);
				/*
				 * int docId=getMaxValue("Select max(docId) from documents");
				 * query =
				 * "insert into wordtf (word, count, docId) values (?,?,?)";
				 * HashMap map= FileHelper.calculateWordWiseCount(fileContent);
				 * Iterator it = map.entrySet().iterator(); while (it.hasNext())
				 * { Map.Entry pair = (Map.Entry)it.next();
				 * System.out.println(pair.getKey() + " = " + pair.getValue());
				 * executeUpdate
				 * (query,sc.encrypt(pair.getKey().toString().trim()
				 * ),pair.getValue(),docId); }
				 */
				// addToLog("User " + userId + " uploaded new file.");
				return "File Uploaded Successfully!";
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	
	public static String uploadpimg(FileItem fi, HashMap uploadmap, String name) {
		int width = 40;    //width of the image
	    int height = 40; 
	    
		String pid=DBUtils.getMaxValueStr("SELECT pid FROM productdetails where name like '"+name+"'") ;
		try {
			File f = new File(ServerConstants.LOCAL_UPLOAD);
			if (!f.exists()) {
				f.mkdirs();
			}
			String fileName = fi.getName();
			// if (um.getUserkey() != null)
			// fileName = um.getUid() + "-" + fileName;
			File filepath = new File(ServerConstants.LOCAL_UPLOAD + "/"
					+ fileName);
			fi.write(filepath);
			
			BufferedImage image = readFile(filepath, width, height);
			
			String path = writeFile(image,pid,name); 
			System.out.println("path="+path);
			byte[] a = FileUtils.readFileToByteArray(filepath);

			String query = "update productdetails set imgpath = ? where pid = ?";
			DBUtils.executeUpdate(query, path, pid);
			return "File Uploaded Successfully!";   
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	public static boolean deleteProduct(HashMap parameters) {
		System.out.println(parameters);
		boolean success = false;

		String pid = StringHelper.n2s(parameters.get("pid"));
		
		String sql = "delete from scrapproductdetails where spid = ?";
		int list = DBUtils.executeUpdate(sql, pid);
		if (list > 0) {
			success = true;
		}
		return success;
	}
	public static String editProduct(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		String pid = StringHelper.n2s(parameters.get("pid"));
		String qty = StringHelper.n2s(parameters.get("qty"));
		String price = StringHelper.n2s(parameters.get("price"));
		String gst = StringHelper.n2s(parameters.get("gst"));
		String category = StringHelper.n2s(parameters.get("cid"));
		String sub_category = StringHelper.n2s(parameters.get("sub_category"));
		String rackid = StringHelper.n2s(parameters.get("rackid"));
		String sectionid = StringHelper.n2s(parameters.get("sectionid"));
		String btid = StringHelper.n2s(parameters.get("btid"));

		System.out.println("param = " + pid + qty + price + gst + category
				+ sub_category + rackid + btid + sectionid);
		String sql = "update productdetails set qty = ?, price=?, gst=?, category=?, sub_category=?, rackid=?, btid=?, sectionid=? "
				+ "where pid = ?";

		int list = DBUtils.executeUpdate(sql, qty, price, gst, category,
				sub_category, rackid, btid, sectionid, pid);
		if (list > 0) {
			success = "1";

		} else {
			success = "0";
		}
		return success;
	}

	public static String updateProduct(String pid, String pqty) {
		String success = "";
		String sql = "select qty from productdetails where pid = " + pid;
		int qty1 = DBUtils.getMaxValue(sql);
		System.out.println("qty1=" + qty1 + " pqty=" + StringHelper.n2i(pqty));
		qty1 = qty1 - (StringHelper.n2i(pqty));
		String qty = StringHelper.n2s(qty1);
		System.out.println("param = " + pid + qty + pqty);
		sql = "update productdetails set qty = ? where pid = ?";

		int list = DBUtils.executeUpdate(sql, qty, pid);
		if (list > 0) {
			success = "1";

		} else {
			success = "0";
		}
		return success;
	}

	public static List getallproduct() {
		List list = null;

		String sql = "select * from scrapproductdetails";

		list = DBUtils.getBeanList(ProductModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static List getCatWizeProducts(String cid) {
		if(cid!=null&& cid.equalsIgnoreCase("All")){
			cid="%";
		}
		List list = null;

		String sql = "select * from scrapproductdetails where cid like '"+cid+"'";

		list = DBUtils.getBeanList(ProductModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static List getCatWizeProducts(String cid,String name) {
		if(cid!=null&& cid.equalsIgnoreCase("All")){
			cid="%";
		}
		String sql = "select * from scrapproductdetails where cid like '"+cid+"'";
		if(name!=null&&name.length()>0){
			sql+=" AND pname like '%"+name+"%' OR specification like '%"+name+"%'";
		}
		
		List list = null;

		

		list = DBUtils.getBeanList(ProductModel.class, sql);
		if (list != null) {

		}
		return list;
	}
	public static List getsectionid() {
		List list = null;

		String sql = "select distinct sectionid from coordinates order by sectionid";

		list = DBUtils.getMapList(sql);
		if (list != null) {

		}
		return list;
	}

	public static List getrackid() {
		List list = null;

		String sql = "select distinct rackid from coordinates order by rackid";

		list = DBUtils.getMapList(sql);
		if (list != null) {

		}
		return list;
	}

	public static List getproductdetails(String pid) {
		List list = null;

		String sql = "select * from productdetails where pid = ?";

		list = DBUtils.getBeanList(ProductModel.class, sql, pid);
		if (list != null) {

		}
		return list;
	}

	public static String insertList(HashMap parameters, UserModel um) {
		System.out.println(parameters);
		String success = "";

		String userid = um.getUserid();
		String listname = StringHelper.n2s(parameters.get("listname"));
		String pid = StringHelper.n2s(parameters.get("pid"));
		// String pqty = StringHelper.n2s(parameters.get("pqty"));
		String id[] = pid.split("\\,");
		System.out.println("param = " + listname + pid + userid);
		String sql = "insert into userproductlist (listname, pid, userid) values (?,?,?)";

		for (int i = 0; i < id.length; i++) {
			int list = DBUtils.executeUpdate(sql, listname, id[i], userid);
			if (list > 0) {
				// success = updateProduct(pid,pqty);
				success = "1";
			} else {
				success = "0";
			}
		}
		return success;
	}

	public static String verifyList(HashMap parameters) {
		System.out.println(parameters);
		String success = "";

		String listname = StringHelper.n2s(parameters.get("listname"));
		String userid = StringHelper.n2s(parameters.get("userid"));
		System.out.println("param = " + listname + userid);

		String sql = "update userproductlist set isverify = 1 where listname like '%"
				+ listname + "%' and userid = ?";

		int list = DBUtils.executeUpdate(sql, userid);
		if (list > 0) {
			success = "1";

		} else {
			success = "0";
		}
		return success;
	}
	
	public static String selectProduct(HashMap parameters) {
		System.out.println(parameters);
		String success = "";
		HashMap hm = null;

		String listname = StringHelper.n2s(parameters.get("listname"));
		String data = StringHelper.n2s(parameters.get("pid"));
		String[] id = data.split("\\_");
		String pid = id[1];
		System.out.println("param = " + listname + pid);

		String sql = "select pd.pid, c.x,c.y,c.w, c.h from coordinates c," +
				"(SELECT p.pid, p.sectionid, p.rackid FROM productdetails p, userproductlist upl " +
				"where upl.pid = p.pid and upl.listname like '"+listname+"' and p.pid = "+pid+") pd " +
				"where c.sectionid = pd.sectionid and c.rackid = pd.rackid";

		List list = DBUtils.getMapList(sql);
		if (list.size()>0) {
			hm = (HashMap) list.get(0);
			success = StringHelper.n2s(hm.get("x")) + ","
					+ StringHelper.n2s(hm.get("y")) + ","
					+ StringHelper.n2s(hm.get("w")) + ","
					+ StringHelper.n2s(hm.get("h"));

		} else {
			success = "0";
		}
		return success;
	}
	

	public static List getuserproductlist(String userid, String listname) {
		List list = null;

		String sql = "select upl.udate, pd.name, pd.price, pd.gst, pd.category, pd.sub_category, pd.company, pd.rackid, pd.sectionid "
				+ "from productdetails pd,userproductlist upl "
				+ "where upl.pid = pd.pid and upl.userid = ? and upl.listname like '%"
				+ listname + "%'";

		list = DBUtils.getMapList(sql, userid);
		if (list != null) {

		}
		return list;
	}

	public static List getuserproductlist() {
		List list = null;

		String sql = "select upl.userid, upl.listname, date(upl.udate) as udate, upl.isverify, u.fname, u.lname "
				+ "from useraccounts u, userproductlist upl "
				+ "where upl.userid = u.userid and upl.isverify = 0 group by upl.udate";

		list = DBUtils.getMapList(sql);
		if (list != null) {

		}
		return list;
	}

	public static List getlist(String userid) {
		List list = null;

		String sql = "select distinct listname from userproductlist where userid = ?";

		list = DBUtils.getMapList(sql, userid);
		if (list != null) {

		}
		return list;
	}

	public static void setcoordinates() {
		int section = 8, rack = 5, w = 40, h = 40, x = 150, y = 100, space = 40;
		int list = 0;
		String sql = "insert into coordinates (sectionid, rackid, x, y, w, h) values (?,?,?,?,?,?)";

		for (int i = 1; i <= section; i++) {
			y = 100;
			for (int j = 1; j <= rack; j++) {
				list = DBUtils.executeUpdate(sql, i, j, x, y, w, h);
				y += h;
			}
			if (i % 2 == 0)
				x += (w * 2);
			else
				x += w;
		}
	}

	public static String[] getcompartments(String[] pid) {
		List list = null;
		HashMap hm = null;
		String rackid = null, sectionid = null, imgpath = null;

		String sql = "select imgpath, sectionid, rackid from productdetails where pid = ?";

		String[] ids = new String[pid.length];

		for (int i = 0; i < pid.length; i++) {
			list = DBUtils.getMapList(sql, pid[i]);
			if (list != null) {
				hm = (HashMap) list.get(0);
				imgpath = StringHelper.n2s(hm.get("imgpath"));
				rackid = StringHelper.n2s(hm.get("rackid"));
				sectionid = StringHelper.n2s(hm.get("sectionid"));
				String d = imgpath + "_" + sectionid + "_" + rackid;
				System.out.println("co="+d);
				ids[i] = d;
			}
		}

		return ids;
	}

	// public static String getsectionrack(HashMap parameters) {
	// List list = null;
	// HashMap hm = null;
	//
	// String cid = StringHelper.n2s(parameters.get("cid"));
	//
	// String sql =
	// "select category from subcategory where category like '%"+cid+"%'";
	//
	// String sql =
	// "select x, y, w, h from coordinates where sectionid = ? and rackid = ?";
	//
	// for(int i=0;i<ids.length;i++){
	// pos = ids[i].split("\\_");
	// list = DBUtils.getMapList(sql, pos[0],pos[1]);
	// if (list != null) {
	// hm = (HashMap) list.get(0);
	// coord[i] = StringHelper.n2s(hm.get("x"))+","+
	// StringHelper.n2s(hm.get("y"))
	// +","+ StringHelper.n2s(hm.get("w"))+","+ StringHelper.n2s(hm.get("h"));
	// }
	// }
	//
	// return coord;
	// }

	public static String[] getcoordinates(String[] pid) {
		List list = null;
		HashMap hm = null;

		String[] ids = ConnectionManager.getcompartments(pid);

		String[] pos = new String[3];
		String[] coord = new String[ids.length];

		String sql = "select x, y, w, h from coordinates where sectionid = ? and rackid = ?";

		for (int i = 0; i < ids.length; i++) {
			pos = ids[i].split("\\_");
			list = DBUtils.getMapList(sql, pos[1], pos[2]);
			System.out.println("list.size="+list.size());
			if (list != null) {
				hm = (HashMap) list.get(0);
				coord[i] = pos[0] + "_" + StringHelper.n2s(hm.get("x")) + ","
						+ StringHelper.n2s(hm.get("y")) + ","
						+ StringHelper.n2s(hm.get("w")) + ","
						+ StringHelper.n2s(hm.get("h"));
			}
		}

		return coord;
	}

	public static String getImgCo(HashMap parameters, UserModel um) {
		List list = null;
		HashMap hm = null;
		String listname = StringHelper.n2s(parameters.get("listname"));

		String sql = "select pid from userproductlist where listname like '"
				+ listname + "'";
		list = DBUtils.getMapList(sql);
		System.out.println("getimgco list.size="+list.size());
		
		String[] pid = new String[list.size()];

		for (int i = 0; i < list.size(); i++) {
			hm = (HashMap) list.get(i);
			pid[i] = StringHelper.n2s(hm.get("pid"));
		}

		String[] arrcoord = ConnectionManager.getcoordinates(pid);
		System.out.println(arrcoord.toString());
		String coord = StringHelper.n2s(arrcoord.length);

		for (int i = 0; i < arrcoord.length; i++) {
			String[] co = arrcoord[i].split("\\_");
			coord += "_" + co[0] + "-" + co[1];
		}

		return coord;
	}
	
	public static String getBTCo(HashMap parameters) {
		List list = null;
		HashMap hm = null;
		String coord = null;
		String dname = StringHelper.n2s(parameters.get("dname"));

		String sql = "select x,y,w,h from bluetoothco where bname like '"+ dname + "'";
		list = DBUtils.getMapList(sql);
		System.out.println("getBTCo list.size="+list.size());

		for (int i = 0; i < list.size(); i++) {
			hm = (HashMap) list.get(i);
			coord = StringHelper.n2s(hm.get("x"))+","+StringHelper.n2s(hm.get("y"))
					+","+StringHelper.n2s(hm.get("w"))+","+StringHelper.n2s(hm.get("h"));
		}

		return coord;
	}
	
	public static String getListCo(HashMap parameters) {
		List list = null, list1=null;
		HashMap hm = null, hm1=null, hm2=null;
		String coord = null;
		String dname = StringHelper.n2s(parameters.get("dname"));
		String listname = StringHelper.n2s(parameters.get("listname"));
		int btX = 0, btY=0, tempX1 =0, tempY1=0, tempX2 =0, tempY2=0;

		String sql = "select x,y from bluetoothco where bname like '"+ dname + "'";
		list = DBUtils.getMapList(sql);
		System.out.println("getBTCo list.size="+list.size());
		for (int i = 0; i < list.size(); i++) {
			hm = (HashMap) list.get(i);
			System.out.println(StringHelper.n2s(hm.get("x"))+","+StringHelper.n2s(hm.get("y")));
			btX = StringHelper.n2i(hm.get("x"));
			btY = StringHelper.n2i(hm.get("y"));
		}

		String sql1 = "select a.pid, co.x, co.y, co.w, co.h from coordinates co, " +
				"(SELECT ul.pid, pd.sectionid, pd.rackid FROM userproductlist ul, productdetails pd " +
				"where ul.pid = pd.pid and listname like '"+listname+"') a " +
				"where co.sectionid = a.sectionid and co.rackid= a.rackid";
		list1 = DBUtils.getMapList(sql1);
		System.out.println("getListCo list1.size="+list1.size());

//		for (int i = 0; i < list1.size(); i++) {
//			hm1 = (HashMap) list1.get(i);
//			System.out.println(StringHelper.n2s(hm1.get("pid"))+","+StringHelper.n2s(hm1.get("x"))+","+StringHelper.n2s(hm1.get("y")));
//		}
		
		for(int i=0, j=1;i<list1.size() && j<=list1.size();i++,j++){
			hm1 = (HashMap) list1.get(i);
			hm2 = (HashMap) list1.get(j);
			tempX1 = StringHelper.n2i(hm1.get("x"));
			tempY1 = StringHelper.n2i(hm1.get("y"));
			tempX2 = StringHelper.n2i(hm2.get("x"));
			tempY2 = StringHelper.n2i(hm2.get("y"));
			if(tempX1>tempX2){
				System.out.println(StringHelper.n2s(hm1.get("pid"))+","+StringHelper.n2s(hm1.get("x"))+","+StringHelper.n2s(hm1.get("y")));
			}
		}
		
		return null;
	}

	public static String getDBCombo(String query) {

		StringBuffer success = new StringBuffer();
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDBConnection();
			rs = conn.createStatement().executeQuery(query);
			System.out.println("Executing " + query);
			while (rs.next()) {
				String key = StringHelper.n2s(rs.getString(1));
				String value = StringHelper.n2s(rs.getString(1));
				success.append("<option value=\"" + key + "\">" + value
						+ "</option>");
				// System.out.println(key+","+value);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return success.toString();
	}

	public static String getDBTable(String query) {
		int i = 1;
		StringBuffer success = new StringBuffer();
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDBConnection();
			rs = conn.createStatement().executeQuery(query);
			System.out.println("Executing " + query);
			String delete = "../theme/img/delete.png";
			
			while (rs.next()) {
				String pid = StringHelper.n2s(rs.getString(1));
				String isdone = "pid_" + pid;
				String name = StringHelper.n2s(rs.getString(2));
				String price = StringHelper.n2s(rs.getString(3));
				//String imgpath = ServerConstants.imgFolder + StringHelper.n2s(rs.getString(4));
				String imgpath = "../theme/img/"+StringHelper.n2s(rs.getString(4));
				
				success.append("<tr id=\"row" + i + "\">");
				success.append("<td style=\"display:none;\">" + pid + "</td>");				
				success.append("<td><input type=\"checkbox\" id=\"" + isdone
						+ "\" onchange=\"fnSelect(" + i + ",'" + isdone
						+ "');\" ></td>");
				success.append("<td><img src=\""+delete+"\" style=\"width:20px; height:20px;\"" +
						"onclick=\"fnDelete('" + pid + "')\"/></td>");
				success.append("<td>" + name + "</td>");
				success.append("<td>" + price + "</td>");
				success.append("<td><img src=\""+imgpath+"\" style=\"width:30px; height:30px;\"/></td>");
				success.append("</tr>");
				i++;
			}
			// upl.udate, pd.name, pd.price, pd.imgpath

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return success.toString();
	}

	public static void closeConnection(Connection conn) {
		try {
			conn.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public static void main(String[] args) {
		getDBConnection();
		// String[] pid = {"1","2"};
		// System.out.println("pid="+pid[0]);
		// String[] res = getcoordinates(pid);
		// System.out.println("res="+res[0]+"\n"+res[1]);
		// List l = getsectionid();
		// HashMap hm = (HashMap)l.get(2);
		// System.out.println(StringHelper.n2s(hm.get("sectionid")));

		//setcoordinates();
//		int width = 40;    //width of the image   
//	    int height = 40;   //height of the image
//	    BufferedImage image = null;
//	    File f = null;
//	    f = new File("D:/imgs/sugar.jpg"); //image file path
//	    image = readFile(f,width,height);	    
//	    
//	    String path = writeFile(image,"1","sugar");
//	   System.out.println("Path"+path);
		
		HashMap hm = new HashMap();
		hm.put("pid", "pid_1");
		hm.put("listname", "list3");
		System.out.println(selectProduct(hm));
		
	}

}
