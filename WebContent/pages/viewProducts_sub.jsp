
<%@page import="com.beans.UserModel"%>
<%@page import="com.beans.ProductModel"%>
<%@page import="com.database.ConnectionManager"%>
<%@page import="java.util.List"%>
<%@page import="com.helper.StringHelper"%>
<%
boolean isAdmin=false;

String name = "User";
UserModel um = (UserModel) session.getAttribute("USER_MODEL");
if (um != null) {

	String usertype = um.getUsertype();
	if(um.getUsertype().equalsIgnoreCase("1")){
		isAdmin=true;
	}
}
String pickup=StringHelper.n2s(request.getParameter("pickup")) ;
String cid = StringHelper.n2s(request.getParameter("category")) ;
if(cid.length()>0){
%>
<script>
//$('#category').val('<%=cid%>');

document.getElementById("category").value = '<%=cid%>';
</script>

<section class="products"> <!-- Main row -->
			<div class="row">
    <%
    List list1=ConnectionManager.getCatWizeProducts(cid);
		for(int i=0;i<list1.size();i++){
			ProductModel p = null;
		p = (ProductModel) list1.get(i);
		String pname=p.getPname();   
    System.out.println(pname);
    %>
    
    <div class="col-lg-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-aqua">
            
              <div style="text-align: left;">     
              
              <%if(pickup.length()>0){ %>
      <span>       <B>Quantity :</B> <input onclick='' maxlength="3" style="width: 20%;color: black;" size="3"
       type="number" name="qty<%=p.getSpid()%>" id="qty<%=p.getSpid()%>" value="1"/>   
        <a href='javascript:fnAddProduct("<%=p.getSpid()%>","<%=pname%>",this,"<%=p.getScrapprice()%>","qty<%=p.getSpid()%>");'><i  class="fa fa-cart-plus"></i></a><BR></span>
              <%}else{ %>	
              <%if(isAdmin){ %>
           <a href='javascript:fnDeleteProduct(<%=p.getSpid() %>);'>    <i  class="glyphicon glyphicon-remove"></i></a>
           
           <%}} %>
           <BR>     	   
           </div>      
            <div class="inner">  
              <B style="font-size: 18px;"><%=p.getPname() %></B>
              <p  style="font-size: 18px;">  Price :<%=p.getScrapprice() %>&nbsp;per&nbsp;<%=p.getWeight() %></p>
            </div>   
            <div class="icon">      
           
             
                 <img style="margin-top: 30px;" width="80" height="80" src="<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=showProductImage&pid=<%=p.getSpid()%>"/>
             
            </div>
        
                 
          </div>
        </div>
        
    <%  
		}
    
    %>
    
          
   
    </div>
    </section>
    <%} %>
    
    <script>
    function fnAddRequest(){   
    	if((total__+'').length>0&& parseInt(total__)>0){
    		addr=$('#address').val();
    		if(addr.length==0){
    			alert('Please enter a pickup address !');
    			return;
    		}
    		
    	$.post("<%=request.getContextPath()%>/tiles/ajax.jsp?methodId=addRequest",
				'pid='+pids__+"&qty="+qty__+"&total="+total__+'&address='+addr, function(data) {
					data = $.trim(data);
					alert('Request Generated Successfully. Please take down the reference number. '+data);
			});  
    	}else{
    		alert('please add items to pickup request');
    		
    	}
    }
    function fnSet(pid,price,qty){
    	$("#price_"+pid).html(""+(parseInt(price)*parseInt(qty.value)));
    	fnCalculateTotal();
    }
    pids__='';
    qty__='';
    total__='';
	var pids = new Array();  
	var inputs = new Array();  
    function fnCalculateTotal(){
    
    	pids=[];
    	pids=[];
    	$("input").each(function() {
    	    var name = $(this).attr("name");
    	    var id = $(this).attr("id");
    	    var val = $(this).val();

    	    if ((name) && name.indexOf("pid_")!=-1 ) {
    			pid=name.substring(4);
    			pids.push(pid);
    		
    	        inputs.push(this);
    	    }
    	});
    	sum=0;
    	   pids__='';
    	    qty__='';
    	    total__='';
    	for(i=0;i<pids.length;i++){
    		qty1=$("#pid_"+pids[i]).val();  
    		price=$("#price_"+pids[i]).html();
			  sum+= parseInt(price);  		
			  pids__+=','+pids[i];
			  qty__+=','+qty1;
    	}
    	$('#total').html(sum+"");
    	total__=sum;
    }
    function fnAddProduct(pid,pname,qty,price,enteredQty){
    	
    	if(pids.includes(pid)){
    		alert('Product already added to your request. Please increase quantity.');
    		return ;
    	}
    	var rowCount = $('#pickUpRequest tr').length-1;
    	tr='<tr id="row'+rowCount+'">';
    	tr+='<td>'+rowCount+'</td>';
    	tr+='<td>'+pname+'</td>';  
    	tr+='<td><input type="number" onchange=fnSet("'+pid+'","'+price+'",this) name="pid_'+pid+'"  id="pid_'+pid+'" value="'+$('#qty'+pid).val()+'"/></td>';
    	tr+='<td><span id="price_'+pid+'">'+(price*parseInt($('#'+enteredQty).val()))+'</span></td>';
    	tr+='<td><a href=\'javascript:fnDeleteRow("row'+rowCount+'\")\'>Delete</a></td>';
    	tr+='</tr>';    
    //	$('#pickUpRequest').append(tr);
    $(tr).insertBefore('#totalRow');
    	//$('#pickUpRequest2').show();  
    	
    	fnCalculateTotal();
    }
    function fnDeleteRow(id){
    	$('table#pickUpRequest tr#'+id).remove();
    	fnCalculateTotal();
    }
    </script>
    
    