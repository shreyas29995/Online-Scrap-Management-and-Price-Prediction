package com.helper;

import java.io.InputStream;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class HttpHelper {
	public static String getURLHost(String u) {
		URL url;
		String portNo = "";
		try {
			url = new URL(u);
			portNo = url.getHost();
			System.out.println("Url host name " + portNo);
		} catch (MalformedURLException ex) {
			ex.printStackTrace();
		}
		return portNo;
	}
	public static boolean checkConnectivityServer(String ip, int port) {
		boolean success = false;
		try {
			System.out.println("Checking Connectivity With " + ip + " " + port);
			Socket soc = new Socket();
			InetSocketAddress socketAddress = new InetSocketAddress(ip, port);
			soc.connect(socketAddress, 3000);
			success = true;
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		System.out.println(" Connecting to server " + success);
		return success;
	}
	public static HashMap parseMultipartRequest(HttpServletRequest request) {
		System.out.println("Multipart Parser Start");
		HashMap param = new HashMap();
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		try {
			String s = URLDecoder.decode(request.getQueryString());
			System.out.println("URL " + s);
			String[] keyval = s.split("&");
			for (int i = 0; i < keyval.length; i++) {
				String kbv = keyval[i];
				String[] tok = kbv.split("=");
				param.put(tok[0], tok[1]);
			}
		} catch (Exception e) {
		}
		System.out.println(isMultipart);
		String inputFile = "", outputFile = "";
		if (!isMultipart) {
			System.out.println("File Not Uploaded");
		} else {
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			List items = null;
			String uid = "", desc = "";
			try {
				items = upload.parseRequest(request);
				System.out.println("Multipart items: " + items);
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
			Iterator itr = items.iterator();
			while (itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				if (item.isFormField()) {
					String name = item.getFieldName();
					String value = StringHelper.n2s(item.getString());
					param.put(name, value);
				} else {
					String itemName = item.getName();
					param.put(item.getFieldName(), item.getName());
					try {
						param.put(item.getFieldName() + "FILE",
								item.getInputStream());
						param.put(item.getFieldName() + "ITEM", item);
						param.put(item.getFieldName() + "_FILE_CTYPE",
								item.getContentType());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		System.out.println("PARAMETER HASHMAP " + param);
		return param;
	}
	public static HashMap displayRequest(HttpServletRequest request) {
		Enumeration paraNames = request.getParameterNames();
		System.out.println(" ------------------------------");
		System.out.println("parameters:");
		HashMap parameters = new HashMap();
		String pname;
		String pvalue;
		while (paraNames.hasMoreElements()) {
			pname = (String) paraNames.nextElement();
			pvalue = URLDecoder.decode(request.getParameter(pname));
			System.out.println(pname + " = " + pvalue + "");
			parameters.put(pname, pvalue);
		}
		Enumeration<String> requestAttributes = request.getAttributeNames();
		while (requestAttributes.hasMoreElements()) {
			try {
				String attributeName =StringHelper.n2s(requestAttributes.nextElement());
				String attributeValue = StringHelper.n2s(request.getAttribute(attributeName));
				parameters.put(attributeName, attributeValue);
			} catch (Exception e) {
			}
		}
		System.out.println(" ------------------------------");
		return parameters;
	}
	public static StringBuffer connect2Server(String url) {
		System.out.println(new Date());
		URL u;
		StringBuffer sb=new StringBuffer();
		try {
			
			u = new URL(url);
			URLConnection uc = u.openConnection();
			uc.setConnectTimeout(5000);
			InputStream is=uc.getInputStream();
			byte[] b = new byte[1024];
			int i=0;
			while ((i = is.read(b)) != -1) {
				String s = new String(b);
				sb.append(s.trim());
			}
			u = null;
			is.close();
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		return sb;
	}
	public static int getPortNo(String u) {
		URL url;
		int portNo = 0;
		try {
			url = new URL(u);
			portNo = url.getPort();
			System.out.println(url.getProtocol());
			if (portNo == -1) {
				if (url.getProtocol().equalsIgnoreCase("HTTP")) {
					portNo = 80;
				} else if (url.getProtocol().equalsIgnoreCase("HTTPS")) {
					portNo = 443;
				}
			}
		} catch (MalformedURLException ex) {
			ex.printStackTrace();
		}
		return portNo;
	}
}
