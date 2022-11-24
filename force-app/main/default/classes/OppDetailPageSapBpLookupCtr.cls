/** Author: Shalini Singh
    Test Class: OppDetailPageSapBpLookupCtrTest
	Description: Used in new sap bp creation component
**/
public class OppDetailPageSapBpLookupCtr {
    
    @AuraEnabled
    public static wrapperForBP accountSearch(string userInput,string accountfilterId,string pickedValue){
        system.debug('accountfilterId>>>'+accountfilterId);
        system.debug('pickedValue '+pickedValue);
        system.debug('userInput '+userInput);
        String pickedValues = pickedValue;
        List<SAP_BP__c> sapBpRecords = new List<SAP_BP__c>();
        wrapperForBP instanceOfwrapperForBP = new wrapperForBP();
       
        Opportunity recordOpportunity = new Opportunity();
        recordOpportunity = [Select id, name, AccountID, Account.name, LeadSource,Department__c,Campus__c FROM Opportunity WHERE Id=:accountfilterId LIMIT 1];
       
        if(recordOpportunity.AccountId != null){
            sapBpRecords = [SELECT Id,Name,Account_Id__r.Name,Email__c,Last_Name__c,First_Name__c,Street__c,City__c,State__c,Country__c,ZIP__c,
                            Tax_Registration_Number__c, Account_Id__c, Department__c, Department_Id__r.Name, Department_Id__r.Account__c, Campus_Id__r.Account__c FROM SAP_BP__c 
                            where Category__c = 'Organisation' AND (Account_Id__c=:recordOpportunity.AccountID Or Department_Id__r.Account__c =:recordOpportunity.AccountID Or Campus_Id__r.Account__c=:recordOpportunity.AccountID) LIMIT 1000];
        }
        instanceOfwrapperForBP.sapBPList = sapBpRecords;
        instanceOfwrapperForBP.AccountId = recordOpportunity.AccountId;
        instanceOfwrapperForBP.accountName = recordOpportunity.Account.name;
        
        if(recordOpportunity.LeadSource=='Agent' && recordOpportunity.AccountId!=null){
            instanceOfwrapperForBP.disabledOREnabled = false;
        }else if(recordOpportunity.LeadSource=='Agent' && recordOpportunity.AccountId==null){
            instanceOfwrapperForBP.disabledOREnabled = false;
        }else if(recordOpportunity.LeadSource!='Agent' && recordOpportunity.AccountId==null){
            instanceOfwrapperForBP.disabledOREnabled = false;
        }else{
            instanceOfwrapperForBP.disabledOREnabled = true;
        }
        system.debug('sapBpRecords '+sapBpRecords);
        system.debug('instanceOfwrapperForBP '+instanceOfwrapperForBP);
        return instanceOfwrapperForBP;
    }
    
    @AuraEnabled
    public static string saveBPtoOpportunity(String recordID, String BPId, String bpDetail){
        system.debug('saveBPtoOpportunity '+BPId+'----> '+bpDetail);
        Opportunity saveBPtoOpportunity = new Opportunity();
        saveBPtoOpportunity = [Select id,name,Bill_to_BP__c,Ship_to_BP__c FROM Opportunity WHERE id=:recordID];
        if(bpDetail=='BillTo'){
             saveBPtoOpportunity.Bill_to_BP__c = BPId;
        }else if(bpDetail=='ShipTo'){
            saveBPtoOpportunity.Ship_to_BP__c = BPId;
        }
        system.debug('saveBPtoOpportunity--> '+saveBPtoOpportunity);
        update saveBPtoOpportunity;
        
        return 'SUCCESS';
    }
    
    @AuraEnabled
    public static string copyBillToSap(String recordID){
        String returnedString = '';
        Opportunity copyBPtoOpportunity = new Opportunity();
        copyBPtoOpportunity = [Select id,name,Bill_to_BP__c,Ship_to_BP__c FROM Opportunity WHERE id=:recordID];
        if(copyBPtoOpportunity.Bill_to_BP__c==null){
            returnedString = 'No Bill To BP Found';
            return returnedString; 
        }else{
            copyBPtoOpportunity.Ship_to_BP__c = copyBPtoOpportunity.Bill_to_BP__c;
            returnedString = 'Bill To BP has been Copied to Ship To BP';
        }
        update copyBPtoOpportunity;
        return returnedString;
        
    }
    
