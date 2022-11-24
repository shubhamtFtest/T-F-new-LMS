/*
* Test Class: zTest_TF_AddressVerification
* Description : Address verification of SAP BP by calling SAP API
* Created by Piyush Jain
*/

public class TF_AddressVerification implements TriggerInterface_Opp.Runnable{
    
    Private static Boolean retryAddressVerification = false;
    private static boolean run1 = true;
    private static List<SAP_BP__c> sapBpListAlreadyVerified = new List<SAP_BP__c>();
    private static List<SAP_BP__c> finalSapBpList  = new List<SAP_BP__c>();
    private static Map<String, String> sendEmailMsgToResBodyMap = new Map<String, String>();
    public class SAP_BP_Response {
        public Metadata metadata;
    }
    
    public class Metadata {
        public Integer code;
        public String timestamp;
        public String details;
    }
    
    public class SAP_BP_Error_Response {
        public Metadata metadata;
        public Object data;
    }
    
    public static boolean runOnce1(){
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        }
    }
    
    public class addressVerificationWrapperClass{
        @AuraEnabled
        public List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
        @AuraEnabled
        public List<opportunity> oppUpdate = new List<opportunity>();
        @AuraEnabled
        public Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
    }
    
    public void run(TriggerInterface_Opp.Trig trig){
        Map<String, Id> sapIdToLookupMap = new Map<String, Id>();
        Set<Id> sapBpIdSet = new Set<Id>();
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        List<Opportunity> opportunityDetails = new List<Opportunity>();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Id BPCoppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
        Id oppOARecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F OA Journal Opportunity').getRecordTypeId();
        
        if(runOnce1()){
            if(trig.isAfter && trig.isUpdate){
                for(Opportunity opp : trig.newList ){
                    opportunityDetails = [select Account.Name, id, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c,recordTypeId, Bill_to_BP__c, Ship_to_BP__c, Ship_to_BP__r.Message__c, Ship_to_BP__r.Name, Bill_to_BP__r.Name, Bill_to_BP__r.Message__c from Opportunity where id =: opp.id];
                    if(!opportunityDetails.isEmpty()){
                       
                        if((opportunityDetails.get(0).recordTypeId == oppRecordTypeId) || (opportunityDetails.get(0).recordTypeId == BPCoppRecordTypeId) || (opportunityDetails.get(0).recordTypeId == oppOARecordTypeId)){
                            if(String.isNotBlank(opportunityDetails.get(0).Bill_to_BP__r.Name)){
                                if(String.isNotBlank(opportunityDetails.get(0).Bill_to_BP__r.Message__c)){
                                    if(!opportunityDetails.get(0).Bill_to_BP__r.Message__c.containsIgnoreCase('Address Verified')){
                                        //sapIdToLookupMap.put('Bill to', opportunityDetails.get(0).Bill_to_BP__c);
                                        sapBpIdSet.add(opportunityDetails.get(0).Bill_to_BP__c);
                                    }
                                }else{
                                    //sapIdToLookupMap.put('Bill to', opportunityDetails.get(0).Bill_to_BP__c);
                                    sapBpIdSet.add(opportunityDetails.get(0).Bill_to_BP__c);
                                }
                                sapIdToLookupMap.put('Bill to', opportunityDetails.get(0).Bill_to_BP__c);
                            }
                            if(String.isNotBlank(opportunityDetails.get(0).Ship_to_BP__r.Name)){
                                if(String.isNotBlank(opportunityDetails.get(0).Ship_to_BP__r.Message__c)){
                                    if(!opportunityDetails.get(0).Ship_to_BP__r.Message__c.containsIgnoreCase('Address Verified')){
                                        //sapIdToLookupMap.put('Ship to', opportunityDetails.get(0).Ship_to_BP__c);
                                        sapBpIdSet.add(opportunityDetails.get(0).Ship_to_BP__c);
                                    }
                                }else{
                                    //sapIdToLookupMap.put('Ship to', opportunityDetails.get(0).Ship_to_BP__c);
                                    sapBpIdSet.add(opportunityDetails.get(0).Ship_to_BP__c);
                                } 
                                sapIdToLookupMap.put('Ship to', opportunityDetails.get(0).Ship_to_BP__c);
                            }
                            if(!system.isFuture()){
                                if(!sapBpIdSet.isEmpty()) sap_Bp_AddressCallout(sapBpIdSet, opportunityDetails.get(0).id, sapIdToLookupMap);
                                //else updateOppMessageField(null, opportunityDetails.get(0).id, sapIdToLookupMap, false);
                            } 
                        }
                    }
                }
            }
        }
    }
    
    //We used future method because we are doing callout in trigger
    @Future(callout=true)
    public static void sap_Bp_AddressCallout(Set<Id> sapBPIdsSet, id opportunityId, Map<String, Id> sapIdToLookupMap){
        system.debug(sapBPIdsSet);
        system.debug('oppUpdateAddressVerificationInFuture');
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        
        sapBpList= [ SELECT Id, Has_Valid_BP__c,SAddress_RRAdd_ID__c, Name, Message__c, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c FROM SAP_BP__c WHERE Id IN: sapBPIdsSet ];
        //In this method we are doing callout
        verifySapBpAddress(sapBpList, opportunityId, SapIdToLookupMap);
    }
    
    //We are calling this method in case of retry address verification
    public static addressVerificationWrapperClass retryAddressVerification(Opportunity oppotunityData, List<SAP_BP__c> passSapBpsList){
        system.debug('oppUpdateAddressVerificationWithoutFuture');
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Id BPCoppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
        Id oppOARecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F OA Journal Opportunity').getRecordTypeId();
        TF_AddressVerification.runOnce1();
        Map<String, Id> sapIdToLookupMap = new Map<String, Id>();
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        List<Opportunity> opportunityDetails = new List<Opportunity>();
        retryAddressVerification = true;
        SAP_BP__c sapBillTo;
        SAP_BP__c sapShipTo;
        system.debug('passSapBpsList '+passSapBpsList.size());
        
        opportunityDetails = [select Account.Name, Order_Status__c, id, recordTypeId, Bill_to_BP__c, Ship_to_BP__c, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Name, Ship_to_BP__r.Message__c, Bill_to_BP__r.Name, Bill_to_BP__r.Message__c from Opportunity where id =: oppotunityData.id];
        if(!opportunityDetails.isEmpty()){
            if((opportunityDetails.get(0).recordTypeId == oppRecordTypeId) || (opportunityDetails.get(0).recordTypeId == BPCoppRecordTypeId) || (opportunityDetails.get(0).recordTypeId == oppOARecordTypeId)){
                // fetching the bill to  & ship to  sap bp from the list
                if(!passSapBpsList.isEmpty() && passSapBpsList != NULL){
                    for (SAP_BP__c sapObj  : passSapBpsList) {
                        if( opportunityDetails.get(0).Bill_to_BP__c != NULL && opportunityDetails.get(0).Ship_to_BP__c != NULL && sapObj.id == opportunityDetails.get(0).Bill_to_BP__c && sapObj.id == opportunityDetails.get(0).Ship_to_BP__c){
                            sapBillTo = sapObj;
                            if(String.isNotBlank(sapBillTo.Message__c)){
                                if(!sapBillTo.Message__c.containsIgnoreCase('Address Verified')){
                                    sapBpList.add(sapBillTo);
                                }else{
                                    sapBpListAlreadyVerified.add(sapBillTo);
                                }
                            }
                            else sapBpList.add(sapBillTo);
                            sapIdToLookupMap.put('Bill to', sapBillTo.id);
                        }
                        else{
                            if (opportunityDetails.get(0).Bill_to_BP__c != NULL && sapObj.id == opportunityDetails.get(0).Bill_to_BP__c){
                                sapBillTo = sapObj;
                                if(String.isNotBlank(sapBillTo.Message__c)){
                                    if(!sapBillTo.Message__c.containsIgnoreCase('Address Verified')){
                                        sapBpList.add(sapBillTo);
                                    }else{
                                        sapBpListAlreadyVerified.add(sapBillTo);
                                    }
                                }
                                else sapBpList.add(sapBillTo);
                                sapIdToLookupMap.put('Bill to', sapBillTo.id);
                            }
                            if (opportunityDetails.get(0).Ship_to_BP__c != NULL && sapObj.id == opportunityDetails.get(0).Ship_to_BP__c){
                                sapShipTo = sapObj;
                                if(String.isNotBlank(sapShipTo.Message__c)){
                                    if(!sapShipTo.Message__c.containsIgnoreCase('Address Verified')){
                                        sapBpList.add(sapShipTo);
                                    }else{
                                        sapBpListAlreadyVerified.add(sapShipTo);
                                    }
                                }
                                else sapBpList.add(sapShipTo);
                                sapIdToLookupMap.put('Ship to', sapShipTo.id);
                            }
                        }
                    }
                }
            }
            if(!sapBpListAlreadyVerified.isEmpty() && sapBpListAlreadyVerified != NULL) finalSapBpList.addAll(sapBpListAlreadyVerified);
            
            if(!sapBpList.isEmpty() && sapBpList != NULL) return verifySapBpAddress(sapBpList, opportunityDetails.get(0).id, sapIdToLookupMap);
            else return updateOppMessageField(passSapBpsList, opportunityDetails.get(0).id, sapIdToLookupMap, true);
        }
        return null;
    }
    
    //IF SAP BP address body is not null then we make callout using platform excecuter class
    Public static addressVerificationWrapperClass verifySapBpAddress(List<SAP_BP__c> SapBpList, id opportunityId, Map<String, Id> SapIdToLookupMap){
        system.debug('verifySapBpAddress');
        addressVerificationWrapperClass addressVerificationWrapperClassObj = new addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = new Map<String, Id>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = SapIdToLookupMap;
        Map<Id, String> sapIdToBodyMap = new Map<Id, String>();
        List<SAP_BP__c> updateSapBpList = new List<SAP_BP__c>();
        List<String> messageList = new List<String>();
        
        //Get uri from custom settings
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        String methodType = 'POST';
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        if (!SapBpList.isEmpty() && SapBpList != NULL){
            for (SAP_BP__c sapBp : SapBpList){
                //If id's of bill to bp and ship to bp is similar to each other then remove ship to from map
                if(SapIdToLookupMap.containsKey('Bill to') && SapIdToLookupMap.containsKey('Ship to') && SapIdToLookupMap.get('Bill to') == sapBp.id && SapIdToLookupMap.get('Ship to') == sapBp.id)
                    SapIdToLookupMap.remove('Ship to');
                
                try{
                HttpResponse res = new HttpResponse();
                String body = getBody(sapBp); //Get address body in form of JSON from Sap Bp
                
                if(body != null){
                    sapIdToBodyMap.put(sapBp.id, body);
                    if(sapIdToBodyMap.containsKey(sapBp.id)){
                        res = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);//Call platform executer class to hit API 
                        //res.setBody('{ "metadata": { "code": 400, "timestamp": "2019.12.11.11.17.55.190", "details": "Validation failure; dummy response" }, "data": null }');
                  //res.setStatusCode(400);
                    }   
                    system.debug('&&&&&&'+res.getStatusCode());
                    system.debug('res.getbody() '+res.getbody());
                    //If status code is 200 then update the message field of sap bp and opportunity
                    if(res != NULL && res.getStatusCode() == 200){
                        //Get response                                    
                        SAP_BP_Response SAP_BP_Res = (SAP_BP_Response)JSON.deserialize(res.getBody(), SAP_BP_Response.class);
                        system.debug(SAP_BP_Res);
                        
                        if(String.isNotBlank(sapBp.Message__c)){
                            Map<integer,String> mapIndexValue = new Map<integer,String>();
                            Integer j = 0;
                            messageList = sapBp.Message__c.split('~msg~');
                            for(String msgStr : messageList){
                                if (msgStr!=NULL && msgStr.containsIgnoreCase('Address Not Verified') ) {
                                    // overwrite string 
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            mapIndexValue.put( j , ' Bill to: Address Verified' + ' ' );  
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            mapIndexValue.put( j , ' Ship to: Address Verified' + ' ' );                          
                                        }
                                    } 
                                }
                                j++;
                            }
                            if(SapIdToLookupMap.containsKey('Bill to')){
                                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Bill to: Address Verified' + ' ' );
                                }
                            }
                            if(SapIdToLookupMap.containsKey('Ship to')){
                                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Ship to: Address Verified' + ' ' );
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
                                    //sapBp.Message__c = 'Bill to: Address Verified' ;
                                    String messageValue = ' Bill to: Address Verified';
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
                                    //sapBp.Message__c = 'Ship to: Address Verified' ;
                                    String messageValue = ' Ship to: Address Verified' ; 
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
                        //Here we are mapping the message field value when status code is other than 200
                        //Deserialize JSON and update error message field on SAP BP object
                        SAP_BP_Error_Response SAP_BP_Error_Res = (SAP_BP_Error_Response)JSON.deserialize(res.getBody(), SAP_BP_Error_Response.class);
                        system.debug(SAP_BP_Error_Res);
                        
                        //If message field is not blank 
                        if(String.isNotBlank(sapBp.Message__c)){
                            Map<integer,String> mapIndexValue = new Map<integer,String>();
                            Integer j = 0;
                            messageList = sapBp.Message__c.split('~msg~');
                            for(String msgStr : messageList){
                                if (msgStr!=NULL && (msgStr.containsIgnoreCase('Address Verified') || msgStr.containsIgnoreCase('Address Not Verified'))) {
                                    // overwrite string 
                                    if(SapIdToLookupMap.containsKey('Bill to')){
                                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                            mapIndexValue.put( j , ' Bill to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' );  
                                        }
                                    }
                                    if(SapIdToLookupMap.containsKey('Ship to')){
                                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                            mapIndexValue.put( j , ' Ship to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' );                          
                                        }
                                    }
                                }
                                j++;
                            }
                            if(SapIdToLookupMap.containsKey('Bill to')){
                                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Bill to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ');
                                }
                            }
                            if(SapIdToLookupMap.containsKey('Ship to')){
                                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Ship to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ');
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
                            //If message field is is blank then update message
                            if(SapIdToLookupMap.containsKey('Bill to')){
                                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                    //sapBp.Message__c = ' Bill to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
                                    String messageValue = ' Bill to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
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
                                    //sapBp.Message__c = ' Ship to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
                                    String messageValue = ' Ship to: Address Not Verified, ' +SAP_BP_Error_Res.Metadata.details + ' ' ;
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
                    //Adding in a map for email send in case of error in address verification     
                    sendEmailMsgToResBodyMap.put('Sap Id: '+sapBp.id+' on Opportunity Id: '+opportunityId+' Address Not Verified, '+SAP_BP_Error_Res.Metadata.details , res.getBody());
                    }
                }else{
                    //When all address fields are empty then update the message field without doing callout
                    if(String.isNotBlank(sapBp.Message__c)){
                        Map<integer,String> mapIndexValue = new Map<integer,String>();
                        Integer j = 0;
                        messageList = sapBp.Message__c.split('~msg~');
                        for(String msgStr : messageList){
                            if (msgStr!=NULL && (msgStr.containsIgnoreCase('Address Verified') || msgStr.containsIgnoreCase('Address Not Verified'))) {
                                // overwrite string 
                                if(SapIdToLookupMap.containsKey('Bill to')){
                                    if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                        mapIndexValue.put( j , ' Bill to: Address Not Verified, All address fields are empty' );  
                                    }
                                }
                                if(SapIdToLookupMap.containsKey('Ship to')){
                                    if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                        mapIndexValue.put( j , ' Ship to: Address Not Verified, All address fields are empty' );                          
                                    }
                                } 
                            }
                            j++;
                        }
                        if(SapIdToLookupMap.containsKey('Bill to')){
                            if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                                if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Bill to: Address Not Verified, All address fields are empty');
                            }
                        }
                        if(SapIdToLookupMap.containsKey('Ship to')){
                            if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                                if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Ship to: Address Not Verified, All address fields are empty');
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
                                //sapBp.Message__c = ' Bill to: Address Not Verified, All address fields are empty' ;
                                String messageValue = ' Bill to: Address Not Verified, All address fields are empty' ;
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
                                //sapBp.Message__c = ' Ship to: Address Not Verified, All address fields are empty' ;
                                String messageValue = ' Ship to: Address Not Verified, All address fields are empty' ;
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
                    sendEmailMsgToResBodyMap.put('Sap Id: '+sapBp.id+' on Opportunity Id: '+opportunityId+' Address Not Verified, All address fields are empty', '');//Adding in a map for email send in case of error in address verification 
                }
                //add sap bp in a list to update
                updateSapBpList.add(sapBp);
                }catch(Exception ex){
                    System.debug('*********** Address Verification Callout Exception :' + ex.getMessage() +'****'+ ex.getLineNumber());
                    SAP_BP__c sap = new SAP_BP__c();
                    sap = updateOppMessageExcp(sapBp, ex.getMessage(), SapIdToLookupMap, opportunityId);
                    UpdateSapBpList.add(sap);
                } 
            }
        }
        
        //If list is not empty then update message field
        if(!UpdateSapBpList.isEmpty()){
            try{
                if(!retryAddressVerification) update updateSapBpList;system.debug('updateSapBpList '+updateSapBpList);
                //Get error message from SAP BP's error message field and update value in opportunity's error message field
                String errorMessageOnOpp = '';
                
                List<Opportunity> oppUpdate = new List<Opportunity>([SELECT id, Account.Name, Order_Status__c, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c,Ship_to_BP__r.Name,Bill_to_BP__r.Name,Ship_to_BP__r.Message__c,Bill_to_BP__r.Message__c,RecordTypeId,Message__c,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c, Ship_to_BP__r.Email__c, Ship_to_BP__r.First_Name__c, Ship_to_BP__r.Last_Name__c, Ship_to_BP__r.Country__c, Ship_to_BP__r.Region__c, Ship_to_BP__r.State__c, Ship_to_BP__r.Street__c, Ship_to_BP__r.ZIP__c, Ship_to_BP__r.City__c FROM opportunity WHERE  id =: opportunityId LIMIT 1]);
                if(!oppUpdate.isEmpty()){
                    if(!retryAddressVerification){
                        system.debug('Before oppUpdate '+oppUpdate.get(0).Message__c);
                        if(String.isNotBlank(oppUpdate.get(0).Bill_to_BP__r.Message__c)){
                            //Doing changes for proper message field
                            if(oppUpdate.get(0).Bill_to_BP__r.Message__c.containsIgnoreCase('Ship to')){
                                errorMessageOnOpp += oppUpdate.get(0).Bill_to_BP__r.Message__c.replace('Ship to', 'Bill to') + ' ~msg~ ';
                            }
                            else errorMessageOnOpp += oppUpdate.get(0).Bill_to_BP__r.Message__c + ' ~msg~ ';
                        }
                        if(String.isNotBlank(oppUpdate.get(0).Ship_to_BP__r.Message__c)){
                            //Doing changes for proper message field
                            if(oppUpdate.get(0).Ship_to_BP__r.Message__c.containsIgnoreCase('Bill to')){
                                errorMessageOnOpp += oppUpdate.get(0).Ship_to_BP__r.Message__c.replace('Bill to', 'Ship to') + ' ~msg~ ';
                            }
                            else errorMessageOnOpp += oppUpdate.get(0).Ship_to_BP__r.Message__c + ' ~msg~ ';
                        }
                        errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
                        Integer maxSize = 65536;
                        if(errorMessageOnOpp.length() > maxSize ){
                            errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
                            oppUpdate.get(0).Message__c = errorMessageOnOpp;
                        }else{
                            oppUpdate.get(0).Message__c = errorMessageOnOpp;
                        }
                        system.debug('After oppUpdate '+oppUpdate.get(0).Message__c);
                        update oppUpdate;
                    }
                    else{
                        finalSapBpList.addAll(updateSapBpList);
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
                        system.debug('Old oppUpdate.get(0).Message__c '+  oppUpdate.get(0).Message__c);
                        errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
                        //oppUpdate.get(0).Message__c = errorMessageOnOpp;
                        Integer maxSize = 65536;
                        if(errorMessageOnOpp.length() > maxSize ){
                            errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
                            oppUpdate.get(0).Message__c = errorMessageOnOpp;
                        }else{
                            oppUpdate.get(0).Message__c = errorMessageOnOpp;
                        }
                        system.debug('New oppUpdate.get(0).Message__c '+  oppUpdate.get(0).Message__c);
                        addressVerificationWrapperClassObj.oppUpdate.addAll(oppUpdate);
                        addressVerificationWrapperClassObj.updateSapBpList.addAll(finalSapBpList);
                    }
                    //Send email in case of error
                    if(sendEmailMsgToResBodyMap != NULL && !sendEmailMsgToResBodyMap.isEmpty()){
                        system.debug('sendEmailMsgToResBodyMap '+sendEmailMsgToResBodyMap);
            for(String errorMessage: sendEmailMsgToResBodyMap.keySet()){
                            sendEmail(errorMessage, sendEmailMsgToResBodyMap.get(errorMessage));
                        }                        
                    }
                }
                return addressVerificationWrapperClassObj;
            }catch(Exception ex){
                System.debug('*********** Update Address Verification Exception :' + ex.getMessage() +'****'+ ex.getLineNumber());
            }
        }
        return addressVerificationWrapperClassObj;
    }   
    
    
    public static SAP_BP__c updateOppMessageExcp(SAP_BP__c sapBp, String exceptionMessage, Map<String, Id> SapIdToLookupMap, String opportunityId){
        system.debug('InExceptionUdateMethod');
        String errorMessageOnOpp = ''; 
        //List<SAP_BP__c> UpdateSapBpList = new List<SAP_BP__c>();
        List<String> messageList = new List<String>();
        addressVerificationWrapperClass addressVerificationWrapperClassObj = new addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = new Map<String, Id>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = SapIdToLookupMap;
        
        //When all address fields are empty then update the message field without doing callout
        if(String.isNotBlank(sapBp.Message__c)){
            Map<integer,String> mapIndexValue = new Map<integer,String>();
            Integer j = 0;
            messageList = sapBp.Message__c.split('~msg~');
            for(String msgStr : messageList){
                if (msgStr!=NULL && (msgStr.containsIgnoreCase('Address Verified') || msgStr.containsIgnoreCase('Address Not Verified'))) {
                    // overwrite string 
                    if(SapIdToLookupMap.containsKey('Bill to')){
                        if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                            mapIndexValue.put( j , ' Bill to: Address Not Verified, ' +exceptionMessage);  
                        }
                    }
                    if(SapIdToLookupMap.containsKey('Ship to')){
                        if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                            mapIndexValue.put( j , ' Ship to: Address Not Verified, '+exceptionMessage );                          
                        }
                    } 
                }
                j++;
            }
            if(SapIdToLookupMap.containsKey('Bill to')){
                if(SapIdToLookupMap.get('Bill to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Bill to: Address Not Verified, '+exceptionMessage);
                }
            }
            if(SapIdToLookupMap.containsKey('Ship to')){
                if(SapIdToLookupMap.get('Ship to') == sapBp.id){
                    if(!sapBp.Message__c.containsIgnoreCase('Verified')) messageList.add(' Ship to: Address Not Verified, '+exceptionMessage);
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
                    //sapBp.Message__c = ' Bill to: Address Not Verified, All address fields are empty' ;
                    String messageValue = ' Bill to: Address Not Verified, '+exceptionMessage ;
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
                    //sapBp.Message__c = ' Ship to: Address Not Verified, All address fields are empty' ;
                    String messageValue = ' Ship to: Address Not Verified, '+exceptionMessage;
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
        sendEmailMsgToResBodyMap.put('Sap Id: '+sapBp.id+' on Opportunity Id: '+opportunityId+' Address Not Verified, '+exceptionMessage, '');//Adding in a map for email send in case of error in address verification 
        return sapBp;
    }
    
    public static addressVerificationWrapperClass updateOppMessageField(List<SAP_BP__c> passSapBpsList, String opportunityId, Map<String, Id> SapIdToLookupMap, Boolean isRetry){
        system.debug('updateOppMessageField');
        system.debug('isRetry '+isRetry);
        addressVerificationWrapperClass addressVerificationWrapperClassObj = new addressVerificationWrapperClass();
        addressVerificationWrapperClassObj.updateSapBpList = new List<SAP_BP__c>();
        addressVerificationWrapperClassObj.oppUpdate = new List<Opportunity>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = new Map<String, Id>();
        addressVerificationWrapperClassObj.SapIdToLookupMap = SapIdToLookupMap;
        List<Id> sapBpIdsSet = new List<Id>();
        
        List<Opportunity> oppUpdate = new List<Opportunity>([SELECT Account.Name, Order_Status__c, id, Bill_to_BP__r.Has_Valid_BP__c, Ship_to_BP__r.Has_Valid_BP__c,Ship_to_BP__r.Name,Bill_to_BP__r.Name,Ship_to_BP__r.Message__c,Bill_to_BP__r.Message__c,RecordTypeId,Message__c,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c FROM opportunity WHERE  id =: opportunityId LIMIT 1]);
        if(!oppUpdate.isEmpty() && oppUpdate != NULL){
            if(!isRetry){
                if(oppUpdate.get(0).Bill_to_BP__c != NULL) sapBpIdsSet.add(oppUpdate.get(0).Bill_to_BP__c);
                if(oppUpdate.get(0).Ship_to_BP__c != NULL) sapBpIdsSet.add(oppUpdate.get(0).Ship_to_BP__c);
                system.debug('sapBpIdsSet '+sapBpIdsSet);
                passSapBpsList = [ SELECT Id,Care_Of__c, Department__c, Campus_Id__c,Department_Id__c,Account_Id__c, Tax_Number_Category__c, Tax_Registration_Number__c,Has_Valid_BP__c, SAddress_RRAdd_ID__c, Name, Message__c, Address_ID__c, CurrencyIsoCode, City__c, Country__c, State__c, Street__c, ZIP__c, Region__c, First_Name__c, Last_Name__c, Email__c, BP__c, Status__c, Address_Type__c FROM SAP_BP__c WHERE Id IN: sapBpIdsSet ];
            }
            if(passSapBpsList != NULL && !passSapBpsList.isEmpty()){
                addressVerificationWrapperClassObj.updateSapBpList.addAll(passSapBpsList);
                String errorMessageOnOpp ='';
                for(SAP_BP__c sapBpMessage : passSapBpsList){
                    //Doing changes for proper message field
                    if(SapIdToLookupMap.containsKey('Bill to')){
                        if(SapIdToLookupMap.get('Bill to') == sapBpMessage.id){
                            if(sapBpMessage.Message__c.containsIgnoreCase('Ship to')){
                                sapBpMessage.Message__c = sapBpMessage.Message__c.replace('Ship to', 'Bill to');
                            } 
                        }
                    }
                    if(SapIdToLookupMap.containsKey('Ship to')){
                        if(SapIdToLookupMap.get('Ship to') == sapBpMessage.id){
                            if(sapBpMessage.Message__c.containsIgnoreCase('Bill to')){
                                sapBpMessage.Message__c = sapBpMessage.Message__c.replace('Bill to', 'Ship to');
                            } 
                        }
                    }
                    errorMessageOnOpp += sapBpMessage.Message__c + ' ~msg~ ';
                }
                system.debug('Old oppUpdate.get(0).Message__c '+  oppUpdate.get(0).Message__c);
                errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
                Integer maxSize = 65536;
                if(errorMessageOnOpp.length() > maxSize ){
                    errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
                    oppUpdate.get(0).Message__c = errorMessageOnOpp;
                }else{
                    oppUpdate.get(0).Message__c = errorMessageOnOpp;
                }
                system.debug('After oppUpdate.get(0).Message__c '+  oppUpdate.get(0).Message__c);
                if(!isRetry) update oppUpdate;
            }
            addressVerificationWrapperClassObj.oppUpdate.addAll(oppUpdate);
            return addressVerificationWrapperClassObj;
        }
        return addressVerificationWrapperClassObj;
    }
    
    //Get body from sap bp record
    public static String getBody(SAP_BP__c sapBp){
        system.debug('getBody');
        String getJsonBody;
        String countryCodeISO;
        
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
        if(sapBp.Country__c == '' && sapBp.State__c == '' && sapBp.Street__c == '' && sapBp.ZIP__c == '' && sapBp.City__c == '' && sapBp.Region__c == ''){
            //If all address fields are empty then return body null
            getJsonBody = null;
        }
        else{
            //Find ISO code of country 
            List<Country__c> CountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: sapBp.Country__c limit 1]);
            if (CountryCode.size()>0){
                countryCodeISO = CountryCode[0].Country_2__c; 
            }
            getJsonBody = '{ "address": { "address1": "'+sapBp.Street__c+'", "address2": "", "city": "'+sapBp.City__c+'","country": "'+countryCodeISO+'", "department": "", "faxNumber": "", "organization": "'+sapBp.Name+'", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+sapBp.ZIP__c+'", "region": "'+sapBp.State__c+'" }, "customer": { "email": "'+sapBp.Email__c+'" }, "person": { "firstName": "'+sapBp.First_Name__c+'", "lastName": "'+sapBp.Last_Name__c+'", "title": "" }, "sourceSystemId": "TF-EBOOK" }';
            
        }
        system.debug(getJsonBody);
        return getJsonBody;
    }
    
    
    public static void sendEmail(String errorMessage, String errorHttpResponse)
    {
        system.debug('inside sendEmail method'); 
        system.debug('errorHttpResponse '+errorHttpResponse);
        Direct_sales_order_settings__c directSalesSettings = Direct_sales_order_settings__c.getOrgDefaults();    
            
        if ( directSalesSettings!= NULL && directSalesSettings.Send_emails_on_failure__c == true  && String.isNotBlank( directSalesSettings.Alert_Email_Addresses__c ) ) {
            System.debug('sending email errorMessage'+errorMessage);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> lstEmail = directSalesSettings.Alert_Email_Addresses__c.split(',');
            mail.setToAddresses(lstEmail);
            mail.setSenderDisplayName('Direct Sales Process Error');
            String sub = ''+String.valueOf(UserInfo.getUserName().substringAfterLast('.')) + ' ' ;
            Datetime myDT = Datetime.now();
            mail.setSubject(sub.toUpperCase()+'Direct Sales Process Error : '+ String.valueOf(myDT)  );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('JSON Response');
            If( String.isBlank(errorHttpResponse) ) errorHttpResponse = 'No response data available';
            efa.setBody(Blob.valueOf((errorHttpResponse)));
            // Attach file using setFileAttachments function
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            mail.setHtmlBody(' Hello, <br/>  Addresss verification process has failed. For more Information, please refer to the response  provided  in attachment <br/> <br/> Error :- '+ errorMessage );
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(exception e) {
                if(e!= NULL) System.debug(' ******** Exception : ' + e.getMessage());
                System.debug('sendEmail() ****'+e);
            }
        }
    }
    
    
}