package com.helper;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

//SELECT group_concat(phone SEPARATOR ',') as phone FROM useraccount where uid in (SELECT mpauid FROM `mpa` )
public class SMSSender {
	String recipient = "";
	String message = "";

	public SMSSender(String recipient, String message) {
		this.recipient = recipient;
		this.message = message;
		if (this.message.length() > 140) {
			this.message = this.message.substring(0, 140);
		}
	}

	public static void main(String[] args) {
		String sms[] = { "9860923474" };
		for (int i = 0; i < sms.length; i++) {

			SMSSender sender = new SMSSender(
					sms[i],
					"Hello VJ MH14AGPune Has Crossed Area,Current Address-Paud Road, Bhusari Colony, Kothrud, Pune, Maharashtra 411038, India 411038");
			try {
				sender.send();
				Thread.sleep(4000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public int send() throws Exception {
		System.out.println("-----------------------------" + recipient
				+ "------------------------------------");
		System.out.println(message);
		System.out.println("-----------------------------" + recipient
				+ "------------------------------------");
		String url = SMS_URL + recipient.trim() + "&udh=&message="
				+ URLEncoder.encode(message);
		System.out.println(url);
		connect2Server(url);
		return 0;
	}

	public static String connect2Server(String url) {

		StringBuffer res = new StringBuffer();
		URL u;
		try {

			u = new URL(url);
			// System.out.println(url);
			URLConnection uc = u.openConnection();
			uc.setConnectTimeout(5000);

			InputStream scanner = uc.getInputStream();
			byte[] a = new byte[1024 * 4];
			int readBytes = 0;
			while ((readBytes = scanner.read(a)) != -1) {
				String s = new String(a);
				res.append(s.trim());
			}
			scanner.close();
			// System.out.println(" Response " + res.toString());
			u = null;
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return res.toString();

	}

	public static final String SMS_URL = "http://mobicomm.dove-sms.com/submitsms.jsp?user=Technow&key=b1ca1e9874XX&senderid=INFOSM&category=bulk&accusage=1&from=Technowings&mobile=";

}