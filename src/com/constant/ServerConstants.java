package com.constant;

import java.io.File;
import java.io.IOException;

public class ServerConstants {
	public static final String db_driver = "com.mysql.jdbc.Driver";
	public static final String db_user = "root";
	public static final String db_pwd = "";
	public static final String db_url = "jdbc:mysql://localhost/scrapmgmt";
	public static final String PROJECT_DIR = "D:\\work\\project\\ScrapMgmtSystem\\images\\";
	public static final String PRODUCTS_DIR = PROJECT_DIR+"products\\";
	public static final String REQUESTS_DIR= PROJECT_DIR+"requests\\";
	
//	public static final String imgFolder = "D:/imgs/";

	// public static final String db_user = "project";
	// public static final String db_pwd = "project";
	// public static final String db_url =
	// "jdbc:mysql://103.10.235.64/nothingisfree";

	public static final String LOCAL_UPLOAD = "test";
	public static void takeCare(String dir){
		File f = new File(dir);
		if (!f.exists()) {
			f.mkdirs();
			System.out.println("created folder:");
		}
		try {
			System.out.println(f.getCanonicalPath());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	static {
		takeCare(PRODUCTS_DIR);
		takeCare(REQUESTS_DIR);
	}

}