    @AuraEnabled
    public static wrapperForBPdetails getBPDetails(String recordID){
        wrapperForBPdetails instanceOfWrapper = new wrapperForBPdetails();
        
        Opportunity opportunityInstance = new Opportunity();
        opportunityInstance = [Select id, name, Bill_to_BP__c, Ship_to_BP__c FROM Opportunity WHERE id=:recordID];
        
        if(opportunityInstance.Bill_to_BP__c !=null){
            SAP_BP__c sapBillToBP = new SAP_BP__c();
            sapBillToBP = [Select id,Department__c, Department_Id__c,Department_Id__r.Name,name,Email__c,Account_Id__c,Account_Id__r.name,Street__c,City__c,State__c,Country__c,ZIP__c,address_line1__c,address_line2__c, address_line3__c FROM SAP_BP__c WHERE id=:opportunityInstance.Bill_to_BP__c];
        	system.debug('sapBillToBP '+sapBillToBP);
            
            if(String.isNotBlank(sapBillToBP.address_line1__c) && sapBillToBP.address_line1__c.endsWith(','))
                sapBillToBP.address_line1__c = sapBillToBP.address_line1__c.removeEnd(',');
            if(String.isNotBlank(sapBillToBP.address_line2__c) && sapBillToBP.address_line2__c.endsWith(','))
                sapBillToBP.address_line2__c = sapBillToBP.address_line2__c.removeEnd(',');
            if(String.isNotBlank(sapBillToBP.address_line3__c) && sapBillToBP.address_line3__c.endsWith(','))
                sapBillToBP.address_line3__c = sapBillToBP.address_line3__c.removeEnd(',');
            
            String billToDepartmentDetail;
            if(String.isNotBlank(sapBillToBP.Department_Id__c) && String.isNotBlank(sapBillToBP.Department_Id__r.Name)) 
                billToDepartmentDetail = '<br/> Department Name: '+ sapBillToBP.Department_Id__r.Name;
            else if(String.isNotBlank(sapBillToBP.Department__c)) 
                billToDepartmentDetail = '<br/> Department Name: '+ sapBillToBP.Department__c;
            else billToDepartmentDetail= '<br/> Department Name: '+ '';
            
            String billtoBpDetail = 'Account Name: '+ (String.isNotBlank(sapBillToBP.Account_Id__r.name) ? sapBillToBP.Account_Id__r.name : '')+billToDepartmentDetail+ '<br/> Contact Email: '+ (String.isNotBlank(sapBillToBP.Email__c) ? sapBillToBP.Email__c : '')+'<br/> Address: ' +(String.isNotBlank(sapBillToBP.address_line1__c) ? sapBillToBP.address_line1__c +', ' : '')+(String.isNotBlank(sapBillToBP.address_line2__c) ? sapBillToBP.address_line2__c +', ' : '')+(String.isNotBlank(sapBillToBP.address_line3__c) ? sapBillToBP.address_line3__c +', ' : '') + (String.isNotBlank(sapBillToBP.City__c) ? sapBillToBP.City__c + ', ' : '') + (String.isNotBlank(sapBillToBP.State__c) ? sapBillToBP.State__c +', ' : '') + (String.isNotBlank(sapBillToBP.Country__c) ? sapBillToBP.Country__c+', ' : '') + (String.isNotBlank(sapBillToBP.ZIP__c) ? sapBillToBP.ZIP__c : '');
            //String billtoBpDetail = 'Account Name: '+ (String.isNotBlank(sapBillToBP.Account_Id__r.name) ? sapBillToBP.Account_Id__r.name : '')+ '<br/> Contact Email: '+ (String.isNotBlank(sapBillToBP.Email__c) ? sapBillToBP.Email__c : '')+'<br/> Address: ' +(String.isNotBlank(sapBillToBP.address_line1__c) ? sapBillToBP.address_line1__c +', ' : '')+(String.isNotBlank(sapBillToBP.address_line2__c) ? sapBillToBP.address_line2__c +', ' : '')+(String.isNotBlank(sapBillToBP.address_line3__c) ? sapBillToBP.address_line3__c +', ' : '') + (String.isNotBlank(sapBillToBP.City__c) ? sapBillToBP.City__c + ', ' : '') + (String.isNotBlank(sapBillToBP.State__c) ? sapBillToBP.State__c +', ' : '') + (String.isNotBlank(sapBillToBP.Country__c) ? sapBillToBP.Country__c+', ' : '') + (String.isNotBlank(sapBillToBP.ZIP__c) ? sapBillToBP.ZIP__c : '');
            if(billtoBpDetail.endsWith(', ')){
                billtoBpDetail = billtoBpDetail.removeEnd(', ');
            } 
            instanceOfWrapper.billToBP = billtoBpDetail;
            instanceOfWrapper.billToBpName = sapBillToBP.Name;
            instanceOfWrapper.billToBpId = sapBillToBP.Id;
        }
        if(opportunityInstance.Ship_to_BP__c !=null){
            SAP_BP__c sapShipToBP = new SAP_BP__c();
            sapShipToBP = [Select id,Department__c, Department_Id__c,Department_Id__r.Name,name,Email__c,Account_Id__c,Account_Id__r.name,Street__c,City__c,State__c,Country__c,ZIP__c,address_line1__c,address_line2__c, address_line3__c FROM SAP_BP__c WHERE id=:opportunityInstance.Ship_to_BP__c];
        	system.debug('sapShipToBP '+sapShipToBP);
            
            if(String.isNotBlank(sapShipToBP.address_line1__c) && sapShipToBP.address_line1__c.endsWith(','))
                sapShipToBP.address_line1__c = sapShipToBP.address_line1__c.removeEnd(',');
            if(String.isNotBlank(sapShipToBP.address_line2__c) && sapShipToBP.address_line2__c.endsWith(','))
                sapShipToBP.address_line2__c = sapShipToBP.address_line2__c.removeEnd(',');
            if(String.isNotBlank(sapShipToBP.address_line3__c) && sapShipToBP.address_line3__c.endsWith(','))
                sapShipToBP.address_line3__c = sapShipToBP.address_line3__c.removeEnd(',');
            
            String shipToDepartmentDetail;
            if(String.isNotBlank(sapShipToBP.Department_Id__c) && String.isNotBlank(sapShipToBP.Department_Id__r.Name)) 
                shipToDepartmentDetail = '<br/> Department Name: '+ sapShipToBP.Department_Id__r.Name;
            else if(String.isNotBlank(sapShipToBP.Department__c)) 
                shipToDepartmentDetail = '<br/> Department Name: '+ sapShipToBP.Department__c;
            else shipToDepartmentDetail= '<br/> Department Name: '+ '';
            
            String shiptoBpDetail = 'Account Name: '+ (String.isNotBlank(sapShipToBP.Account_Id__r.name) ? sapShipToBP.Account_Id__r.name : '')+shipToDepartmentDetail+'<br/> Contact Email: '+ (String.isNotBlank(sapShipToBP.Email__c) ? sapShipToBP.Email__c : '')+ '<br/> Address: ' +(String.isNotBlank(sapShipToBP.address_line1__c) ? sapShipToBP.address_line1__c +', ' : '')+(String.isNotBlank(sapShipToBP.address_line2__c) ? sapShipToBP.address_line2__c +', ' : '')+(String.isNotBlank(sapShipToBP.address_line3__c) ? sapShipToBP.address_line3__c +', ' : '') + (String.isNotBlank(sapShipToBP.City__c) ? sapShipToBP.City__c + ', ' : '') + (String.isNotBlank(sapShipToBP.State__c) ? sapShipToBP.State__c +', ' : '') + (String.isNotBlank(sapShipToBP.Country__c) ? sapShipToBP.Country__c+', ' : '') + (String.isNotBlank(sapShipToBP.ZIP__c) ? sapShipToBP.ZIP__c : '');
            //String shiptoBpDetail = 'Account Name: '+ (String.isNotBlank(sapShipToBP.Account_Id__r.name) ? sapShipToBP.Account_Id__r.name : '')+'<br/> Contact Email: '+ (String.isNotBlank(sapShipToBP.Email__c) ? sapShipToBP.Email__c : '')+ '<br/> Address: ' +(String.isNotBlank(sapShipToBP.address_line1__c) ? sapShipToBP.address_line1__c +', ' : '')+(String.isNotBlank(sapShipToBP.address_line2__c) ? sapShipToBP.address_line2__c +', ' : '')+(String.isNotBlank(sapShipToBP.address_line3__c) ? sapShipToBP.address_line3__c +', ' : '') + (String.isNotBlank(sapShipToBP.City__c) ? sapShipToBP.City__c + ', ' : '') + (String.isNotBlank(sapShipToBP.State__c) ? sapShipToBP.State__c +', ' : '') + (String.isNotBlank(sapShipToBP.Country__c) ? sapShipToBP.Country__c+', ' : '') + (String.isNotBlank(sapShipToBP.ZIP__c) ? sapShipToBP.ZIP__c : '');
            if(shiptoBpDetail.endsWith(', ')){
                shiptoBpDetail = shiptoBpDetail.removeEnd(', ');
            }
            instanceOfWrapper.shipToBP = shiptoBpDetail;
            instanceOfWrapper.shipToBpName = sapShipToBP.Name;
            instanceOfWrapper.shipToBpId = sapShipToBP.Id;
        }    
        
        return instanceOfWrapper;        
    }
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        //String searchKey = searchKeyWord + '%';
        String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 10';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<SAP_BP__C> fetchsapBpRecords(String accountId) {
        system.debug('accountId-->' + accountId);
        wrapperForBP instanceOfwrapperForBP = new wrapperForBP();
        List<SAP_BP__C> sapBpRecordList = new List<SAP_BP__c>();
        
