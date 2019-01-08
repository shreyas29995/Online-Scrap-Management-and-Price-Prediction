package com.helper;

public class ScrapRequestModel {
	String requestid="", userid="", totalAmount="", scrapIds="", qty="", address="", pickupstatus="", paymentPaid="", udate="";
	String displayProductIds="";
	String displayQty="";
	public String getRequestid() {
		return requestid;
	}



	public String getDisplayProductIds() {
		return displayProductIds;
	}



	public void setDisplayProductIds(String displayProductIds) {
		this.displayProductIds = displayProductIds;
	}



	public String getDisplayQty() {
		return displayQty;
	}



	public void setDisplayQty(String displayQty) {
		this.displayQty = displayQty;
	}



	public void setRequestid(String requestid) {
		this.requestid = requestid;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(String totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getScrapIds() {
		return scrapIds;
	}

	public void setScrapIds(String scrapIds) {
		this.scrapIds = scrapIds;
	}

	public String getQty() {
		return qty;
	}

	public void setQty(String qty) {
		this.qty = qty;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPickupstatus() {
		return pickupstatus;
	}

	public void setPickupstatus(String pickupstatus) {
		this.pickupstatus = pickupstatus;
	}

	public String getPaymentPaid() {
		return paymentPaid;
	}

	public void setPaymentPaid(String paymentPaid) {
		this.paymentPaid = paymentPaid;
	}

	public String getUdate() {
		return udate;
	}

	public void setUdate(String udate) {
		this.udate = udate;
	}
	
}
