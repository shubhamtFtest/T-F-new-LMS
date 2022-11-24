/**
* Author : Sourabh Goyal   
* Detail : This class is used to create a new SAP BP. 
* Test class : TF_SAP_BP_VerificationTest 
*/ 
public class TF_SAP_BP_Verification {
    public static string partyId;
    
    public TF_SAP_BP_Verification(string RecordId){
        partyId=[select id,Customer_Id__c from account where id=:RecordId].Customer_Id__c;
        system.debug('partyId'+partyId);
    }
    
    public class SAP_BP_Response {
        public Metadata metadata;
        public String data;
    }
    public class Metadata {
        public String status;
        public string details;
    }
    public class SapbpWrapper{
        public String RecordId {get;set;}
        public String Country {get;set;}
        public String AddressLine1 {get;set;}
        public String AddressLine2 {get;set;}
        public String AddressLine3 {get;set;}
        public String PostalCode {get;set;}
        public String Phone {get;set;}
        public String State {get;set;}
        public String City {get;set;}
        public String emailAddress {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        
    }
    
    
    /**
* VerifyAddressController description :  the method will search for the exact Bp match then will return the name of the Sap Bp if matched.
* @param  SapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  May be a success  message .
**/ 
    @AuraEnabled
    public static String VerifyAddressController(object SapBp){
        SapbpWrapper SapObj = (SapbpWrapper)JSON.deserialize(JSON.serialize(SapBp), SapbpWrapper.class);
        TF_SAP_BP_Verification RecordId= new TF_SAP_BP_Verification(SapObj.RecordId);
        system.debug('partyId'+partyId);
        try {     
            if(partyId!=Null || partyId==''){
                System.debug(' VerifyAddressController called ');
                Boolean matchFound = false ; 
                String matchedSapBpObj ;
                
                for ( SAP_BP__c spBpObj  :[select name,Street__c,City__c,State__c,Country__c,ZIP__c,Email__c,First_Name__c,Last_Name__c from SAP_BP__c where Account_Party_ID__c=:partyId]) {
                    
                    if ( spBpObj.Street__c == SapObj.AddressLine1  && 
                        spBpObj.City__c == SapObj.City &&                             
                        spBpObj.State__c == SapObj.State  &&
                        spBpObj.Country__c == SapObj.Country &&
                        spBpObj.ZIP__c == SapObj.PostalCode &&
                        spBpObj.Email__c == SapObj.emailAddress &&
                        spBpObj.First_Name__c == SapObj.FirstName &&
                        spBpObj.Last_Name__c == SapObj.LastName){
                            matchFound  = true ; 
                            matchedSapBpObj = spBpObj.Name;
                            break;                            
                        }                                                                                                            
                }
                System.debug('matchedSapBpObj'+matchedSapBpObj);
                return matchedSapBpObj;
            }  
            return 'Party Id is not associated with this Account!!';
        }
        catch (Exception e ) {
            throw new AuraHandledException('Something went wrong: ' + e.getMessage());   
            
        }      
    }
    /**
* shippingAddressVerify description :  the method will do the callout to check if the address is valid for SAP BP .
* @param  SapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  If address is valid returns 200 if invalid returns the error string.
**/   
    @AuraEnabled
    Public static string shippingAddressVerify(Object sapBp){
        SapbpWrapper SapObj = (SapbpWrapper)JSON.deserialize(JSON.serialize(SapBp), SapbpWrapper.class);
        System.debug('Address verify '+sapBp+'____'+SapObj);
        String body;
        String statusbody;
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('Verify_Addrress_Endpoint__c');
        system.debug('uri'+uri);
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            if(sapBp != NULL) body = getShippingBody(SapObj);
            if(body != Null){
                HttpResponse res = new HttpResponse();
                if ( String.isNotBlank(uri) ) {
                    
                    res = TF_PlatformExecuter.execute( uri, 'POST', 'idtoken', body, headers, false );
                    system.debug('res=========>'+res);
                }
                system.debug('res=========>'+res);
                SAP_BP_Response SAP_BP_Res = (SAP_BP_Response)JSON.deserialize(res.getBody(), SAP_BP_Response.class);
                system.debug('SAP_BP_Res'+SAP_BP_Res.metadata.details);
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                system.debug(res.getStatusCode());
                statusbody = String.ValueOf(res.getBody());
                
                if(res.getStatusCode() == 200){
                    statusbody = String.ValueOf( res.getStatusCode());
                }
                else{
                    statusbody = SAP_BP_Res.metadata.details;
                    //statusbody = String.ValueOf( res.getStatusCode());
                }
                
            }
            
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
        }
        return statusbody;
    }
    
    
    /**
* setBpNumber description :  the method will do the callout to check if the address is valid for SAP BP .
* @param  SapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  If address is valid returns 200 if invalid returns the error string.
**/ 
    @AuraEnabled
    public static String getShippingBody(SapbpWrapper sapBp){
        String getAddressBody;
        String countryISOCode;
        
        if(String.isBlank(sapBp.AddressLine1)){
            sapBp.AddressLine1 = ''; 
        }
        if(String.isBlank(sapBp.AddressLine2)){
            sapBp.AddressLine2 = '';
        }
        if(String.isBlank(sapBp.PostalCode)){
            sapBp.PostalCode = '';
        }
        if(String.isBlank(sapBp.State)){
            sapBp.State = '';
        }
        if(String.isBlank(sapBp.City)){
            sapBp.City = '';
        }
        if(String.isBlank(sapBp.Country)){
            sapBp.Country = '';
        }
        if(String.isBlank(sapBp.EmailAddress)){
            sapBp.EmailAddress = '';
        }
        if(String.isBlank(sapBp.FirstName)){
            sapBp.FirstName = '';
        }
        if(String.isBlank(sapBp.LastName)){
            sapBp.LastName = '';
        }
        if(sapBp.AddressLine1 == '' && sapBp.AddressLine2 == '' && sapBp.PostalCode == '' && sapBp.State == '' && sapBp.City == '' && sapBp.Country == '' ){
            getAddressBody = Null;
        }
        else{
            List<Country__c> CountryCode = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name LIKE: sapBp.Country limit 1]);
            if (CountryCode.size() > 0){
                countryISOCode = CountryCode[0].Country_2__c;
            }
            getAddressBody = '{ "address": { "address1": "'+sapBp.AddressLine1+'", "city": "'+sapBp.City+'","country": "'+countryISOCode+'", "department": "", "faxNumber": "", "organization": "", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+sapBp.PostalCode+'", "region": "'+sapBp.State+'" }, "customer": { "email": "'+sapBp.EmailAddress+'" }, "person": { "firstName": "'+sapBp.FirstName+'", "lastName": "'+sapBp.LastName+'", "title": "Mr" }, "sourceSystemId": "TF-EBOOK" }';
            system.debug(getAddressBody);
            
        }
        return getAddressBody;
    }
    
    /**
* CreateSAPBP description :  the method will create SAP BP .
* @param  sapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  If address is valid returns response.
**/ 
    
    @AuraEnabled
    public static String CreateSAPBP(Object sapBp){
        
        SapbpWrapper SapObj = (SapbpWrapper)JSON.deserialize(JSON.serialize(SapBp), SapbpWrapper.class);
        System.debug('Address verify '+sapBp+'____'+SapObj);
        TF_SAP_BP_Verification RecordId= new TF_SAP_BP_Verification(SapObj.RecordId);
        if(SapObj.AddressLine1 == null){
            SapObj.AddressLine1 = '';
        }
        if(SapObj.AddressLine2 == null){
            SapObj.AddressLine2 = '';
        }
        if(SapObj.AddressLine3 == null){
            SapObj.AddressLine3 = '';
        }
        if(SapObj.Phone == null){
            SapObj.Phone = '';
        }
        if(SapObj.State == null){
            SapObj.State = '';
        }
        
        
        system.debug('partyId'+partyId);
        String jsonStringBody = '';
        jsonStringBody+='{';
        jsonStringBody+='"addressLine1": "'+ SapObj.AddressLine1 +'",';
        jsonStringBody+='"addressLine2": "'+ SapObj.AddressLine2 +'",';
        jsonStringBody+='"addressLine3": "'+ SapObj.AddressLine3 +'",';
        jsonStringBody+='"telephone": "'+ SapObj.Phone +'",';
        jsonStringBody+='"city": "' + SapObj.City + '",'; 
        jsonStringBody+='"state":"'+ SapObj.State +'",';
        jsonStringBody+='"country": "'+ SapObj.Country +'",';
        jsonStringBody+='"postalCode": "'+ SapObj.PostalCode +'",';
        jsonStringBody+='"addressType": "ORGANISATION",';
        jsonStringBody+='"firstName": "'+ SapObj.firstName +'",';
        jsonStringBody+='"lastName": "'+ SapObj.lastName +'",';
        jsonStringBody+='"emailAddress": "'+SapObj.emailAddress+'",';
        jsonStringBody+='"bpPartnerFunction": "SP",';
        jsonStringBody+='"bpBusinessPartnerCategory" : "2",';
        jsonStringBody+='"addressUseType": "Account Billing"';
        jsonStringBody+='}';
        
        system.debug('jsonStringBody'+jsonStringBody);
        String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+partyId+'/generateBP/');
        system.debug('resp'+resp);
        return resp;
    }
    
    // picklist value check
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        system.debug('objResults=====>'+objResults);
        return objResults;
    }
    
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    @AuraEnabled
    public static Boolean checkIfPostalCodeReq(String country){
        System.debug('country : '+country);
        Boolean postalCodeReq = true;
        if(country != null && country != ''){
            System.debug('country1 : '+country);
          Boolean postalCodeExemp = [Select Id, PostalCodeExempted__c from Country__c where Name =: country ].PostalCodeExempted__c;
            System.debug('postalCodeExemp : '+postalCodeExemp);
            if(postalCodeExemp){
                postalCodeReq = false;
            }
        }
        System.debug('postalCodeReq : '+postalCodeReq);
        return postalCodeReq;
    }
}