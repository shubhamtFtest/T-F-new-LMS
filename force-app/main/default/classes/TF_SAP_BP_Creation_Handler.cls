/*
* Test Class: zTEST_TF_SAP_BP_Creation_Handler
* Description : SAP BP Creation by calling SAP API by passing the required fields, Trigger on quote TF_SapBPCreation_TaxCal_OHCallout_Trig runs first then TF_SAP_BPcreation then this class
* Created by Piyush Jain - 2019.11.04
*/

public with sharing class TF_SAP_BP_Creation_Handler{
    
    public class SAP_BP_Response {
        public Metadata metadata;
        public List<Data> data;
    }
    
    public class SAP_BP_Error_Response {
        public Metadata metadata;
    }
    
    public class Metadata {
        public Integer code;
        public String timestamp;
        public String details;
    }
    
    public class Data {
        public String externalCustomerAddressId;
        public String businessPartnerNumber;
    }
    private static boolean numberNotGenerated = false;
    //private static boolean isRetryBothAddressAndNumber = false;
    //private static Opportunity opportunity = new Opportunity();
    private static List<SAP_BP__c> finalSapBpList = new List<SAP_BP__c>();
    private static List<SAP_BP__c> generatedSapBpList = new List<SAP_BP__c>();
    private static string taxNumberCategory;
    
    /**
*directSalesRetry description 		   : Here we are doing callout to generate business partner number without future in case of retry from TF_SAP_BP_ErrorHandling class
*@parm SapBpList  				       : We are passing list of sap bp from error handling class
*@parm SapIdToLookupMap  			   : Map bill to and ship to id with string bill to and ship to for setting message value 
*/
    public static void directSalesRetry(List<SAP_BP__c> SapBpList, Opportunity opp, Map<String, Id> SapIdToLookupMap, String orderId, String oppAccountName){
        system.debug('After address verification direct sales retry');
        List<SAP_BP__c> sapList = new List<SAP_BP__c>();
        //isRetryBothAddressAndNumber = true;
        //if(opp != Null) opportunity = opp;
        for(SAP_BP__c sapBp : SapBpList){
            //if(sapBp.Message__c != NULL && sapBp.Message__c.containsIgnoreCase('Generated Successfully')) generatedSapBpList.add(sapBp);
            if(String.isNotBlank(sapBp.Name) && !sapBp.Name.containsIgnoreCase('PENDING') && sapBp.Has_Valid_BP__c == true) generatedSapBpList.add(sapBp);
            else sapList.add(sapBp);    
        }
        if(!generatedSapBpList.isEmpty() && generatedSapBpList != NULL) finalSapBpList.addAll(generatedSapBpList);
        createBusinessPartner(sapList, opp.id, SapIdToLookupMap, orderId, oppAccountName);
    }
    
    /**
*sap_BP_Callout description : Here we are doing callout to generate business partner number
*@parm sapBPIdsSet  		 : Get all bill to and ship to sap bp ids
*@parm opportunityId  	     : Set opportunityId 
*@parm SapIdToLookupMap  	 : Map bill to and ship to id with string bill to and ship to for setting message value 
*/
    @Future(callout=true)
    public static void sap_BP_Callout(Set<Id> sapBPIdsSet, Set<id> generatedSapBPIdsSet, String opportunityId, Map<String, Id> SapIdToLookupMap, String orderId, String oppAccountName){
        List<SAP_BP__c> SapBpList = new List<SAP_BP__c>();
        system.debug('sapBpNumberCreation');
        SapBpList= [ SELECT Id, Care_Of__c, Department__c, Tax_Number_Category__c, Tax_Registration_Number__c, Has_Valid_BP__c, SAddress_RRAdd_ID__c, Message__c, Name, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c, Campus_Id__c,Department_Id__c,Account_Id__c FROM SAP_BP__c WHERE Id IN: sapBPIdsSet ];
        generatedSapBpList= [ SELECT Id, Care_Of__c, Department__c, Tax_Number_Category__c, Tax_Registration_Number__c, Has_Valid_BP__c, SAddress_RRAdd_ID__c, Message__c, Name, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c, Campus_Id__c,Department_Id__c,Account_Id__c FROM SAP_BP__c WHERE Id IN: generatedSapBPIdsSet ];
        
        if(!generatedSapBpList.isEmpty() && generatedSapBpList != NULL) finalSapBpList.addAll(generatedSapBpList);
        createBusinessPartner(SapBpList, opportunityId, SapIdToLookupMap, orderId, oppAccountName);
    }
    
    /**
*createBusinessPartner description : Call platform executer class and do callout and accouding to their status code set the message on sap bp and opportunity message field
*@parm SapBpList  					: Get all bill to and ship to sap bp in this list
*@parm opportunityId  				: Set opportunityId 
*@parm SapIdToLookupMap  			: Map bill to and ship to id with string bill to and ship to for setting message value 
*@parm orderId  					: Set orderId value which we are receiveing from order update trigger
*/
    Public static void createBusinessPartner(List<SAP_BP__c> SapBpList, String opportunityId, Map<String, Id> SapIdToLookupMap, String orderId, String oppAccountName){
        Map<Id, String> SapIdToBodyMap = new Map<Id, String>();
        List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
        List<String> messageList = new List<String>();
        
        //Get uri from custom settings
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('SAP_BP_Creation__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try{
            if (!SapBpList.isEmpty()){
                for (SAP_BP__c sapBp : SapBpList){
                    
                    //If id's of bill to bp and ship to bp is similar to each other then remove ship to from map
                    if(SapIdToLookupMap.containsKey('Bill to') && SapIdToLookupMap.containsKey('Ship to') && SapIdToLookupMap.get('Bill to') == sapBp.id && SapIdToLookupMap.get('Ship to') == sapBp.id)
                        SapIdToLookupMap.remove('Ship to');
                    
                    try {
                        HttpResponse res = new HttpResponse();
                        String body = getBody(sapBp, oppAccountName);
                        //map sap tax number category field 	
                        if(String.isNotBlank(taxNumberCategory)){	
                            sapBp.Tax_Number_Category__c = taxNumberCategory;	
                            system.debug('sapBp.Tax_Number_Category__c '+sapBp.Tax_Number_Category__c);	
                        } 
                        
                        if(body != null){
                            SapIdToBodyMap.put(sapBp.id, body);
                            if(SapIdToBodyMap.containsKey(sapBp.id)){
                                res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                            }   
                            system.debug('&&&&&&'+res.getStatusCode());system.debug('&&&&&&'+res.getbody());
                            //If we get 201 status code then set the message in sap bp message field
                            if(res != NULL && res.getStatusCode() == 201){
                                //Deserialize JSON and update name field of SAP_BP with the number
                                SAP_BP_Response SAP_BP_Res = (SAP_BP_Response)JSON.deserialize(res.getBody(), SAP_BP_Response.class);
                                system.debug(SAP_BP_Res);
                                
                                //Update business partner number
                                sapBp.Name = SAP_BP_Res.data[0].businessPartnerNumber;
                                
                                if(String.isNotBlank(sapBp.Message__c)){
                                    Map<integer,String> mapIndexValue = new Map<integer,String>();
                                    integer j = 0 ;
                                    messageList = sapBp.Message__c.split('~msg~');
                                    for(String msgStr : messageList){
                                        if (msgStr!=NULL && msgStr.containsIgnoreCase('Generation Failed') ) {
                                            // overwrite string 
                                            if(SapIdToLookupMap.containsKey('Bill to')){
                                                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                                    mapIndexValue.put( j , ' Bill to: Generated Successfully' + ' ' );  
                                                }
                                            }
                                            if(SapIdToLookupMap.containsKey('Ship to')){
                                                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                                    mapIndexValue.put( j , ' Ship to: Generated Successfully' + ' ' );                          
                                                }
                                            }
                                        }
                                        j++;
                                    }
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            if(!sapBp.Message__c.containsIgnoreCase('Genera')) messageList.add(' Bill to: Generated Successfully' + ' ');
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            if(!sapBp.Message__c.containsIgnoreCase('Genera')) messageList.add(' Ship to: Generated Successfully' + ' ');
                                        }
                                    }
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
                                        //sapBp.Message__c = finalStr ;
                                        Integer maxSize = 65536;
                                        if(finalStr.length() > maxSize ){
                                            finalStr = finalStr.substring(0, maxSize);
                                            sapBp.Message__c = finalStr;
                                        }else{
                                            sapBp.Message__c = finalStr;
                                        }
                                    }
                                }else if(String.isBlank(sapBp.Message__c)){
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            //sapBp.Message__c = 'Bill to: Generated Successfully';
                                            String messageValue = ' Bill to: Generated Successfully';
                                            Integer maxSize = 65536;
                                            if(messageValue.length() > maxSize ){
                                                messageValue = messageValue.substring(0, maxSize);
                                                sapBp.Message__c = messageValue;
                                            }else{
                                                sapBp.Message__c = messageValue;
                                            }
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            //sapBp.Message__c = 'Ship to: Generated Successfully';
                                            String messageValue = ' Ship to: Generated Successfully';
                                            Integer maxSize = 65536;
                                            if(messageValue.length() > maxSize ){
                                                messageValue = messageValue.substring(0, maxSize);
                                                sapBp.Message__c = messageValue;
                                            }else{
                                                sapBp.Message__c = messageValue;
                                            }
                                        }
                                    } 
                                }
                                
                                
                            }
                            else{
                                //Here we are mapping the message field value when status code is other than 201
                                //Deserialize JSON and update error message field on SAP object
                                SAP_BP_Error_Response SAP_BP_Error_Res = (SAP_BP_Error_Response)JSON.deserialize(res.getBody(), SAP_BP_Error_Response.class);
                                system.debug(SAP_BP_Error_Res);
                                numberNotGenerated = true;
                                
                                if(String.isNotBlank(sapBp.Message__c)){
                                    Map<integer,String> mapIndexValue = new Map<integer,String>();
                                    integer j = 0 ;
                                    messageList = sapBp.Message__c.split('~msg~');
                                    for(String msgStr : messageList){
                                        if (msgStr!=NULL && (msgStr.containsIgnoreCase('Generated Successfully') || msgStr.containsIgnoreCase('Generation Failed'))) {
                                            // overwrite string 
                                            if(SapIdToLookupMap.containsKey('Bill to')){
                                                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                                    mapIndexValue.put( j , ' Bill to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ' );  
                                                }
                                            }
                                            if(SapIdToLookupMap.containsKey('Ship to')){
                                                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                                    mapIndexValue.put( j , ' Ship to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ' );                          
                                                }
                                            }
                                        }
                                        j++;
                                    }
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Bill to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ');
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Ship to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ');
                                        }
                                    }
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
                                        //sapBp.Message__c = finalStr ;
                                        Integer maxSize = 65536;
                                        if(finalStr.length() > maxSize ){
                                            finalStr = finalStr.substring(0, maxSize);
                                            sapBp.Message__c = finalStr;
                                        }else{
                                            sapBp.Message__c = finalStr;
                                        }
                                    }
                                }else if(String.isBlank(sapBp.Message__c)){
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            //sapBp.Message__c = ' Bill to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ';
                                            String messageValue = ' Bill to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ';
                                            Integer maxSize = 65536;
                                            if(messageValue.length() > maxSize ){
                                                messageValue = messageValue.substring(0, maxSize);
                                                sapBp.Message__c = messageValue;
                                            }else{
                                                sapBp.Message__c = messageValue;
                                            }
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            //sapBp.Message__c = ' Ship to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
                                            String messageValue = ' Ship to: Generation Failed, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
                                            Integer maxSize = 65536;
                                            if(messageValue.length() > maxSize ){
                                                messageValue = messageValue.substring(0, maxSize);
                                                sapBp.Message__c = messageValue;
                                            }else{
                                                sapBp.Message__c = messageValue;
                                            }
                                        }
                                    } 
                                }
                                
                                
                            }
                        }else{
                            //When all address fields are empty then update the message field without doing callout
                            numberNotGenerated = true;
                            if(String.isNotBlank(sapBp.Message__c)){
                                Map<integer,String> mapIndexValue = new Map<integer,String>();
                                integer j = 0 ;
                                messageList = sapBp.Message__c.split('~msg~');
                                for(String msgStr : messageList){
                                    if (msgStr!=NULL && (msgStr.containsIgnoreCase('Generated Successfully') || msgStr.containsIgnoreCase('Generation Failed'))) {
                                        // overwrite string 
                                        if(SapIdToLookupMap.containsKey('Bill to')){
                                            if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                                mapIndexValue.put( j , ' Bill to: Generation Failed, All address fields are empty' + ' ' );  
                                            }
                                        }
                                        if(SapIdToLookupMap.containsKey('Ship to')){
                                            if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                                mapIndexValue.put( j , ' Ship to: Generation Failed, All address fields are empty' + ' ' );                          
                                            }
                                        } 
                                    }
                                    j++;
                                }
                                if(SapIdToLookupMap.containsKey('Bill to')){
                                    if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                        if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Bill to: Generation Failed, All address fields are empty' + ' ');
                                    }
                                }
                                if(SapIdToLookupMap.containsKey('Ship to')){
                                    if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                        if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Ship to: Generation Failed, All address fields are empty' + ' ');
                                    }
                                }
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
                                    //sapBp.Message__c = finalStr ;
                                    Integer maxSize = 65536;
                                    if(finalStr.length() > maxSize ){
                                        finalStr = finalStr.substring(0, maxSize);
                                        sapBp.Message__c = finalStr;
                                    }else{
                                        sapBp.Message__c = finalStr;
                                    }
                                }
                            }else if(String.isBlank(sapBp.Message__c)){
                                if(SapIdToLookupMap.containsKey('Bill to')){
                                    if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                        //sapBp.Message__c = '  Bill to: Generation Failed, All address fields are empty';
                                        String messageValue = '  Bill to: Generation Failed, All address fields are empty';
                                        Integer maxSize = 65536;
                                        if(messageValue.length() > maxSize ){
                                            messageValue = messageValue.substring(0, maxSize);
                                            sapBp.Message__c = messageValue;
                                        }else{
                                            sapBp.Message__c = messageValue;
                                        }
                                    }
                                }
                                if(SapIdToLookupMap.containsKey('Ship to')){
                                    if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                        //sapBp.Message__c = ' Ship to: Generation Failed, All address fields are empty'+ ' ';
                                        String messageValue = '  Ship to: Generation Failed, All address fields are empty';
                                        Integer maxSize = 65536;
                                        if(messageValue.length() > maxSize ){
                                            messageValue = messageValue.substring(0, maxSize);
                                            sapBp.Message__c = messageValue;
                                        }else{
                                            sapBp.Message__c = messageValue;
                                        }
                                    }
                                } 
                            }
                            
                            
                        }
                        updateSapBpList.add(sapBp);
                    } catch ( Exception ex ) {
                        //If we get any exception then we are setting message field value on sap bp and add in a list for updation 
                        System.debug('***********  SAP BP Callout Exception :' + ex.getMessage() +'****'+ ex.getLineNumber());
                        SAP_BP__c sap = new SAP_BP__c();
                        sap = updateOppMessageExcp(sapBp, ex.getMessage(), SapIdToLookupMap, opportunityId);
                        UpdateSapBpList.add(sap);
                    }
                }
                if(!UpdateSapBpList.isEmpty()){
                    //If number not generated update sap bp list 
                    if(numberNotGenerated){
                        update updateSapBpList;
                    }
                    //Get error message from SAP BP's error message field and update value in opportunity's error message field
                    String errorMessageOnOpp = '';
                    if(opportunityId != null){
                        List<Opportunity> oppUpdate = new List<Opportunity>([Select Account.Name, Order_Status__c, id, Ship_to_BP__r.Name, Bill_to_BP__r.Name, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c, Message__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, RecordTypeId,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c, Ship_to_BP__r.Email__c, Ship_to_BP__r.First_Name__c, Ship_to_BP__r.Last_Name__c, Ship_to_BP__r.Country__c, Ship_to_BP__r.Region__c, Ship_to_BP__r.State__c, Ship_to_BP__r.Street__c, Ship_to_BP__r.ZIP__c, Ship_to_BP__r.City__c from Opportunity where id =: opportunityId]);
                        system.debug('Before update opp message '+oppUpdate.get(0).Message__c);
                        //Call method for update opportunity message with proper bill to and ship to prefix
                        if(!oppUpdate.isEmpty() && oppUpdate != NULL)
                        updateProperBillToShipToPrefixMessage(oppUpdate.get(0), SapIdToLookupMap, updateSapBpList, finalSapBpList, errorMessageOnOpp);
                        //Call method for order tax calculation and pass opportunity and sapBpList in that for updation if number is generated
                        if(!numberNotGenerated){
                            TF_OrderTaxCalculation_Handler.orderCallout(orderId, true, true, oppUpdate.get(0), finalSapBpList);
                        }
                    }
                }
            }
        }catch(Exception ex){
            System.debug('***********  SAP BP DML Exception :' + ex.getMessage() +'****'+ ex.getLineNumber());
        }
    }   
    
    //Called this method in case of exception and update sapbpList and opportunity here
    public static SAP_BP__c updateOppMessageExcp(SAP_BP__c sapBp, String exceptionMessage, Map<String, Id> SapIdToLookupMap, String opportunityId){
        system.debug('InExceptionUdateMethod');
        numberNotGenerated = true;
        String errorMessageOnOpp = ''; 
        List<SAP_BP__c> UpdateSapBpList = new List<SAP_BP__c>();
        List<String> messageList = new List<String>();
        
        if(String.isNotBlank(sapBp.Message__c)){
            Map<integer,String> mapIndexValue = new Map<integer,String>();
            integer j = 0 ;
            messageList = sapBp.Message__c.split('~msg~');
            for(String msgStr : messageList){
                if (msgStr!=NULL && (msgStr.containsIgnoreCase('Generated Successfully') || msgStr.containsIgnoreCase('Generation Failed'))) {
                    // overwrite string 
                    if(SapIdToLookupMap.containsKey('Bill to')){
                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                            mapIndexValue.put( j , ' Bill to: Generation Failed, ' +exceptionMessage + ' ' );  
                        }
                    }
                    if(SapIdToLookupMap.containsKey('Ship to')){
                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                            mapIndexValue.put( j , ' Ship to: Generation Failed, '+exceptionMessage + ' ' );                          
                        }
                    } 
                }
                j++;
            }
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Bill to: Generation Failed, '+exceptionMessage + ' ');
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Generation Failed')) messageList.add(' Ship to: Generation Failed, '+exceptionMessage + ' ');
                }
            }
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
                //sapBp.Message__c = finalStr ;
                Integer maxSize = 65536;
                if(finalStr.length() > maxSize ){
                    finalStr = finalStr.substring(0, maxSize);
                    sapBp.Message__c = finalStr;
                }else{
                    sapBp.Message__c = finalStr;
                }
            }
        }else if(String.isBlank(sapBp.Message__c)){
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                    String messageValue = '  Bill to: Generation Failed, '+exceptionMessage;
                    Integer maxSize = 65536;
                    if(messageValue.length() > maxSize ){
                        messageValue = messageValue.substring(0, maxSize);
                        sapBp.Message__c = messageValue;
                    }else{
                        sapBp.Message__c = messageValue;
                    }
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                    String messageValue = '  Ship to: Generation Failed, '+exceptionMessage;
                    Integer maxSize = 65536;
                    if(messageValue.length() > maxSize ){
                        messageValue = messageValue.substring(0, maxSize);
                        sapBp.Message__c = messageValue;
                    }else{
                        sapBp.Message__c = messageValue;
                    }
                }
            } 
        }
        return sapBp;
    }
    
    //Update opportunity message with proper bill to and ship to prefix
    private static void updateProperBillToShipToPrefixMessage(Opportunity oppUpdate, Map<String, Id> SapIdToLookupMap, List<SAP_BP__C> updateSapBpList, List<SAP_BP__C> finalSapBpList,  String errorMessageOnOpp){
        if(!updateSapBpList.isEmpty() && updateSapBpList != NULL) finalSapBpList.addAll(updateSapBpList);
        for(SAP_BP__c sapBpMessage : finalSapBpList){
            
            system.debug('SapIdToLookupMap '+SapIdToLookupMap);
            //Doing changes for proper message field
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBpMessage.id){
                    if(sapBpMessage.Message__c.containsIgnoreCase('Ship to')){
                        sapBpMessage.Message__c = sapBpMessage.Message__c.replace('Ship to' , 'Bill to');
                    } 
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBpMessage.id){
                    if(sapBpMessage.Message__c.containsIgnoreCase('Bill to')){
                        sapBpMessage.Message__c = sapBpMessage.Message__c.replace('Bill to' , 'Ship to');
                    } 
                }
            }
            errorMessageOnOpp += sapBpMessage.Message__c + ' ~msg~ ';
        }
        errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
        Integer maxSize = 65536;
        if(errorMessageOnOpp.length() > maxSize ){
            errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
            oppUpdate.Message__c = errorMessageOnOpp;
        }else{
            oppUpdate.Message__c = errorMessageOnOpp;
        }	
        system.debug('oppUpdate.Message__c '+oppUpdate.Message__c);
        //In case of number not generated update opportunity here
        if(numberNotGenerated) {
            String errorMessageOnOppNew = '';
            if(oppUpdate.Bill_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Bill_to_BP__r.Message__c)) 
            {
                if(oppUpdate.Bill_to_BP__r.Message__c.containsIgnoreCase('Ship to')){
                    errorMessageOnOppNew += oppUpdate.Bill_to_BP__r.Message__c.replace('Ship to', 'Bill to') + ' ~msg~ ';
                }
                else errorMessageOnOppNew += oppUpdate.Bill_to_BP__r.Message__c + ' ~msg~ ';
            }
            if(oppUpdate.Ship_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Ship_to_BP__r.Message__c))
            {
                if(oppUpdate.Ship_to_BP__r.Message__c.containsIgnoreCase('Bill to')){
                    errorMessageOnOppNew += oppUpdate.Ship_to_BP__r.Message__c.replace('Bill to', 'Ship to') + ' ~msg~ ';
                }
                else errorMessageOnOppNew += oppUpdate.Ship_to_BP__r.Message__c + ' ~msg~ ';
            }
            
            errorMessageOnOppNew = errorMessageOnOppNew.removeEnd(' ~msg~ ');
            if(errorMessageOnOppNew.length() > maxSize ){
                errorMessageOnOppNew = errorMessageOnOppNew.substring(0, maxSize);
                oppUpdate.Message__c = errorMessageOnOppNew;
            }else{
                oppUpdate.Message__c = errorMessageOnOppNew;
            }
            system.debug('After update opp message '+oppUpdate.Message__c);
            oppUpdate.Order_Status__c = 'Failed';
            update oppUpdate;
        }
    }
    
    public static String getBody(SAP_BP__c sapBp, String oppAccountName){
        system.debug('getBody');
        String getJsonBody;
        String countryCodeISO;
        String customerName = ''; 
        String deptCampName = '';
        taxNumberCategory = ''; 
        String taxRegistrationNumber;
        String deptName = '';
        
        if(String.isBlank(sapBp.Address_Type__c)){
            sapBp.Address_Type__c = '';
        }
        if(String.isBlank(sapBp.First_Name__c)){
            sapBp.First_Name__c = '';
        }
        if(String.isBlank(sapBp.Last_Name__c)){
            sapBp.Last_Name__c = '';
        }
        if(String.isBlank(sapBp.Email__c)){
            sapBp.Email__c = '';                
        }
        if(String.isBlank(sapBp.Country__c)){
            sapBp.Country__c = '';
        }
        if(String.isBlank(sapBp.State__c)){
            sapBp.State__c = '';
        }
        if(String.isBlank(sapBp.Street__c)){
            sapBp.Street__c= '';
        }else if(sapBp.Street__c.contains('\n')){
            List<String> streetList  = sapBp.Street__c.split('\n');
            String streetListStr = '';
            if(!streetList.isEmpty()){
                for(String item : streetList ){
                    item = item.replace('\r',' ');
                    streetListStr += item+' ';
                }
            }
            sapBp.Street__c = streetListStr;
        }
        if(String.isBlank(sapBp.ZIP__c)){
            sapBp.ZIP__c= '';
        }
        if(String.isBlank(sapBp.City__c)){
            sapBp.City__c = '';
        }
        if(String.isBlank(sapBp.Region__c)){
            sapBp.Region__c = '';
        }
        if(String.isBlank(oppAccountName)){
            oppAccountName = '';
        }
        if(String.isBlank(sapBp.Tax_Registration_Number__c)){
            taxRegistrationNumber = '';
        }else taxRegistrationNumber = sapBp.Tax_Registration_Number__c;
        if(sapBp.Care_Of__c == null){
            sapBp.Care_Of__c = '';
        }
        
        if (String.isNotBlank( sapBp.Address_Type__c) ) {
            //Shalini Changes
            if (String.isNotBlank(sapBp.Department__c)){	
                deptName = sapBp.Department__c;	
            }
            //End Shalini Changes
            if (sapBp.Address_Type__c.containsIgnoreCase('account') &&  sapBp.Account_Id__c!=NULL ) {
                List<account> listAccBp = new List<account>([select id ,name from Account where id=:sapBp.Account_Id__c]);
                if(!listAccBp.isEmpty()) customerName = listAccBp.get(0).Name;    
            }             
            else if ( sapBp.Address_Type__c.equalsIgnoreCase('Campus')  && sapBp.Campus_Id__c!=NULL ) {
                List<Campus__c> listCampBp = new List<Campus__c>([select id ,name, Account__r.name from Campus__c where id=:sapBp.Campus_Id__c]);
                if(!listCampBp.isEmpty()) {
                    deptCampName  = listCampBp.get(0).Name;
                    if(listCampBp.get(0).Account__r != NULL)customerName = listCampBp.get(0).Account__r.name;
                }    
            }
            else if ( sapBp.Address_Type__c.equalsIgnoreCase('Department') && sapBp.Department_Id__c!=NULL) {
                List<Department__c> listDeptBp = new List<Department__c>([select id ,name, Account__r.name from Department__c where id=:sapBp.Department_Id__c]);
                if(!listDeptBp.isEmpty()){
                    deptCampName  = listDeptBp.get(0).Name;
                    if(listDeptBp.get(0).Account__r != NULL) customerName = listDeptBp.get(0).Account__r.name;
                }
            }
        }
        
        if(sapBp.Country__c == '' && sapBp.State__c == '' && sapBp.Street__c == '' && sapBp.ZIP__c == '' && sapBp.City__c == '' && sapBp.Region__c == ''){
            getJsonBody = null;
        }
        else{
            List<Country__c> CountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: sapBp.Country__c limit 1]);
            if (CountryCode.size()>0){
                countryCodeISO = CountryCode[0].Country_2__c;
                
                if(String.isNotBlank(countryCodeISO) && String.isNotBlank(sapBp.Tax_Registration_Number__c)){
                    List<Setting_Item__c> taxCodeList = new List<Setting_Item__c>();
                    
                    if(countryCodeISO.containsIgnoreCase('IN') || countryCodeISO.containsIgnoreCase('BR') || countryCodeISO.containsIgnoreCase('AU'))
                        taxCodeList = [select id , Setting__c, Text_1__c, Text_2__c, Text_3__c from Setting_Item__c  where Setting__r.Name  = 'Sap Tax Type/Code' AND Text_1__c =: countryCodeISO AND Text_3__c =: String.valueOf(sapBp.Tax_Registration_Number__c.length()) limit 1];
                    else taxCodeList = [select id , Setting__c, Text_1__c, Text_2__c, Text_3__c from Setting_Item__c  where Setting__r.Name  = 'Sap Tax Type/Code' AND Text_1__c =: countryCodeISO limit 1];
                    
                    if(taxCodeList != NULL && !taxCodeList.isEmpty()){
                        taxNumberCategory = taxCodeList.get(0).Text_2__c;
                        system.debug('taxNumberCategory '+ taxNumberCategory);
                    }
                }
            }
            
            // changes for invoice
          
            Map<String,String> mapApiMapg = new Map<String,String>();
            for(integer i =1 ; i < 8 ; i++){
                mapApiMapg.put('dynamicVar'+i, '');
            }
            List<String> listStr = new List<String>();
            // When its a account we do not need the dept fieeld in api 
            if( (String.isNotBlank( sapBp.Address_Type__c) && sapBp.Address_Type__c.containsIgnoreCase('account') && (String.isBlank(sapBp.Department__c) || sapBp.Department__c.length() <= 35 ))
               || (String.isNotBlank( sapBp.Address_Type__c) && 
                   (sapBp.Address_Type__c.containsIgnoreCase('Department') ||
                    sapBp.Address_Type__c.containsIgnoreCase('Campus') ) && deptCampName.length() <= 35 ) 
              ) 
            {
                system.debug('deptCampName-'+deptCampName);
                system.debug('sapBp.Address_Type__c-'+sapBp.Address_Type__c);
               if(String.isNotBlank(deptCampName) && (sapBp.Address_Type__c.containsIgnoreCase('Department') ||sapBp.Address_Type__c.containsIgnoreCase('Campus') ) ) mapApiMapg.put('dynamicVar1', deptCampName);
                if( String.isNotBlank(customerName) ){                    
                    listStr = splitStringBySpace(customerName,35);
                    if(!listStr.isEmpty() ){
                        integer i =2 ;
                        for(String str : listStr ){
                            mapApiMapg.put('dynamicVar'+i, str);
                            i++;
                        }
                        listStr.clear();
                    }
                }
                
                if(String.isNotBlank(sapBp.Street__c) ){                   
                    listStr = splitStringBySpace(sapBp.Street__c,35);
                    if(!listStr.isEmpty() ){
                       integer i =5 ;
                        for(String str : listStr ){
                            mapApiMapg.put('dynamicVar'+i, str);
                            i++;
                        }
                        listStr.clear();
                    }
                }                               
            }
            listStr.clear();
            // when its a campus or dept & dept name > 35 char
            if (String.isNotBlank( sapBp.Address_Type__c) && 
                (sapBp.Address_Type__c.containsIgnoreCase('Department') ||
                 sapBp.Address_Type__c.containsIgnoreCase('Campus') ) && deptCampName.length() > 35 ) 
            {               
                system.debug('more char than 35');
                if( String.isNotBlank(deptCampName) )  listStr.addAll( splitStringBySpace(deptCampName,35));
                if( String.isNotBlank(customerName) )  listStr.addAll( splitStringBySpace(customerName,35));                                
                if(String.isNotBlank(sapBp.Street__c)) listStr.addAll( splitStringBySpace(sapBp.Street__c,35));
                if(!listStr.isEmpty() ){
                    system.debug('listStr-'+listStr);
                    integer i = 1 ;
                    for( String str : listStr ){
                        if(String.isNotBlank(str)){
                            if(listStr.size()>7 && i ==7 ){
                                str = str.substring(0,str.length()-3) + '...';
                            }
                            mapApiMapg.put('dynamicVar'+i, str);
                            i++;
                        }                        
                    }
                }       
            }
            system.debug('mapApiMapg-'+mapApiMapg);
            
            
            
            
            //Shalini- Changes according to new sap component
            if( String.isNotBlank( sapBp.Address_Type__c) && (String.isBlank(deptName) || deptName.length() <= 35 ))
            {
                system.debug('less char than 35');
                if(String.isNotBlank(deptName)) mapApiMapg.put('dynamicVar1', deptName);
                                           
            }
            listStr.clear();
            // when dept name > 35 char
            if (String.isNotBlank( sapBp.Address_Type__c) && deptName.length() > 35 ) 
            {               
                system.debug('more char than 35');
                if( String.isNotBlank(deptName) )  listStr.addAll( splitStringBySpace(deptName,35));
                if( String.isNotBlank(customerName) )  listStr.addAll( splitStringBySpace(customerName,35));                                
                if(String.isNotBlank(sapBp.Street__c)) listStr.addAll( splitStringBySpace(sapBp.Street__c,35));
                if(!listStr.isEmpty() ){
                    system.debug('listStr-'+listStr);
                    integer i = 1 ;
                    for( String str : listStr ){
                        if(String.isNotBlank(str)){
                            if(listStr.size()>7 && i ==7 ){
                                str = str.substring(0,str.length()-3) + '...';
                            }
                            mapApiMapg.put('dynamicVar'+i, str);
                            i++;
                        }                        
                    }
                }       
            }
            //Shalini changes end
            
            
            
            
            
            
            getJsonBody = '{ "customers": [ { "businessPartner": { "type": "ORGANIZATION" }, "contactDetail": { "addressLine1": "'+mapApiMapg.get('dynamicVar5')+'", "addressLine2": "'+mapApiMapg.get('dynamicVar6')+'", "addressLine3": "'+mapApiMapg.get('dynamicVar7')+'", "department":"'+mapApiMapg.get('dynamicVar1')+'","careOf":"'+sapBp.Care_Of__c+'", "addressType": "'+sapBp.Address_Type__c+'", "city": "'+sapBp.City__c+'", "postalCode": "'+sapBp.ZIP__c+'", "country": "'+countryCodeISO+'", "emailAddress": "'+sapBp.Email__c+'", "title": "", "firstName": "'+sapBp.First_Name__c+'", "telephone": "", "lastName": "'+sapBp.Last_Name__c+'", "location": "", "organizationName1": "'+mapApiMapg.get('dynamicVar2')+'", "organizationName2": "'+mapApiMapg.get('dynamicVar3')+'", "organizationName3": "'+mapApiMapg.get('dynamicVar4')+'", "phoneNumber": "", "region": "'+sapBp.State__c+'" }, "externalCustomerAddressId": "'+sapBp.SAddress_RRAdd_ID__c+'", "sourceSystemId": "TF-EBOOK", "taxRegistrationNumber": "'+taxRegistrationNumber+'", "taxType": "'+taxNumberCategory+'" } ] }';
            system.debug('body'+getJsonBody);
        }
        return getJsonBody;
    }
    
    
    
    public static List<String> splitStringBySpace(String str , integer charLimit){
        //string str = 'Returns a new String that begins with the character at the specified zero-based startIndex and extends to the character at endIndex - 1';
        List<String> listStr = new List<String>(); 
        string strSplit1 ='';
        string strSplit2 ='';
        string strSplit3 ='';
        system.debug('str-'+str);
        integer strLength = str.length();
        system.debug('strLength-'+strLength);
        string restStr ='';
        if(String.isNotBlank(str)){     
            
            // process for 1st variable
            if(str.length() <= charLimit){
                strSplit1 = str;
                system.debug('strSplit1-'+strSplit1);
            }
            if (str.length() > charLimit){
                strSplit1  = str.substring(0,charLimit).substringBeforeLast(' ');  // till 39th char 
                restStr =  str.substring((strSplit1.length()) ,strLength);
                system.debug('strSplit1-'+strSplit1+' size-'+strSplit1.length());
                system.debug('restStr-'+restStr);
            }
            // process for 2nd variable
            if(restStr.length() <= charLimit && String.isNotBlank(restStr)){
                strSplit2  = restStr;
                restStr = ''; // no string left to process
                system.debug('strSplit2-'+strSplit2+' size-'+strSplit2.length());
                system.debug('restStr-'+restStr);
            }
            if(restStr.length() > charLimit && String.isNotBlank(restStr)){
                strSplit2  = restStr.substring(0,charLimit).substringBeforeLast(' ');  // till 39th char 
                restStr =  restStr.substring((strSplit2.length() ),restStr.length());
                system.debug('strSplit2-'+strSplit2+' size-'+strSplit2.length());
                system.debug('restStr-'+restStr);
            }
            //  No need to process for 3rd variable
            strSplit3  = restStr;
            if(strSplit3.length()>charLimit) {
                strSplit3 = strSplit3.substring(0,charLimit-3) + '...';
            }
            system.debug('strSplit3-'+strSplit3+' size-'+strSplit3.length());
            system.debug('restStr-'+restStr);
        }
        
        if(String.isNotBlank(strSplit1)) listStr.add(strSplit1.trim());
        if(String.isNotBlank(strSplit2)) listStr.add(strSplit2.trim());
        if(String.isNotBlank(strSplit3)) listStr.add(strSplit3.trim());
        system.debug('listStr-'+listStr);
        return listStr;
    }
    
    
    
    public static void splitStringDeptOrCamp(String deptCampName , String custName , String Street){
        map<String, string> mapPayloadValue = new map<String, string>();
        //mapPayloadValue.put('',);        
        if(deptCampName.length() > 35 ){
            
        }           
    }
    
}