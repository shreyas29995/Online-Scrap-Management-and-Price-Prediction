package Regression;

import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.math3.stat.regression.SimpleRegression;

import com.helper.DBUtils;
import com.helper.StringHelper;

public class LogisticRegression {
	
	
	public static String logisticPredict(double[][] datavalue,int day){
		
		SimpleRegression sr = new SimpleRegression(true);
		sr.addData(datavalue);
		System.out.println("slope = " + sr.getSlope());
		System.out.println("intercept = " + sr.getIntercept());
		int predict = datavalue.length;
		System.out.println(predict);
		// trying to run model for unknown data
		System.out
				.println("prediction for 1 = " + sr.predict(predict+day));
		double result = sr.predict(predict+day);
		
		return result+"";
	}
	
	public static double[][] logisticParser(List valueList,String getval){
		
		double[][] datavalue = new double[valueList.size()][2];
		for (int i = 0; i < valueList.size(); i++) {
			HashMap par = new HashMap();
			par = (HashMap) valueList.get(i);
			datavalue[i][0] = i + 1;
			datavalue[i][1] = StringHelper.n2d(par.get(getval));
		}
		
		return datavalue;
	}
	
	public static String getNextDate(String curDate,int nextval) throws ParseException {
		final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		final Date date = format.parse(curDate);
		final Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_YEAR, nextval);
		return format.format(calendar.getTime());
	}
	
	static final String AB = "0123456789";
	static SecureRandom rnd = new SecureRandom();

	public static String randomString(int len) {
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++)
			sb.append(AB.charAt(rnd.nextInt(AB.length())));
		return (StringHelper.n2i(sb.toString())>400 || StringHelper.n2i(sb.toString())<200)?randomString(3):sb.toString();
                
	}
	public static void main(String[] args) {
		double[][] array = new double[10][2];
		double[] singele= {1,2,3,4,5,6,7,8,9,10};
		for (int i = 0; i < array.length; i++) {
			array[i][0] = i;
			array[i][1] = singele[i];
		}
		logisticPredict(array, 1);
		
	}
	
	
}