        if(accountId != null){
            sapBpRecordList = [SELECT Id,Name,Account_Id__r.Name,Email__c,Last_Name__c,First_Name__c,Street__c,City__c,State__c,Country__c,ZIP__c,
                               Tax_Registration_Number__c, Account_Id__c, Department__c, Department_Id__r.Name, Department_Id__r.Account__c, Campus_Id__r.Account__c FROM SAP_BP__c 
							   where Category__c = 'Organisation' AND (Account_Id__c=:accountId Or Department_Id__r.Account__c =:accountId Or Campus_Id__r.Account__c=:accountId) LIMIT 1000];
        }
        system.debug('sapBpRecordList '+sapBpRecordList);
        return sapBpRecordList;
    }
    
    public class wrapperForBPdetails{
        @AuraEnabled
        public string billToBP;
        @AuraEnabled
        public string shipToBP;
        @AuraEnabled
        public string billToBpName;
        @AuraEnabled
        public Id billToBpId;
        @AuraEnabled
        public string shipToBpName;
        @AuraEnabled
        public Id shipToBpId;
    }
    
    public class wrapperForBP{
        @AuraEnabled
        public list<SAP_BP__c> sapBPList;
        @AuraEnabled 
        public string accountName;
        @AuraEnabled
        public boolean disabledOREnabled;
        @AuraEnabled 
        public List<Contact> contactList;
        @AuraEnabled 
        public string AccountId;
    }
    
    
    
    




    
    //Start of TF_SAP_BP_Verifiction code*******
    public static string partyId;
    
    public OppDetailPageSapBpLookupCtr(string RecordId){
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
        public String careOf {get;set;}
        public String department {get;set;}
        
    }
    
    
    /**
* VerifyAddressController description :  the method will search for the exact Bp match then will return the name of the Sap Bp if matched.
* @param  SapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  May be a success  message .
**/ 
    @AuraEnabled
    public static String VerifyAddressController(object SapBp){
        SapbpWrapper SapObj = (SapbpWrapper)JSON.deserialize(JSON.serialize(SapBp), SapbpWrapper.class);
        OppDetailPageSapBpLookupCtr RecordId= new OppDetailPageSapBpLookupCtr(SapObj.RecordId);
        system.debug('partyId'+partyId);
        try {     
            if(partyId!=Null || partyId==''){
                System.debug(' PartyId check called ');
                
                return partyId;
            } 
            else return 'Party Id is not associated with this Account!!';
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
        System.debug('Address verify API CALL '+sapBp+'____'+SapObj);
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
                System.debug('response =====>' + res + 'body--->'+res.getBody());
                system.debug(res.getStatusCode());
                statusbody = String.ValueOf(res.getBody());
                
                if(res.getStatusCode() == 200){
                    statusbody = String.ValueOf( res.getStatusCode());
                }
                else{
                    statusbody = SAP_BP_Res.metadata.details;
                }
                
            }
            
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
            statusbody = ex.getMessage();
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
        }else if(sapBp.AddressLine1.contains('\n')){
            List<String> streetList  = sapBp.AddressLine1.split('\n');
            String streetListStr = '';
            if(!streetList.isEmpty()){
                for(String item : streetList ){
                    item = item.replace('\r',' ');
                    streetListStr += item+' ';
                }
            }
            sapBp.AddressLine1 = streetListStr;
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
            getAddressBody = '{ "address": { "address1": "'+sapBp.AddressLine1+'", "city": "'+sapBp.City+'","country": "'+countryISOCode+'", "department": "", "faxNumber": "", "organization": "", "phoneExtension": "", "phoneNumber": "", "postalCode": "'+sapBp.PostalCode+'", "region": "'+sapBp.State+'" }, "customer": { "email": "'+sapBp.EmailAddress+'" }, "person": { "firstName": "'+sapBp.FirstName+'", "lastName": "'+sapBp.LastName+'", "title": "" }, "sourceSystemId": "TF-EBOOK" }';
            system.debug('getAddressBody-->'+ getAddressBody);
            
        }
        return getAddressBody;
    }
    
    /**
* CreateSAPBP description :  the method will create SAP BP .
* @param  sapBp           :  It is an object type String which will come in format of our SapbpWrapper class.
* @return                 :  If address is valid returns response.
**/ 
    
    @AuraEnabled
    public static String CreateSAPBP(Object sapBp, String bpDetail, String oppId){
        
        SapbpWrapper SapObj = (SapbpWrapper)JSON.deserialize(JSON.serialize(SapBp), SapbpWrapper.class);
        System.debug('CreateSAPBP '+sapBp+'____'+SapObj);
        system.debug('bpDetail--> '+bpDetail);
        system.debug('oppId--> '+oppId);
        
        OppDetailPageSapBpLookupCtr RecordId= new OppDetailPageSapBpLookupCtr(SapObj.RecordId);
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
        if(SapObj.careOf == null){
            SapObj.careOf = '';
        }
        if(SapObj.department == null){
            SapObj.department = '';
        }
        
        
        system.debug('partyId'+partyId);
        String jsonStringBody = '';
        jsonStringBody+='{';
        jsonStringBody+='"addressLine1": "'+ SapObj.AddressLine1 +'",';
        jsonStringBody+='"addressLine2": "'+ SapObj.AddressLine2 +'",';
        jsonStringBody+='"addressLine3": "'+ SapObj.AddressLine3 +'",';
        jsonStringBody+='"telephone": "'+ SapObj.Phone +'",';
        jsonStringBody+='"careOf": "'+ SapObj.careOf +'",';
        jsonStringBody+='"department": "'+ SapObj.department +'",';
        jsonStringBody+='"city": "' + SapObj.City + '",'; 
        jsonStringBody+='"state":"'+ SapObj.State +'",';
        jsonStringBody+='"country": "'+ SapObj.Country +'",';
        jsonStringBody+='"postalCode": "'+ SapObj.PostalCode +'",';
        jsonStringBody+='"addressType": "ORGANISATION",';
        jsonStringBody+='"firstName": "'+ SapObj.firstName +'",';
        jsonStringBody+='"lastName": "'+ SapObj.lastName +'",';
        jsonStringBody+='"emailAddress": "'+SapObj.emailAddress+'",';
        jsonStringBody+='"bpPartnerFunction": "SP",';
        jsonStringBody+='"bpBusinessPartnerCategory" : "Organisation",';
        if(bpDetail.containsIgnoreCase('BillTo')) jsonStringBody+='"addressUseType": "Account Billing"';
        else if(bpDetail.containsIgnoreCase('ShipTo')) jsonStringBody+='"addressUseType": "Account Shipping"';
        jsonStringBody+='}';
        
        system.debug('jsonStringBody'+jsonStringBody);
        String resp = processRequest(jsonStringBody, '/'+partyId+'/generateBP/', bpDetail, oppId);
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
    //End of TF_SAP_BP_Verifiction code*********
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Start of SAP_BP_Service code**********
    public class Response{
        public String status;
        public String message;
        public SAP_BP_utlDS.BPResponseObject objectData;
        
        public Response(String status, String message, SAP_BP_utlDS.BPResponseObject objectData){
            this.status=status;
            this.message=message;
            this.objectData=objectData;
        }
    }    
    public static Response apiResponse;
    public class Bad_Request_Exception extends Exception {}
    public static final String ERROR_PARTYID_NOT_RECOGNISED = 'PartyId missing from request/not recognised';
    public static final String ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP = 'An unexpected exception has occurred, Salesforce has been unable to process your request';
    public static final String SUCCESS_BP_PRESENT = 'SAP_BP__c is already present in SFDC';
    public static final String SUCCESS_BP_CREATION_SUBMITTED = 'New SAP BP Creation Submitted';
    public static final String ERROR_ADDRESS_VALIDATION = 'Address Validation Error';
    
    public static String processRequest(String jsonString, String URI, String bpPrefix, String passdOppId){
        system.debug('processRequest');
        Boolean isSuccess = false;
        try{
            //Parse the JSON.     
            SAP_BP_utlDS.addressWrapper addressData = (SAP_BP_utlDS.addressWrapper)JSON.deserialize(jsonString, SAP_BP_utlDS.addressWrapper.Class);
            addressData.PartyId = URI.substringBetween('/','/generateBP');
            SAP_BP_utlDS.validateRequest(addressData);
            system.debug('validateRequest- True'); 
            //Try to locate the SFDC Account Id. If not found throw an error.
            try{
                addressData.accountId = [SELECT Id FROM Account WHERE Customer_Id__c =: addressData.PartyId].Id;
            } catch (exception ex) {
                isSuccess = false;
                System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                //In the lines below we will return an error if the partyId has not been found.
            }
            if(addressData.accountId == null || addressData.accountId == ''){
                isSuccess = false;
                system.debug('addressData.accountId--> '+addressData.accountId);
                apiResponse = new Response('Error', ERROR_PARTYID_NOT_RECOGNISED, new SAP_BP_utlDS.BPResponseObject());
            }else{
                List<Account> accList = new List<Account>([Select id, VAT_Number__c from Account where id=: addressData.accountId]);
                if(accList != null && !accList.isEmpty() && String.isNotBlank(accList.get(0).VAT_Number__c)){
                    addressData.taxRegistrationNumber = accList.get(0).VAT_Number__c;
                    system.debug('addressData.taxRegistrationNumber--> '+addressData.taxRegistrationNumber);
                }
            }
            
            //Don't continue if there is not a PartyId in the request.
            
            if(addressData.accountId != null && addressData.accountId != ''){        
                //First try to match an existing SAP_BP__c record.
                Boolean sapBPRecordIsMatched = false;
                SAP_BP__c sapBPRecord;
                //Try to match an existing SAP_BP__c record.
                for(SAP_BP__c sbpRecord: [SELECT Id,Name,
                                          Account_Id__c,
                                          Street__c,
                                          address_line1__c,
                                          address_line2__c,
                                          address_line3__c,
                                          City__c,
                                          State__c,
                                          Country__c,
                                          ZIP__c,
                                          Status__c,
                                          Source__c,
                                          Telephone__c,
                                          Email__c,
                                          First_Name__c,
                                          Last_Name__c,
                                          Address_Type__c ,
                                          Care_of__c,
                                          Department__c,
                                          Tax_Registration_Number__c,
                                          Tax_Number_Category__c,
                                          Category__c FROM SAP_BP__c WHERE Account_Id__r.Customer_Id__c =: addressData.PartyId 
                                          AND Account_Id__r.Customer_Id__c != null]){
                                              
                                              //Run a check on the SAP_BP__c address.
                                              SAP_BP_utlDS.addressWrapper addressTempForChecking = SAP_BP_utlDS.mapAddressForSAP_BP(sbpRecord);
                                              if(SAP_BP_utlDS.addressMatcher(addressTempForChecking, addressData)){
                                                  sapBPRecord=sbpRecord; 
                                                  sapBPRecordIsMatched = true;             
                                              }
                                              
                                              
                                          }
                //If we have a match pass it back.
                if(sapBPRecordIsMatched){
                    isSuccess = true;
                    apiResponse = new Response('Success', SUCCESS_BP_PRESENT, new SAP_BP_utlDS.BPResponseObject(
                        sapBPRecord.Id, //salesforceRecordId
                        '', //houseNumber
                        sapBPRecord.Street__c, //addressLine1
                        '', //addressLine2
                        '', //addressLine3
                        sapBPRecord.City__c, //city
                        sapBPRecord.State__c, //state
                        sapBPRecord.Country__c, //country
                        '', //countryCode
                        sapBPRecord.ZIP__c, //postalCode
                        sapBPRecord.Address_Type__c, //addressType
                        '', //contactType
                        sapBPRecord.First_Name__c, //firstName
                        sapBPRecord.Last_Name__c, //lastName
                        '', //title
                        '', //emailAddress
                        '', //telephone
                        sapBPRecord.Name, //bpNumber
                        '', //bpPartnerFunction
                        '', //bpBusinessPartnerCategory
                        sapBPRecord.Tax_Registration_Number__c, //taxRegistrationNumber
                        sapBPRecord.Tax_Number_Category__c, //taxNumberCategory
                        sapBPRecord.Source__c, //source
                        sapBPRecord.Address_Type__c //addressUseType.                   
                    ));
                } else { //Create a new SAP_BP__c record.
                    
                    
                    try{     
                        //Call the method to handle the creation of the SAP_BP__c record and make the callout to SAP.
                        List<SAP_BP__c> sbpRecordList = new List<SAP_BP__c>{SAP_BP_utlDS.noInsertCreateSAPBPRecord(addressData)};                        
                            isSuccess = true;
                        if(sbpRecordList != null && sbpRecordList.size() > 0){
                            sbpRecordList[0].Status__c  = true;
                            if(addressData.bpNumber != null && addressData.rrAddressId != null){
                                sbpRecordList[0].Name = addressData.bpNumber;
                                sbpRecordList[0].RR_Address_ID__c  = addressData.rrAddressId;
                            }
                            //Commit the SAP_BP__c record 
                            Insert sbpRecordList;
                        }
                        apiResponse = new Response('Success', SUCCESS_BP_CREATION_SUBMITTED, 
                                                   new SAP_BP_utlDS.BPResponseObject(
                                                       sbpRecordList[0].Id, //salesforceRecordId
                                                       '', //houseNumber
                                                       sbpRecordList[0].Street__c, //addressLine1
                                                       '', //addressLine2
                                                       '', //addressLine3
                                                       sbpRecordList[0].City__c, //city
                                                       sbpRecordList[0].State__c, //state
                                                       sbpRecordList[0].Country__c, //country
                                                       '', //countryCode
                                                       sbpRecordList[0].ZIP__c, //postalCode
                                                       sbpRecordList[0].Address_Type__c, //addressType
                                                       '', //contactType
                                                       sbpRecordList[0].First_Name__c, //firstName
                                                       sbpRecordList[0].Last_Name__c, //lastName
                                                       '', //title
                                                       sbpRecordList[0].Email__c, //emailAddress
                                                       '', //telephone
                                                       sbpRecordList[0].Name, //bpNumber
                                                       '', //bpPartnerFunction
                                                       '', //bpBusinessPartnerCategory
                                                       sbpRecordList[0].Tax_Registration_Number__c, //taxRegistrationNumber
                                                       sbpRecordList[0].Tax_Number_Category__c, //taxNumberCategory   
                                                       sbpRecordList[0].Source__c, //source
                                                       sbpRecordList[0].Address_Type__c //addressUseType.  
                                                   )           
                                                  );
                        
                        if(!(addressData.bpNumber != null)){
                            List<Id> sapBPIds = new List<Id>();
                            for(SAP_BP__c sbp: sbpRecordList){
                                sapBPIds.add(sbp.Id);
                            }
                            //Only make the callout if the request is not running in a test.
                            if(!test.isRunningTest()){
                                System.debug('Call BP API');
                                getSAPBPNumberCallout(sapBPIds,jsonString,bpPrefix, passdOppId); 
                            }   
                        }
                    } catch (exception ex) {
                        System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                        isSuccess = false;
                        apiResponse = new Response('Error', ERROR_SFDC_UNABLE_TO_SUBMIT_CREATE_BP, new SAP_BP_utlDS.BPResponseObject());  
                    }
                    
                }   
            }        
        }catch(Exception ex){
            System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
            apiResponse = new Response('Error', ex.getMessage() , new SAP_BP_utlDS.BPResponseObject());  
        }
        return JSON.serialize(apiResponse);       
    }
    //End of SAP_BP_Service code**********
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Start of TF_CreateBusinessPartnerCallout class according to DS********
    public class TF_CreateBusinessPartnerResponse {        
        public Metadatas metadata ;
        public Data[] data ;
    }
    public class SAP_BP_Error_Response {
        public Metadata metadata;
    }
    public class Metadatas {        
        public Integer code ;
        public String timestamp ;
        public String details ;
    }
    public class Data {  
        public String externalCustomerAddressId ;
        public String businessPartnerNumber;
    }
    private static string taxNumberCategory;
    
    @future(callout=true)
    public static void getSAPBPNumberCallout(List<Id> newSAPBPIDList, String jsonString, String bpPrefix, String passdOppId){
        System.debug('testgetSAPBPNumberCallout');
        List<SAP_BP__c> newSAPBPList = [Select Id,SAddress_RRAdd_ID__c,Department__c,Care_Of__c,Category__c , name,Street__c,address_line1__c,address_line2__c,address_line3__c,Telephone__c,Address_ID__c, Country__c,ZIP__c,City__c,Email__c,First_Name__c,Last_Name__c,Tax_Number_Category__c,Tax_Registration_Number__c,State__c, Account_Id__r.Name,Address_Type__c,Message__c  from SAP_BP__c where Id IN:newSAPBPIDList];
       
        for(SAP_BP__c thisSAPBP: newSAPBPList){
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
			String uri = (String) orgSpecificProps.get('SAP_BP_Creation__c');
			
			String methodType = 'POST';
			Map<String, String> headers = new Map<String,String>();
			Map<String, String> resultMap = new Map<String,String>();
			headers.put('Content-Type', 'application/json');
			try{
				String body = getRequestBody(thisSAPBP);
				System.debug('RequestBody :'+body);
				if(body != null){
					HttpResponse response = new HttpResponse();
					if ( String.isNotBlank(uri) ) {
                        response = TF_PlatformExecuter.execute(uri, methodType, 'idtoken', body, headers, false);
                    }
					System.debug('response--> ' + response + ' body--> '+response.getBody());            
					system.debug('bpPrefix--> '+ bpPrefix);
					if ( response != null && response.getStatusCode() == 201 ) {
						TF_CreateBusinessPartnerResponse createBPResponse = (TF_CreateBusinessPartnerResponse) JSON.deserialize(response.getBody(), TF_CreateBusinessPartnerResponse.class);
						thisSAPBP.Name = createBPResponse.data[0].businessPartnerNumber;
                        thisSAPBP.Tax_Number_Category__c = taxNumberCategory;
                        if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('BillTo'))
                            updateSapMessageField(' Bill to: Generated Successfully ', thisSAPBP, 'Bill to', passdOppId);
                        else if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('ShipTo'))
                            updateSapMessageField(' Ship to: Generated Successfully ', thisSAPBP, 'Ship to', passdOppId);
						
					}else{
						SAP_BP_Error_Response createBPErrorResponse = (SAP_BP_Error_Response)JSON.deserialize(response.getBody(), SAP_BP_Error_Response.class);
                        system.debug('createBPErrorResponse--> '+createBPErrorResponse);
                        if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('BillTo'))
                            updateSapMessageField(' Bill to: Generation Failed, ' +createBPErrorResponse.Metadata.details + ' ', thisSAPBP, 'Bill to', passdOppId);
                        else if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('ShipTo'))
                            updateSapMessageField(' Ship to: Generation Failed, ' +createBPErrorResponse.Metadata.details + ' ', thisSAPBP, 'Ship to', passdOppId);
					}
				}
			}catch(Exception ex){
                System.debug(' ******** Exception : ' +  String.valueOf(' Exception Type :-'+ex.getTypeName()+' ** Message:-'+ex.getMessage()+' ** Line Number:-'+ex.getLineNumber()+' ** Stack Trace :- '+ ex.getStackTraceString()));
                if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('BillTo'))
                    updateSapMessageField(' Bill to: Generation Failed, ' +ex.getMessage()+ ' ', thisSAPBP, 'Bill to', passdOppId);
                else if(String.isNotBlank(bpPrefix) && bpPrefix.containsIgnoreCase('ShipTo'))
                    updateSapMessageField(' Ship to: Generation Failed, ' +ex.getMessage()+ ' ', thisSAPBP, 'Ship to', passdOppId);
			}
        }
        
    }
    
    public static String getRequestBody(SAP_BP__c thisSAPBP){
        taxNumberCategory = ''; 
        String countryCodeISO='';
        if(thisSAPBP.address_line1__c  == null){
            thisSAPBP.address_line1__c = '';
        }
        if(thisSAPBP.address_line2__c == null){
            thisSAPBP.address_line2__c = '';
        }
        if(thisSAPBP.address_line3__c == null){
            thisSAPBP.address_line3__c = '';
        }
        if(thisSAPBP.Country__c == null){
            thisSAPBP.Country__c= '';
        }
        if(thisSAPBP.ZIP__c == null){
            thisSAPBP.ZIP__c= '';
        }
        if(thisSAPBP.City__c == null){
            thisSAPBP.City__c = '';
        }
        if(thisSAPBP.State__c == null){
            thisSAPBP.State__c = '';
        }
        if(thisSAPBP.Telephone__c == null){
            thisSAPBP.Telephone__c = '';
        }
        if(thisSAPBP.Tax_Registration_Number__c == null){
            thisSAPBP.Tax_Registration_Number__c = '';
        }
        if(thisSAPBP.Tax_Number_Category__c == null){
            thisSAPBP.Tax_Number_Category__c = '';
        }
        if(thisSAPBP.Care_Of__c == null){
            thisSAPBP.Care_Of__c = '';
        }
        if(String.isBlank(thisSAPBP.Street__c)){
            thisSAPBP.Street__c= '';
        }else if(thisSAPBP.Street__c.contains('\n')){
            List<String> streetList  = thisSAPBP.Street__c.split('\n');
            String streetListStr = '';
            if(!streetList.isEmpty()){
                for(String item : streetList ){
                    item = item.replace('\r',' ');
                    streetListStr += item+' ';
                }
            }
            thisSAPBP.Street__c = streetListStr;
        }
        List<Country__c> countryCodeList = new List<Country__c>([SELECT Country_2__c, Name FROM Country__c where Name =: thisSAPBP.Country__c Limit 1]);
        if (countryCodeList.size()>0){
            system.debug('countryCodeList--> '+countryCodeList);
            countryCodeISO = countryCodeList.get(0).Country_2__c;
            system.debug('countryCodeISO--> '+countryCodeISO);
            if(String.isNotBlank(countryCodeISO) && String.isNotBlank(thisSAPBP.Tax_Registration_Number__c)){
                List<Setting_Item__c> taxCodeList = new List<Setting_Item__c>();
                
                if(countryCodeISO.containsIgnoreCase('IN') || countryCodeISO.containsIgnoreCase('BR') || countryCodeISO.containsIgnoreCase('AU'))
                    taxCodeList = [select id , Setting__c, Text_1__c, Text_2__c, Text_3__c from Setting_Item__c  where Setting__r.Name  = 'Sap Tax Type/Code' AND Text_1__c =: countryCodeISO AND Text_3__c =: String.valueOf(thisSAPBP.Tax_Registration_Number__c.length()) limit 1];
                else taxCodeList = [select id , Setting__c, Text_1__c, Text_2__c, Text_3__c from Setting_Item__c  where Setting__r.Name  = 'Sap Tax Type/Code' AND Text_1__c =: countryCodeISO limit 1];
                system.debug('taxCodeList--> '+taxCodeList);
                if(taxCodeList != NULL && !taxCodeList.isEmpty()){
                    taxNumberCategory = taxCodeList.get(0).Text_2__c;
                    system.debug('taxNumberCategory '+ taxNumberCategory);
                }
            }
        }

        String customerName = ''; 
        String deptName = '';
        if (String.isNotBlank( thisSAPBP.Address_Type__c) ) {
            if (thisSAPBP.Account_Id__c!=NULL ) {
                List<account> listAccBp = new List<account>([select id ,name from Account where id=:thisSAPBP.Account_Id__c]);
                if(!listAccBp.isEmpty()) customerName = listAccBp.get(0).Name;    
            }             
            if (String.isNotBlank(thisSAPBP.Department__c)){
                deptName = thisSAPBP.Department__c;
            }
        }
        
        // changes for invoice
        Map<String,String> mapApiMapg = new Map<String,String>();
        for(integer i =1 ; i < 8 ; i++){
            mapApiMapg.put('dynamicVar'+i, '');
        }
        List<String> listStr = new List<String>();
        if( String.isNotBlank( thisSAPBP.Address_Type__c) && (String.isBlank(deptName) || deptName.length() <= 35 ))
        {
            system.debug('less char than 35');
            if(String.isNotBlank(deptName)) mapApiMapg.put('dynamicVar1', deptName);
            if( String.isNotBlank(customerName) ){                    
                listStr = splitStringBySpace(customerName,35);
                if(!listStr.isEmpty() ){
                    integer i =2 ;
                    for(String str : listStr ){
                        mapApiMapg.put('dynamicVar'+i, str);//It will occupie dynamicVar2, dynamicVar3 and dynamicVar4 and map with ord 1, org and org 3
                        i++;
                    }
                    listStr.clear();
                }
            }
            
            if(String.isNotBlank(thisSAPBP.Street__c) ){                   
                listStr = splitStringBySpace(thisSAPBP.Street__c,35);
                if(!listStr.isEmpty() ){
                    integer i =5 ;
                    for(String str : listStr ){
                        mapApiMapg.put('dynamicVar'+i, str);//It will occupie dynamicVar5, dynamicVar6 and dynamicVar7 and map with add line 1, 2 and 3
                        i++;
                    }
                    listStr.clear();
                }
            }                               
        }
        listStr.clear();
        // when its a careOf or dept name > 35 char
        if (String.isNotBlank( thisSAPBP.Address_Type__c) && deptName.length() > 35 ) 
        {               
            system.debug('more char than 35');
            if( String.isNotBlank(deptName) )  listStr.addAll( splitStringBySpace(deptName,35));
            if( String.isNotBlank(customerName) )  listStr.addAll( splitStringBySpace(customerName,35));                                
            if(String.isNotBlank(thisSAPBP.Street__c)) listStr.addAll( splitStringBySpace(thisSAPBP.Street__c,35));
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
        system.debug('mapApiMapg--> '+mapApiMapg);
        

        
        
        
        

        
        String requestBody = '{"customers": [{"businessPartner":{"type":"ORGANIZATION"},"contactDetail":{"addressLine1":"'+mapApiMapg.get('dynamicVar5')+'","addressLine2":"'+mapApiMapg.get('dynamicVar6')+'","addressLine3":"'+mapApiMapg.get('dynamicVar7')+'","department":"'+mapApiMapg.get('dynamicVar1')+'","careOf":"'+thisSAPBP.Care_Of__c+'","addressType":"'+thisSAPBP.Address_Type__c+'","city":"'+thisSAPBP.City__c+'","postalCode":"'+thisSAPBP.ZIP__c+'","country":"'+countryCodeISO+'","emailAddress":"'+thisSAPBP.Email__c+'","title":"","firstName":"'+thisSAPBP.First_Name__c+'","telephone":"'+thisSAPBP.Telephone__c +'","lastName":"'+thisSAPBP.Last_Name__c+'","location":"","organizationName1":"'+mapApiMapg.get('dynamicVar2')+'","organizationName2":"'+mapApiMapg.get('dynamicVar3')+'","organizationName3":"'+mapApiMapg.get('dynamicVar4')+'","phoneNumber":"","region":"'+thisSAPBP.State__c+'"},"externalCustomerAddressId":"'+thisSAPBP.SAddress_RRAdd_ID__c+'","sourceSystemId":"TF-EBOOK","taxRegistrationNumber":"'+thisSAPBP.Tax_Registration_Number__c +'","taxType":"'+taxNumberCategory+'"}] }';
        system.debug('requestBody--> ' +requestBody); 
        return requestBody;
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
    //End of TF_CreateBusinessPartnerCallout class code according to DS******
    
    
    
    
    //Updates message field on sap bp record
    @AuraEnabled
    public static void updateSapMessageField(String errorMessageField, SAP_BP__c sapBp, String prefix, String passdOppId){
        System.debug('updateSapMessageField Call');
        if(string.isNotBlank(errorMessageField) && (errorMessageField.containsIgnoreCase('Generated Successfully') || errorMessageField.containsIgnoreCase('Generation Failed')))
        {
            String messageStr = sapBp.Message__c;
            if ( messageStr != NULL && String.isNotBlank(messageStr) ) {
                Map<integer,String> mapIndexValue = new Map<integer,String>();
                List<String> listStr = messageStr.split('~msg~');
                integer k = 0 ;
                for (String msgStr : listStr) {
                    System.debug('msgStr-'+msgStr);
                    if (msgStr!=NULL && (msgStr.containsIgnoreCase('Generated Successfully') || msgStr.containsIgnoreCase('Generation Failed')) ) {
                        system.debug('Inside'+msgStr);
                        // overwrite string , it can be success or failure mssg 
                        mapIndexValue.put( k , errorMessageField + ' ' );
                    }
                    k++;
                }
                if(!messageStr.containsIgnoreCase('Generated Successfully') || !messageStr.containsIgnoreCase('Generation Failed')){
                    listStr.add(errorMessageField);
                } 
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
                    sapBp.Message__c = finalStr + '~msg~' +' '+prefix+': Address Verified' + ' ' ;
                }
            }
            else if(String.isBlank(messageStr)){
                sapBp.Message__c = errorMessageField+ + '~msg~' +' '+prefix+': Address Verified' + ' ';
            }
            system.debug('sapBp.Message__c--> '+sapBp.Message__c);
            system.debug('Update sapBp '+sapBp);
            Update sapBp;
        }
        
        
        
        system.debug('passdOppId--> '+passdOppId);
        if(String.isNotBlank(passdOppId)) {
            system.debug('Update Message Field on Opportunity');
            //Get error message from SAP BP's error message field and update value in opportunity's error message field
            String errorMessageOnOpp = '';
            Opportunity oppUpdate = [Select id, Order_Status__c, Message__c, Bill_to_BP__r.Message__c, Ship_to_BP__r.Message__c, RecordTypeId,Sold_to_BP__c,Ship_to_BP__c,Payer_BP__c,StageName,AccountId,Bill_to_BP__r.Email__c, Name, Bill_to_BP__r.First_Name__c, Bill_to_BP__r.Last_Name__c, Bill_to_BP__r.Country__c, Bill_to_BP__r.Region__c, Bill_to_BP__r.State__c, Bill_to_BP__r.Street__c, Bill_to_BP__r.ZIP__c, Bill_to_BP__c, Bill_to_BP__r.City__c from Opportunity where id =: passdOppId];
            system.debug('Before '+oppUpdate.Message__c);
            if(oppUpdate.Bill_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Bill_to_BP__r.Message__c)) 
            {
                if(oppUpdate.Bill_to_BP__r.Message__c.containsIgnoreCase('Ship to')){
                    errorMessageOnOpp += oppUpdate.Bill_to_BP__r.Message__c.replace('Ship to', 'Bill to') + ' ~msg~ ';
                }
                else errorMessageOnOpp += oppUpdate.Bill_to_BP__r.Message__c + ' ~msg~ ';
            }
            if(oppUpdate.Ship_to_BP__c !=NULL && String.isNotBlank(oppUpdate.Ship_to_BP__r.Message__c))
            {
                if(oppUpdate.Ship_to_BP__r.Message__c.containsIgnoreCase('Bill to')){
                    errorMessageOnOpp += oppUpdate.Ship_to_BP__r.Message__c.replace('Bill to', 'Ship to') + ' ~msg~ ';
                }
                else errorMessageOnOpp += oppUpdate.Ship_to_BP__r.Message__c + ' ~msg~ ';
            }
            
            errorMessageOnOpp = errorMessageOnOpp.removeEnd(' ~msg~ ');
            Integer maxSize = 65536;
            if(errorMessageOnOpp.length() > maxSize ){
                errorMessageOnOpp = errorMessageOnOpp.substring(0, maxSize);
                oppUpdate.Message__c = errorMessageOnOpp;
            }else{
                oppUpdate.Message__c = errorMessageOnOpp;
            }
            system.debug('After '+oppUpdate.Message__c);
            update oppUpdate;
        }
        
        
    }
    
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value, Id accountId) {
        try {
            system.debug('accountId--> '+accountId);
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, FirstName, LastName, Email, Phone, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 1000';
            } else {
                query += ' WHERE '+filterField+
                		' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' AND AccountId=:accountId LIMIT 1000';
            }
            system.debug('query--> '+query);
	        for(SObject s : Database.query(query)) {
	            recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id'), s) );
	        }
            return recordsDataList;
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
    }
 
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public SObject conObj;
        public RecordsData(String label, String value, SObject conObj) {
            this.label = label;
            this.value = value;
            this.conObj = conObj;
        }
    }
    
    @AuraEnabled
    public static List<Account> fetchPostalCodeDetails(String AccountId){
        system.debug('AccountId-->'+AccountId);
        List<Account> accList = new List<Account>();
        for(Account accRec:[SELECT Id,Name,BillingAddress,BillingCity,BillingCountry,
                            BillingPostalCode,BillingState,BillingStreet 
                            FROM Account 
                            WHERE Id=:AccountId]){
            if(accRec != null && String.isNotBlank(accRec.BillingStreet) && accRec.BillingStreet.contains('\n')){
            List<String> streetList  = accRec.BillingStreet.split('\n');
            String streetListStr = '';
            if(!streetList.isEmpty()){
                for(String item : streetList ){
                    item = item.replace('\r',' ');
                    streetListStr += item+' ';
                }
            }
            accRec.BillingStreet = streetListStr;
        }                    
            accList.add(accRec);
            system.debug('accList-->'+accList);
        }
        return accList;
    }
}