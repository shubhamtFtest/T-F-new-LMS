/*
* Test Class: zTEST_TF_OrderTaxCalculation_Handler
* Description :  Tax calculation on Order by calling SAP API
* Created by Piyush Jain
*/
public with sharing class TF_OrderTaxCalculation_Handler {
    private static boolean taxCalculated = false;
    private static boolean run = true;
    public static string errorHttpResponseTax;
    public static string errorMessageTax;
    public class orderTaxCalculation_Response {
        public Metadata metadata;
        public Data data;
    }
    
    public class orderTaxCalculation_Error_Response {
        public Metadata metadata;
    }
    
    public class Metadata {
        public Integer code;
        public String timestamp;
        public String details;
    }
    
    public class Items {
        public String offerCode;
        public Integer quantity;
        public Object priceCode;
        public String productId;
        public Double price;
        public Double tax;
        public List<Double> taxRates;
    }
    
    public class Data {
        public String productType;
        public List<Items> items;
    }
    
    public static boolean runOnce1(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public class orderWrapperClass{
        @AuraEnabled
        public List<Order> updateOrderList = new List<Order>();
        @AuraEnabled
        public List<OrderItem> orderItemUpdateList = new List<OrderItem>();
    }   
    
    //Called from sap bp creation handler
    public static List<OrderItem> orderItemUpdateList = new List<OrderItem>();
    public static List<SAP_BP__c> updateSapBpList  = new List<SAP_BP__c>();
    
    /**
* directOrderCallout description : We have to do callout in trigger that's why we created this method with future annotation
* @parm isCallTaxcalutaionRetry  : Set this by default true
* @parm isCallpostOHRetry      : Set this by default true
* @parm generatedSapBPIdsSet     : Here we passed set of sap bp id's in which number is already generated
*/
    @Future(callout=true)
    public static void directOrderCallout(String orderId, Boolean isCallTaxcalutaionRetry, Boolean isCallpostOHRetry , String opportunityId , Set<id> generatedSapBPIdsSet){
        List<Opportunity> opportunityList = new List<Opportunity>();
        List<SAP_BP__c> passedSapBpList = new List<SAP_BP__c>();
        //We cannot pass any list and opportunity in future method so, here we are querying the opportunity list and sapBp list 
        opportunityList = [Select Account.Name, Order_Status__c, id, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c,Ship_to_BP__r.Name,Bill_to_BP__r.Name, Message__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, RecordTypeId,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c from Opportunity where id =: opportunityId];
        passedSapBpList= [ SELECT Id,Care_Of__c,Department__c,Tax_Number_Category__c,Tax_Registration_Number__c,Campus_Id__c,Department_Id__c,Account_Id__c, Has_Valid_BP__c, SAddress_RRAdd_ID__c, Message__c, Name, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c FROM SAP_BP__c WHERE Id IN: generatedSapBPIdsSet ];
        if(!opportunityList.isEmpty() && opportunityList != NULL){
            TF_OrderTaxCalculation_Handler.orderCallout(orderId, true, true, opportunityList.get(0), passedSapBpList);
        }
    }
    
    /**
* orderCallout description       : Calculate tax and call post order hub accordingly
* @parm isCallTaxcalutaionRetry  : Set this by default true
* @parm isCallpostOHRetry         : Set this by default true
* @parm passedSapBpList          : Here we passed list of sap bp from TF_SAP_BP_Creation_Handler class
*/
    public static void orderCallout(String orderId, Boolean isCallTaxcalutaionRetry, Boolean isCallpostOHRetry , opportunity opp , List<SAP_BP__c> passedSapBpList){
        if(passedSapBpList != NULL) updateSapBpList.addAll(passedSapBpList);
        List<Order> orderList = new List<Order>();
        system.debug('orderTaxCalculationCallout'); 
        orderList= [ SELECT Id,BPC_Order_Type__c, SBQQ__Quote__c, Order_Channel__c, CurrencyIsoCode, Message__c,TotalAmount,SBQQ_TotalAmount__c, OrderNumber,CreatedDate,OpportunityId, accountId, Status, Order_Seller__c, SBQQ__TaxAmount__c  FROM Order WHERE Id =: orderId];                
        if(!orderList.isEmpty()){
            /*if(String.isNotBlank(orderList.get(0).Message__c) && orderList.get(0).Message__c.Contains('Tax Calculation-Success')){
//If tax is already calculated then query orderItem list and pass it for post order hub
orderItemUpdateList = [select Id,Line_reference__c, ISBN__c, ListPrice, SBQQ__QuotedListPrice__c, Total_Discount_Amount__c, Total_Discount_Percentage__c, UnitPrice, Discount_Amount__c, SBQQ__OrderedQuantity__c, SBQQ__TaxCode__c, SBQQ__TaxAmount__c, CurrencyIsoCode,SBQQ_NetTotal__c, Quantity, TotalPrice, OrderId FROM OrderItem where OrderId =: orderId];
Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
Trig_Order_PostOHObj.postOrderOnOrderHubMethod(orderList, orderItemUpdateList, true, true, opp, updateSapBpList);
}
else orderTaxCalculation(orderList, isCallTaxcalutaionRetry, isCallpostOHRetry , opp);*/
            orderTaxCalculation(orderList, isCallTaxcalutaionRetry, isCallpostOHRetry , opp);
        }
    }
    
    /**
* orderTaxCalculation description : In this method we are doing callout and updating message feild on Order and tax code, tax ammount and net total fields on orderItem  
*/
    Public static void orderTaxCalculation(List<Order> orderList, Boolean isCallTaxcalutaionRetry, Boolean isCallpostOHRetry , opportunity opp){
        system.debug('Call platform executer class');
        orderWrapperClass orderWrapperClassObj = new orderWrapperClass();
        Map<Id, String> orderToBodyMap = new Map<Id, String>();
        List<Order> updateOrderList = new List<Order>();
        List<String> messageList = new List<string>();
        
        //Get uri from custom settings
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Order_Tax_Calculation__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        if (orderList!= NULL && !orderList.isEmpty()){
            for (Order order : orderList){
                try{
                    HttpResponse res = new HttpResponse();
                    //Create JSON body
                    String body = getBody(order);
                    
                    if(body != null){
                        orderToBodyMap.put(order.id, body);
                        if(orderToBodyMap.containsKey(order.id)){
                            res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                        }
                        system.debug('Before update Order body'+body);
                        system.debug('Before update Order Message '+order.Message__c);
                        system.debug('res ' +res);
                        //If status code is 200 then update the message field value on order
                        if(res != NULL && res.getStatusCode() == 200){
                            system.debug('&&&&&&'+res.getStatusCode());system.debug('&&&&&&'+res.getbody());
                            //Deserialize JSON and update fields of orderItems object
                            orderTaxCalculation_Response orderTaxCalculation_Res = (orderTaxCalculation_Response)JSON.deserialize(res.getBody(), orderTaxCalculation_Response.class);
                            system.debug(orderTaxCalculation_Res);
                            //Set this variable true if tax calculated
                            taxCalculated = true;
                            
                            if(String.isNotBlank(order.Message__c)){
                                Map<integer,String> mapIndexValue = new Map<integer,String>();
                                messageList = order.Message__c.split('~msg~');
                                integer j = 0 ;
                                for(String msgStr : messageList){
                                    if (msgStr!=NULL && msgStr.containsIgnoreCase('Tax Calculation-Failed') ) {
                                        // overwrite string 
                                        mapIndexValue.put( j , ' Tax Calculation-Success' + ' ' );
                                    }
                                    j++;
                                }
                                if(!order.Message__c.containsIgnoreCase('Tax Calculation')) messageList.add(' Tax Calculation-Success' + ' ' );
                                for (integer i  : mapIndexValue.keySet()) {
                                    messageList.remove(i);
                                    messageList.add(mapIndexValue.get(i));
                                }
                                
                                system.debug('messageList-'+messageList);
                                // combine the string 
                                String finalStr;
                                for (Integer i = 0; i < messageList.size(); i++) {  
                                    if(i==0) finalStr = messageList.get(0) +' ';
                                    else finalStr = finalStr  + '~msg~' + messageList.get(i) +' ';   
                                }
                                if ( String.isNotBlank( finalStr)) {
                                    //order.Message__c = finalStr ;
                                    Integer maxSize = 65536;
                                    if(finalStr.length() > maxSize ){
                                        finalStr = finalStr.substring(0, maxSize);
                                        order.Message__c = finalStr;
                                    }else{
                                        order.Message__c = finalStr;
                                    }
                                }
                            }else if(String.isBlank(order.Message__c)){
                                //order.Message__c = ' Tax Calculation-Success';
                                String odrMessageValue = ' Tax Calculation-Success';
                                Integer maxSize = 65536;
                                if(odrMessageValue.length() > maxSize ){
                                    odrMessageValue = odrMessageValue.substring(0, maxSize);
                                    order.Message__c = odrMessageValue;
                                }else{
                                    order.Message__c = ' Tax Calculation-Success';
                                }
                            }
                            //Here we are querying order product and updating tax code, tax ammount and net total on it
                            //Siddhant
                            List<OrderItem> orderProductsDetails = new List<OrderItem>([select Id,PCM_UUID__c,PCM_Type__c,Product2.ProductCode  ,Product2.doi__c,PCM_ISBN__c,PCM_DOI__c,Line_reference__c, SBQQ__QuotedListPrice__c,ISBN__c, Total_Discount_Amount__c, Total_Discount_Percentage__c, UnitPrice, ListPrice, Discount_Amount__c, SBQQ__OrderedQuantity__c, SBQQ__TaxCode__c, SBQQ__TaxAmount__c, CurrencyIsoCode,SBQQ_NetTotal__c, Quantity, TotalPrice, OrderId FROM OrderItem where OrderId =: order.id]);
                            if(!orderProductsDetails.isEmpty()){
                                
                                for(integer i=0; i<orderProductsDetails.size(); i++){
                                    system.debug('orderProductsDetails[i].SBQQ__TaxAmount__c--> '+orderProductsDetails[i].SBQQ__TaxAmount__c);
                                    system.debug('orderProductsDetails[i].TotalPrice--> '+orderProductsDetails[i].TotalPrice);
                                    system.debug('orderProductsDetails[i].Total_Discount_Amount__c--> '+orderProductsDetails[i].Total_Discount_Amount__c);
                                    
                                    //SFAL-51 added by shubham kumar
                                    /*integer sumOfChildListprice = TF_CreateBundle.getListPriceSumBundleItems(orderProductsDetails[i].PCM_UUID__c);
orderProductsDetails[i].Bundle_List_Price__c = sumOfChildListprice;
orderProductsDetails[i].Discount_Amount__c = sumOfChildListprice - SBQQ__BlockPrice__c;
orderProductsDetails[i].Discount_Amount__c = orderTaxCalculation_Res.Data.Items[i].offerCode;
orderProductsDetails[i].Discount_Amount__c = orderTaxCalculation_Res.Data.Items[i].offerCode;
orderProductsDetails[i].ListPrice = (orderProductsDetails[i].Quantity)*(orderTaxCalculation_Res.Data.Items[i].tax);
orderProductsDetails[i].Discount_Code__c = (orderProductsDetails[i].TotalPrice)+(orderProductsDetails[i].SBQQ__TaxAmount__c);
orderProductsDetails[i].Discount_Percentage__c = orderTaxCalculation_Res.Data.Items[i].offerCode;
orderProductsDetails[i].Discount_Rate__c = (orderProductsDetails[i].Quantity)*(orderTaxCalculation_Res.Data.Items[i].tax);
orderProductsDetails[i].Discount__c = (orderProductsDetails[i].TotalPrice)+(orderProductsDetails[i].SBQQ__TaxAmount__c);
*/
                                    orderProductsDetails[i].SBQQ__TaxCode__c = orderTaxCalculation_Res.Data.Items[i].offerCode;
                                    orderProductsDetails[i].SBQQ__TaxAmount__c = (orderProductsDetails[i].Quantity)*(orderTaxCalculation_Res.Data.Items[i].tax);
                                    orderProductsDetails[i].SBQQ_NetTotal__c = (orderProductsDetails[i].TotalPrice)+(orderProductsDetails[i].SBQQ__TaxAmount__c);
                                    orderItemUpdateList.add(orderProductsDetails[i]);
                                }
                            }
                            system.debug(orderItemUpdateList);
                        }
                        else{
                            //Here we are mapping the message field value on order when status code is other than 200
                            system.debug('&&&&&&'+res.getStatusCode());system.debug('&&&&&&'+res.getbody());
                            //Deserialize JSON and update error message field on Order object
                            orderTaxCalculation_Error_Response orderTaxCalculation_Error_Res = (orderTaxCalculation_Error_Response)JSON.deserialize(res.getBody(), orderTaxCalculation_Error_Response.class);
                            system.debug(orderTaxCalculation_Error_Res);
                            errorHttpResponseTax =  res.getbody();
                            errorMessageTax = 'Tax Calculation-Failed, ' +orderTaxCalculation_Error_Res.Metadata.details;
                            
                            if(String.isNotBlank(order.Message__c)){
                                Map<integer,String> mapIndexValue = new Map<integer,String>();
                                messageList = order.Message__c.split('~msg~');
                                integer j = 0 ;
                                for(String msgStr : messageList){
                                    if (msgStr!=NULL && (msgStr.containsIgnoreCase('Tax Calculation-Success') || msgStr.containsIgnoreCase('Tax Calculation-Failed'))) {
                                        // overwrite string 
                                        mapIndexValue.put( j , ' Tax Calculation-Failed, ' +orderTaxCalculation_Error_Res.Metadata.details+ ' ' );
                                    }
                                    j++;
                                }
                                if(!order.Message__c.containsIgnoreCase('Tax Calculation')) messageList.add(' Tax Calculation-Failed, ' +orderTaxCalculation_Error_Res.Metadata.details+ ' ' );
                                for (integer i  : mapIndexValue.keySet()) {
                                    messageList.remove(i);
                                    messageList.add(mapIndexValue.get(i));
                                }
                                
                                system.debug('messageList-'+messageList);
                                // combine the string 
                                String finalStr;
                                for (Integer i = 0; i < messageList.size(); i++) {  
                                    if(i==0) finalStr = messageList.get(0) +' ';
                                    else finalStr = finalStr  + '~msg~' + messageList.get(i) +' ';   
                                }
                                if ( String.isNotBlank( finalStr)) {
                                    //order.Message__c = finalStr ;
                                    Integer maxSize = 65536;
                                    if(finalStr.length() > maxSize ){
                                        finalStr = finalStr.substring(0, maxSize);
                                        order.Message__c = finalStr;
                                    }else{
                                        order.Message__c = finalStr;
                                    }
                                    
                                    
                                }
                            }else if(String.isBlank(order.Message__c)){
                                //order.Message__c = ' Tax Calculation-Failed, ' +orderTaxCalculation_Error_Res.Metadata.details;
                                String messageValue = ' Tax Calculation-Failed, ' +orderTaxCalculation_Error_Res.Metadata.details;
                                Integer maxSize = 65536;
                                if(messageValue.length() > maxSize ){
                                    messageValue = messageValue.substring(0, maxSize);
                                    order.Message__c = messageValue;
                                }else{
                                    order.Message__c = messageValue;
                                }
                                
                            }
                        }
                    }
                    //When all address fields of SAP BP are empty then update the message field without doing callout on order
                    else{
                        errorMessageTax = 'Tax Calculation-Failed, All address fields are empty on bill to BP';
                        if(String.isNotBlank(order.Message__c)){
                            Map<integer,String> mapIndexValue = new Map<integer,String>();
                            messageList = order.Message__c.split('~msg~');
                            integer j = 0 ;
                            for(String msgStr : messageList){
                                if (msgStr!=NULL && (msgStr.containsIgnoreCase('Tax Calculation-Success') || msgStr.containsIgnoreCase('Tax Calculation-Failed'))){
                                    // overwrite string 
                                    mapIndexValue.put( j , ' Tax Calculation-Failed, All address fields are empty on bill to BP' + ' ' );
                                }
                                j++;
                            }
                            if(!order.Message__c.containsIgnoreCase('Tax Calculation')) messageList.add(' Tax Calculation-Failed, All address fields are empty on bill to BP' );
                            for (integer i  : mapIndexValue.keySet()) {
                                messageList.remove(i);
                                messageList.add(mapIndexValue.get(i));
                            }
                            
                            system.debug('messageList-'+messageList);
                            // combine the string 
                            String finalStr;
                            for (Integer i = 0; i < messageList.size(); i++) {  
                                if(i==0) finalStr = messageList.get(0) +' ';
                                else finalStr = finalStr  + '~msg~' + messageList.get(i) +' ';   
                            }
                            if ( String.isNotBlank( finalStr)) {
                                //order.Message__c = finalStr ;
                                Integer maxSize = 65536;
                                if(finalStr.length() > maxSize ){
                                    finalStr = finalStr.substring(0, maxSize);
                                    order.Message__c = finalStr;
                                }else{
                                    order.Message__c = finalStr;
                                }
                            }
                        }else if(String.isBlank(order.Message__c)){
                            //order.Message__c = ' Tax Calculation-Failed, All address fields are empty';
                            String odrMessageValue = ' Tax Calculation-Failed, All address fields are empty on bill to BP';
                            Integer maxSize = 65536;
                            if(odrMessageValue.length() > maxSize ){
                                odrMessageValue = odrMessageValue.substring(0, maxSize);
                                order.Message__c = odrMessageValue;
                            }else{
                                order.Message__c = odrMessageValue;
                            }
                        }
                        
                    }
                    system.debug('Final Order Message '+order.Message__c);
                    updateOrderList.add(order);
                    //Call postOH method here if tax is calculated
                    Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
                    if(taxCalculated){
                        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(updateOrderList, orderItemUpdateList, isCallTaxcalutaionRetry, isCallpostOHRetry, opp, updateSapBpList);
                    }else{
                        Trig_Order_PostOHObj.postOrderOnOrderHubMethod(updateOrderList, orderItemUpdateList, isCallTaxcalutaionRetry, false, opp, updateSapBpList);
                    }
                }catch(Exception ex){
                    System.debug('*********** Tax Calculation Exception :' + ex.getMessage()+' '+ ex.getLineNumber());
                    //Set message on oeder in case of exception
                    Order ord = new Order();
                    ord = updateOrderInException(order, ex.getMessage()); 
                    updateOrderList.add(ord);
                    errorMessageTax = 'Tax Calculation-Failed, '+ex.getMessage();
                    Trig_Order_PostOH Trig_Order_PostOHObj = new Trig_Order_PostOH();
                    Trig_Order_PostOHObj.postOrderOnOrderHubMethod(updateOrderList, orderItemUpdateList, isCallTaxcalutaionRetry, false, opp, updateSapBpList);
                }
            }
        }
    }
    
    //Set message on oeder in case of exception
    public static Order updateOrderInException(Order order, String exceptionMessage){
        orderWrapperClass orderWrapperClassObj = new orderWrapperClass();
        orderWrapperClassObj.updateOrderList = new List<Order>();
        List<Order> updateOrderList = new List<Order>();
        system.debug('InExceptionUdateMethod');
        
        String messageStr = order.Message__c;
        if ( messageStr != NULL && String.isNotBlank(messageStr) ) {
            Map<integer,String> mapIndexValue = new Map<integer,String>();
            List<String> listStr = messageStr.split('~msg~');
            integer j = 0 ;
            for (String msgStr : listStr) {
                System.debug('msgStr-'+msgStr);
                if (msgStr!=NULL && msgStr.containsIgnoreCase('Tax Calculation') ) {
                    // overwrite string , it can be success or failure mssg 
                    mapIndexValue.put( j , ' Tax Calculation-Failed '+exceptionMessage + ' ' );
                }
                j++;
            }
            if(!order.Message__c.containsIgnoreCase('Tax Calculation')) listStr.add(' Tax Calculation-Failed, '+exceptionMessage );
            System.debug('mapIndexValue_'+mapIndexValue);
            for (integer i  : mapIndexValue.keySet()) {
                listStr.remove(i);
                System.debug('listStr.size()'+listStr.size());
                listStr.add(mapIndexValue.get(i));
            }
            
            system.debug('listStr-'+listStr);                    
            // combine the string 
            String finalStr;
            for (Integer i = 0; i < listStr.size(); i++) {                        
                if(i==0) finalStr = listStr.get(0) +' ';
                else finalStr = finalStr  + '~msg~' + listStr.get(i) +' ';                        
            }
            if ( String.isNotBlank( finalStr)) {
                order.Message__c = finalStr ;
            }
        }
        else if(String.isBlank(messageStr)){
            order.Message__c = 'Tax Calculation-Failed, '+ exceptionMessage;
        }
        System.debug('Message in case of exception '+order.Message__c);
        return order;
    }
    
    //Get body for tax calculation callout
    public static String getBody(Order order){
        String getBody;
        //String itemBody;
        String billCountryCodeISO;
        String shipCountryCodeISO;
        //List<String> getItemBodyList = new List<string>();
        system.debug('getBody');
        //Get details of the lookup field(Bill_to_BP__c) on opportunity on the basis of the current order's opportunityId and use those values as bill to address in JSON body
        List<Opportunity> opportunityDetails = new List<opportunity>([Select id,RecordType.Name, Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c, Ship_to_BP__c,  Ship_to_BP__r.Email__c, Ship_to_BP__r.First_Name__c, Ship_to_BP__r.Last_Name__c, Ship_to_BP__r.Country__c, Ship_to_BP__r.Region__c, Ship_to_BP__r.State__c, Ship_to_BP__r.Street__c, Ship_to_BP__r.ZIP__c, Ship_to_BP__r.City__c from Opportunity where id =: order.OpportunityId]); 
        if(!opportunityDetails.isEmpty()){
            if(String.isNotBlank(opportunityDetails.get(0).Bill_to_BP__c) && String.isBlank(opportunityDetails.get(0).Ship_to_BP__c)){
                for(Opportunity ordBillAddress : opportunityDetails){
                    
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.First_Name__c)){
                        ordBillAddress.Bill_to_BP__r.First_Name__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.Last_Name__c)){
                        ordBillAddress.Bill_to_BP__r.Last_Name__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.Email__c)){
                        ordBillAddress.Bill_to_BP__r.Email__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.Street__c)){
                        ordBillAddress.Bill_to_BP__r.Street__c = '';
                    }else if(ordBillAddress.Bill_to_BP__r.Street__c.contains('\n')){
                        List<String> billStreetList  = ordBillAddress.Bill_to_BP__r.Street__c.split('\n');
                        String billListStr = '';
                        if(!billStreetList.isEmpty()){
                            for(String item : billStreetList ){
                                item = item.replace('\r',' ');
                                billListStr += item+' ';
                            }
                        }
                        ordBillAddress.Bill_to_BP__r.Street__c = billListStr;
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.ZIP__c)){
                        ordBillAddress.Bill_to_BP__r.ZIP__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.City__c)){
                        ordBillAddress.Bill_to_BP__r.City__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.State__c)){
                        ordBillAddress.Bill_to_BP__r.State__c = '';                
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.Country__c)){
                        ordBillAddress.Bill_to_BP__r.Country__c = '';
                    }
                    if(String.isBlank(ordBillAddress.Bill_to_BP__r.Region__c)){
                        ordBillAddress.Bill_to_BP__r.Region__c = '';
                    }
                    if(String.isBlank(order.CurrencyIsoCode)){
                        order.CurrencyIsoCode = '';
                    }
                    //If all SAP BP address values are null then return body null and don't hit API
                    if(ordBillAddress.Bill_to_BP__r.Street__c == '' && ordBillAddress.Bill_to_BP__r.ZIP__c == '' && ordBillAddress.Bill_to_BP__r.City__c == '' && ordBillAddress.Bill_to_BP__r.State__c == '' && ordBillAddress.Bill_to_BP__r.Country__c == '' && ordBillAddress.Bill_to_BP__r.Region__c == ''){
                        getBody = Null;
                    }
                    else{
                        //Find ISO code of country
                        List<Country__c> billCountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: ordBillAddress.Bill_to_BP__r.Country__c limit 1]);
                        if (!billCountryCode.isEmpty()){
                            billCountryCodeISO = billCountryCode.get(0).Country_2__c;
                        }
                        
                        // fetching the bill to sap bp number from the list and passed here 
                        SAP_BP__c sapBillToUpdatedBpNumber ;
                        id oppBillSapId = ordBillAddress.Bill_to_BP__c ;
                        for (SAP_BP__c sapObj  : updateSapBpList) {
                            if (sapObj.id == oppBillSapId  ) {
                                sapBillToUpdatedBpNumber = sapObj;
                            }
                        }
                        //Shalini: Start changes for V4 tax API, SAL-4497 
                        //Get list of order products 
                        //Shubham :SalesOrg parameter (SFAL 170) 
                        String itemListStr = itemList(order,opportunityDetails.get(0).RecordType.Name);//Shalini: passing this recordTypeName to do the modification for new tax API, SAL-4497
                        
                        if(opportunityDetails.get(0).RecordType.Name == 'T&F OA Journal Opportunity'){
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//"productType":"ARTICLE"
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: For BPC they want "TF-EBOOK-OA-COPY" this productType
                        else if(opportunityDetails.get(0).RecordType.Name == 'T&F - OA BPC Opportunity'){
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//"productType":"TF-EBOOK-OA-COPY"
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: channges end 
                        else{
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//,"productType":"TF-EBOOK"
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordBillAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordBillAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordBillAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordBillAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordBillAddress.Bill_to_BP__r.City__c+'","state":"'+ordBillAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordBillAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: End changes for V4 tax API, SAL-4497 
                        
                        system.debug('JSON Body===>'+getBody);   
                    }
                }   
            }
            if(String.isNotBlank(opportunityDetails.get(0).Bill_to_BP__c) && String.isNotBlank(opportunityDetails.get(0).Ship_to_BP__c)){
                for(Opportunity ordAddress : opportunityDetails){
                    if(String.isBlank(ordAddress.Bill_to_BP__r.First_Name__c)){
                        ordAddress.Bill_to_BP__r.First_Name__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.Last_Name__c)){
                        ordAddress.Bill_to_BP__r.Last_Name__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.Email__c)){
                        ordAddress.Bill_to_BP__r.Email__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.Street__c)){
                        ordAddress.Bill_to_BP__r.Street__c = '';
                    }else if(ordAddress.Bill_to_BP__r.Street__c.contains('\n')){
                        List<String> billStreetList  = ordAddress.Bill_to_BP__r.Street__c.split('\n');
                        String billListStr = '';
                        if(!billStreetList.isEmpty()){
                            for(String item : billStreetList ){
                                item = item.replace('\r',' ');
                                billListStr += item+' ';
                            }
                        }
                        ordAddress.Bill_to_BP__r.Street__c = billListStr;
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.ZIP__c)){
                        ordAddress.Bill_to_BP__r.ZIP__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.City__c)){
                        ordAddress.Bill_to_BP__r.City__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.State__c)){
                        ordAddress.Bill_to_BP__r.State__c = '';                
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.Country__c)){
                        ordAddress.Bill_to_BP__r.Country__c = '';
                    }
                    if(String.isBlank(ordAddress.Bill_to_BP__r.Region__c)){
                        ordAddress.Bill_to_BP__r.Region__c = '';
                    }
                    if(String.isBlank(order.CurrencyIsoCode)){
                        order.CurrencyIsoCode = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.First_Name__c)){
                        ordAddress.Ship_to_BP__r.First_Name__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.Last_Name__c)){
                        ordAddress.Ship_to_BP__r.Last_Name__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.Email__c)){
                        ordAddress.Ship_to_BP__r.Email__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.Street__c)){
                        ordAddress.Ship_to_BP__r.Street__c = '';
                    }else if(ordAddress.Ship_to_BP__r.Street__c.contains('\n')){
                        List<String> billStreetList  = ordAddress.Ship_to_BP__r.Street__c.split('\n');
                        String billListStr = '';
                        if(!billStreetList.isEmpty()){
                            for(String item : billStreetList ){
                                item = item.replace('\r',' ');
                                billListStr += item+' ';
                            }
                        }
                        ordAddress.Ship_to_BP__r.Street__c = billListStr;
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.ZIP__c)){
                        ordAddress.Ship_to_BP__r.ZIP__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.City__c)){
                        ordAddress.Ship_to_BP__r.City__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.State__c)){
                        ordAddress.Ship_to_BP__r.State__c = '';                
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.Country__c)){
                        ordAddress.Ship_to_BP__r.Country__c = '';
                    }
                    if(String.isBlank(ordAddress.Ship_to_BP__r.Region__c)){
                        ordAddress.Ship_to_BP__r.Region__c = '';
                    }
                    //If all SAP BP address values are null then return body null and don't hit API
                    if(ordAddress.Bill_to_BP__r.Street__c == '' && ordAddress.Bill_to_BP__r.ZIP__c == '' && ordAddress.Bill_to_BP__r.City__c == '' && ordAddress.Bill_to_BP__r.State__c == '' && ordAddress.Bill_to_BP__r.Country__c == '' && ordAddress.Bill_to_BP__r.Region__c == ''){
                        getBody = Null;
                    }
                    else{
                        //Find ISO code of country
                        List<Country__c> billCountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: ordAddress.Bill_to_BP__r.Country__c limit 1]);
                        if (!billCountryCode.isEmpty()){
                            billCountryCodeISO = billCountryCode.get(0).Country_2__c;
                        }
                        List<Country__c> shipCountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: ordAddress.Ship_to_BP__r.Country__c limit 1]);
                        if (!shipCountryCode.isEmpty()){
                            shipCountryCodeISO = shipCountryCode.get(0).Country_2__c;
                        }
                        
                        // fetching the bill to  & ship to  sap bp number from the list and passed here 
                        SAP_BP__c sapBillToUpdatedBpNumber ;
                        SAP_BP__c sapShipToUpdatedBpNumber ;
                        id oppBillSapId = ordAddress.Bill_to_BP__c ;
                        id oppShipSapId = ordAddress.Ship_to_BP__c ;
                        for (SAP_BP__c sapObj  : updateSapBpList) {
                            if (sapObj.id == oppBillSapId  ) {
                                sapBillToUpdatedBpNumber = sapObj;
                            }
                            if (sapObj.id == oppShipSapId  ) {
                                sapShipToUpdatedBpNumber = sapObj;
                            }
                        }
                        //Shalini: Start changes for V4 tax API, SAL-4497 
                        //Get list of order products 
                        //Shubham :SalesOrg parameter (SFAL 170) 
                        String itemListStr = itemList(order, opportunityDetails.get(0).RecordType.Name);//Shalini: passing this recordTypeName to do the modification for new tax API, SAL-4497
                        
                        if(opportunityDetails.get(0).RecordType.Name == 'T&F OA Journal Opportunity'){
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//"productType":"ARTICLE"
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: For BPC they want "TF-EBOOK-OA-COPY" this productType
                        else if(opportunityDetails.get(0).RecordType.Name == 'T&F - OA BPC Opportunity'){
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//"productType":"TF-EBOOK-OA-COPY"
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: channges end 
                        else{
                            if(String.isNotBlank(itemListStr))
                                getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":['+itemListStr+']}';//"productType":"TF-EBOOK",
                            else getBody = '{"salesOrg":"IN01","metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"items":[]}';
                        }
                        //Shalini: end changes for V4 tax API, SAL-4497 
                        /* if(String.isNotBlank(itemListStr))
getBody = '{"metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"productType":"TF-EBOOK","items":['+itemListStr+']}';
else getBody = '{"metaData":{"customer":{"customerEmail":"'+ordAddress.Bill_to_BP__r.Email__c+'"},"addressGroup":{"billTo":{"personName":{"firstName":"'+ordAddress.Bill_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Bill_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Bill_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Bill_to_BP__r.City__c+'","state":"'+ordAddress.Bill_to_BP__r.State__c+'","postalCode":"'+ordAddress.Bill_to_BP__r.ZIP__c+'","country":"'+billCountryCodeISO+'","bpNumber": "'+sapBillToUpdatedBpNumber.Name+'"}},"shipTo":{"personName":{"firstName":"'+ordAddress.Ship_to_BP__r.First_Name__c+'","lastName":"'+ordAddress.Ship_to_BP__r.Last_Name__c+'"},"address":{"organisation":"","department":"","addressLine1":"'+ordAddress.Ship_to_BP__r.Street__c+'","addressLine2":"","city":"'+ordAddress.Ship_to_BP__r.City__c+'","state":"'+ordAddress.Ship_to_BP__r.State__c+'","postalCode":"'+ordAddress.Ship_to_BP__r.ZIP__c+'","country":"'+shipCountryCodeISO+'","bpNumber": "'+sapShipToUpdatedBpNumber.Name+'"}}},"currency":"'+order.CurrencyIsoCode+'"},"productType":"TF-EBOOK","items":[]}';
*/
                        system.debug('JSON Body===>'+getBody);   
                    }
                }   
            }
        }
        return getBody;
    }
    
    public static string itemList(Order order, String oppRecordTypeName){
        String itemBody;
        Id BPCOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('TF OA BPC Order').getRecordTypeId();
        String bespokeRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId(); //SFAL-625 Vikas Varshney
        String collectionRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Collection').getRecordTypeId(); //SFAL-626 Shubham Kumar
        
        List<String> getItemBodyList = new List<string>();
        String itemListStr = '';
        Decimal totalDiscountPercentage = 0;
        //Find number of orderItems of current order
        List<OrderItem> orderProductsList = new List<OrderItem>([select Id,SBQQ__QuoteLine__r.SBQQ__Bundled__c,SBQQ__QuoteLine__r.SBQQ__Quote__r.Quote_Sales_Type__c,product2.businessId__c, SBQQ__QuotedListPrice__c, Total_Discount_Percentage__c, OrderId, OrderItemNumber, Quantity, UnitPrice, Product2Id,PCM_ISBN__c,PCM_DOI__c,PCM_UUID__c,PCM_Type__c,Order.RecordTypeId, Product2.RecordTypeId, Product2.Product_Type_Author_Facing__c FROM OrderItem where OrderId =: order.id]);
        // List<OrderItem> BundledorderProductsList = new List<OrderItem>([select Id,SBQQ__QuoteLine__r.SBQQ__Bundled__c, SBQQ__QuotedListPrice__c, Total_Discount_Percentage__c, OrderId, OrderItemNumber, Quantity, UnitPrice, Product2Id,PCM_ISBN__c,PCM_DOI__c,PCM_UUID__c,PCM_Type__c,Order.RecordTypeId   FROM OrderItem where OrderId =: order.id and SBQQ__QuoteLine__r.SBQQ__Bundled__c = true limit 1]);
        
        if(!orderProductsList.isEmpty()){
            for(OrderItem orderProduct : orderProductsList){
                //SFAL-55 : added by shubham kumar
                List<Product2> product = new List<Product2>();
                if(orderProduct.SBQQ__QuoteLine__r.SBQQ__Bundled__c == true){
                    system.debug('SBQQ__Bundled__c'+orderProduct.SBQQ__QuoteLine__r.SBQQ__Bundled__c);
                    system.debug('insisde w/o SBQQ__Bundled__c----------line 682');
                    if(TF_CreateBundle.getproductListfromPCM(orderProduct.PCM_UUID__c) != null && TF_CreateBundle.getproductListfromPCM(orderProduct.PCM_UUID__c).size() > 0){
                        String PcmIsbnNumber = TF_CreateBundle.getproductListfromPCM(orderProduct.PCM_UUID__c)[0];
                        List<OrderItem> orderProductsListfromBundle = new List<OrderItem>([select Id,SBQQ__QuoteLine__r.SBQQ__Bundled__c, SBQQ__QuotedListPrice__c, Total_Discount_Percentage__c, OrderId, OrderItemNumber, Quantity, UnitPrice, Product2Id,PCM_ISBN__c,PCM_DOI__c,PCM_UUID__c,PCM_Type__c,Order.RecordTypeId   FROM OrderItem where PCM_ISBN__c =: PcmIsbnNumber]);
                        product = [select ProductCode from Product2 where Id =: orderProductsListfromBundle[0].Product2Id];
                    }else{
                        system.debug('This product is not found.');
                    }
                }else{
                    product = [select ProductCode from Product2 where Id =: orderProduct.Product2Id]; 
                }
                String productCode;
                
                if(orderProduct.Order.RecordTypeId == BPCOrderRecordTypeId){
                    if(orderProduct.PCM_ISBN__c != null){
                        productCode = orderProduct.PCM_ISBN__c;
                    }
                }
                else{
                    if(!product.isEmpty()){
                        productCode = product.get(0).ProductCode; 
                    }
                }
                //Create dynamic JSON on the basis of number of current order's orderItems and create body for item list
                //
                //Shalini: Start changes for V4 tax API, SAL-4497 
                totalDiscountPercentage = (orderProduct.Total_Discount_Percentage__c != null ? orderProduct.Total_Discount_Percentage__c : 0);
                
                if(oppRecordTypeName =='T&F OA Journal Opportunity')
                    itemBody = '{"quantity":1,"price":'+orderProduct.SBQQ__QuotedListPrice__c+',"productId":"'+productCode+'","discount":'+totalDiscountPercentage+',"lineItemType":"Open Access Fee","salesType":"PURCHASE"}';
                if(oppRecordTypeName =='T&F - OA BPC Opportunity')
                {   
                    String lineItemType;
                    if(String.isNotBlank(order.BPC_Order_Type__c) && order.BPC_Order_Type__c == 'Frontlist eBook')
                        lineItemType = 'EBOOK-FRONTLIST';
                    else if(String.isNotBlank(order.BPC_Order_Type__c) && order.BPC_Order_Type__c == 'Frontlist Chapter')
                        lineItemType = 'EBK-CHAPTER-FRONTLIST';
                    else if(String.isNotBlank(order.BPC_Order_Type__c) && order.BPC_Order_Type__c == 'Backlist eBook')
                        lineItemType = 'EBOOK'; 
                    else if(String.isNotBlank(order.BPC_Order_Type__c) && order.BPC_Order_Type__c == 'Backlist Chapter')
                        lineItemType = 'EBK-CHAPTER';
                    
                    itemBody = '{"quantity":1,"price":'+orderProduct.SBQQ__QuotedListPrice__c+',"productId":"'+productCode+'","discount":'+totalDiscountPercentage+',"lineItemType":"'+lineItemType+'","salesType":"OA-FEE"}';
                }
                else itemBody = '{"quantity":1,"price":'+orderProduct.SBQQ__QuotedListPrice__c+',"productId":"'+productCode+'","discount":'+totalDiscountPercentage+',"lineItemType":"DIRECT-EBOOK","salesType":"PURCHASE"}';
                
                /*if(orderProduct.Total_Discount_Percentage__c != null){
itemBody = '{"quantity":1,"price":'+orderProduct.SBQQ__QuotedListPrice__c+',"productId":"'+productCode+'","discount":'+orderProduct.Total_Discount_Percentage__c+'}';
}else{
itemBody = '{"quantity":1,"price":'+orderProduct.SBQQ__QuotedListPrice__c+',"productId":"'+productCode+'","discount":0}';
}*/
                //Shalini: End changes for V4 tax API, SAL-4497 
                system.debug('itemBody--> '+itemBody);
                getItemBodyList.add(itemBody);
            }
            //Get values from getItemBodyList in comma separated form and put those values in itemListStr variable and then pass the value of itemListStr variable in JSON body as list of items
            //String itemListStr = '';
            if (!getItemBodyList.isEmpty()) {
                for ( String item : getItemBodyList ) {
                    itemListStr += item + ',';
                }
            }
            itemListStr = itemListStr.removeEnd(',');
            
            system.debug('Product type'+orderProductsList[0].Product2);
            system.debug('Product type Author Facing'+orderProductsList[0].Product2.Product_Type_Author_Facing__c);
            system.debug('Product type Record Type Id'+orderProductsList[0].Product2.RecordTypeId);
            system.debug('Product Sales Type'+orderProductsList[0].SBQQ__QuoteLine__r.SBQQ__Quote__r.Quote_Sales_Type__c);
            system.debug('Product Sales bespokeRecordTypeId'+bespokeRecordTypeId);
            //SFAL-625 Vikas Varshney ********* START *********
            if ( orderProductsList[0].Product2 != Null && String.isNotBlank(orderProductsList[0].Product2.Product_Type_Author_Facing__c) && orderProductsList[0].Product2.RecordTypeId == bespokeRecordTypeId && 'Manual Curation'.equalsIgnoreCase(orderProductsList[0].Product2.Product_Type_Author_Facing__c) ) {
                system.debug('Coming here Vikas');
                List<Bundle_Line_Item__c> bundleList = new List<Bundle_Line_Item__c>();
                bundleList = [ SELECT id, CurrencyIsoCode, PriceUSD__c, Product_Isbn__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:orderProductsList[0].Product2Id ];
                itemListStr = bespokeStaticItemListLMS( bundleList, totalDiscountPercentage);
            }
            //SFAL-625 Vikas Varshney ********* END *********
            
            //SFAL-626 Shubham Kumar ********* START *********
            if ( orderProductsList[0].Product2 != Null && String.isNotBlank(orderProductsList[0].Product2.Product_Type_Author_Facing__c) && orderProductsList[0].Product2.RecordTypeId == collectionRecordTypeId &&('Manual Curation'.equalsIgnoreCase(orderProductsList[0].Product2.Product_Type_Author_Facing__c) || 'Rule based'.equalsIgnoreCase(orderProductsList[0].Product2.Product_Type_Author_Facing__c)) ) {
                system.debug('Running foe type collection : '+orderProductsList[0].Product2);
                itemListStr = collectionSalesItemListLMS(orderProductsList);
            }
            //SFAL-626 Shubham Kumar ********* END *********
            
        }
        
        system.debug('orderProductsList'+orderProductsList);
        system.debug('itemListStr'+itemListStr);
        return itemListStr;
    }
    
    //SFAL-625 / 18Oct2022 / Vikas Varshney / Initial Version
    //@description : This method is creating item list for bespoke static bundle
    public static String bespokeStaticItemListLMS ( List<Bundle_Line_Item__c> bundleItemList, Decimal discountPercentage ){
        String itemListStr = '';
        List<BundleItemLMSWrapper> lmsItemWrapper;
        try {
            if ( !bundleItemList.isEmpty() ) {
                lmsItemWrapper = new List<BundleItemLMSWrapper>();
                for ( Bundle_Line_Item__c bundleItem : bundleItemList ) {
                    BundleItemLMSWrapper wrap = new BundleItemLMSWrapper();
                    wrap.quantity = 1;
                    wrap.price = ('USD'.equalsIgnoreCase(bundleItem.CurrencyIsoCode) ? bundleItem.PriceUSD__c : ( 'GBP'.equalsIgnoreCase(bundleItem.CurrencyIsoCode) ? bundleItem.PriceGBP__c : 0 ));
                    wrap.productId = bundleItem.Product_Isbn__c;
                    wrap.discount = discountPercentage != Null ? discountPercentage : 0;
                    wrap.lineItemType = 'EBOOK-BESPOKEBUNDLE-STATIC';
                    wrap.salesType = 'PURCHASE'; //PURCHASE/SUBSCRIPTION need to check with Chetan
                    lmsItemWrapper.add(wrap);
                }
            }
            
            if ( !lmsItemWrapper.isEmpty() ) {
                itemListStr = JSON.serialize(lmsItemWrapper);
                itemListStr = itemListStr.removeStart('[');
                itemListStr = itemListStr.removeEnd(']');
            }
        } catch ( Exception ex ) {
            System.debug('Exception TF_OrderTaxCalculation_Handler.bespokeStaticItemListLMS =====>' + ex.getMessage() + '***** Line *****' + ex.getLineNumber());
        }
        System.debug('itemListStr =====>' + itemListStr);
        
        return itemListStr;
    }
    
    //SFAL-626 / 25Oct2022 / Shubham Kumar / Initial Version
    //@description : This method is creating item list for Collection Sales
    public static String collectionSalesItemListLMS ( List<OrderItem> orderProductsList){
        String itemListStr = '';
        List<BundleItemLMSWrapper> lmsItemWrapper;
        try {
            if ( !orderProductsList.isEmpty() ) {
                lmsItemWrapper = new List<BundleItemLMSWrapper>();
                for ( OrderItem OrderItem : orderProductsList ) {
                    BundleItemLMSWrapper wrap = new BundleItemLMSWrapper();
                    wrap.quantity = 1;
                    wrap.price = OrderItem.SBQQ__QuotedListPrice__c ;
                    wrap.productId = OrderItem.Product2.businessId__c ;
                    wrap.discount = OrderItem.Total_Discount_Percentage__c != Null ? OrderItem.Total_Discount_Percentage__c : 0;
                    wrap.lineItemType = 'EBOOK-COLLECTION-DYNAMIC';
                    wrap.salesType = 'PURCHASE'; //PURCHASE/SUBSCRIPTION need to check with Chetan
                    lmsItemWrapper.add(wrap);
                }
            }
            
            if ( !lmsItemWrapper.isEmpty() ) {
                itemListStr = JSON.serialize(lmsItemWrapper);
                itemListStr = itemListStr.removeStart('[');
                itemListStr = itemListStr.removeEnd(']');
            }
        } catch ( Exception ex ) {
            System.debug('Exception TF_OrderTaxCalculation_Handler.collectionSalesItemListLMS =====>' + ex.getMessage() + '***** Line *****' + ex.getLineNumber());
        }
        System.debug('itemListStr =====>' + itemListStr);
        return itemListStr;
    }
    
    public class BundleItemLMSWrapper {
        Integer quantity;
        Decimal price;
        String productId;
        Decimal discount;
        String lineItemType;
        String salesType;
    }
 }