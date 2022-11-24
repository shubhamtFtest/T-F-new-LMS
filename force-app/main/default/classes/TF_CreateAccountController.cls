public without sharing  class TF_CreateAccountController {
   
    public class AccountData {
        @AuraEnabled
        public String Id ;
        @AuraEnabled
        public String Name ;
        @AuraEnabled
        public String Customer_Id_c ;
        @AuraEnabled
        public String Ringgold_Account_ID_c;
        @AuraEnabled
        public String Source_of_Account_c ;
        @AuraEnabled
        public String Onboarding_Status_c ;
        @AuraEnabled
        public Datetime Requested_Date_c ;
        @AuraEnabled
        public String Request_CreatedBy_c ;
        @AuraEnabled
        public String Request_Account_Name_c ;
    }

    /**
    * Create Account in Salesforce
    **/    
    @AuraEnabled
    public static List<string> createAccount (Account Account, String verifyAddressesInfo, Boolean billingCountryNotUpdate, list<string> billingStateNoneUpdate, Boolean shippingCountryNotUpdate, list<string> shippingStateNoneUpdate, Boolean mailingCountryNotUpdate, list<string> mailingStateNoneUpdate, list<string> NewEndUserRemoteAccessSet, list<string> NewListForIPSet, List<Contact> NewListForContact, String updateOrInsert, list<Contact> ListForContact, list<End_User_Access__c> ListForIP, list<End_User_Access__c> EndUserRemoteAccess, String BillingAddLine1, String BillingAddLine2, String MailingAddLine1, String MailingAddLine2, String ShippingAddLine1, String ShippingAddLine2,String RequestNotes)
    { 
        //Use list of string to store error message on account addresses verification and return the value
        List<String> errorStringSet = new List<String>();

        try{
            if(Account != null){
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
                Account.RecordTypeId  = recordTypeId;
         
                /*****Map billing street values****/
                string Billstr ='';
                if(BillingAddLine1 != null){
                    Billstr+=BillingAddLine1;
                }
                if(String.isNotBlank(BillingAddLine2)){
                    Billstr+=' ';
                    Billstr+=BillingAddLine2;
                }
                Account.Billing_Street__c=Billstr; 
                if(!String.isNotEmpty(BillingAddLine1) && !String.isNotEmpty(BillingAddLine2)){
                    Account.Billing_Street__c = '';
                }
                
                string BillStrAccReq ='';
                if(BillingAddLine1 != null){
                    BillStrAccReq+=BillingAddLine1;
                    BillStrAccReq+=';';
                }
                if(BillingAddLine2 != null){
                    BillStrAccReq+=BillingAddLine2;
                }
                Account.Billing_Street_Account_Request__c=BillStrAccReq;  
                
                
                /*****Map mailing street values****/
                string Mailstr ='';
                if(MailingAddLine1 != null){
                    Mailstr+=MailingAddLine1;
                }
                if(String.isNotBlank(MailingAddLine2)){
                    Mailstr+=' ';
                    Mailstr+=MailingAddLine2;
                }
                Account.BillingStreet=Mailstr; 
                if(!String.isNotEmpty(MailingAddLine1) && !String.isNotEmpty(MailingAddLine2)){
                    Account.BillingStreet = '';
                }
                
                string MailStrAccReq ='';
                if(MailingAddLine1 != null){
                    MailStrAccReq+=MailingAddLine1;
                    MailStrAccReq+=';';
                }
                if(MailingAddLine2 != null){
                    MailStrAccReq+=MailingAddLine2;
                }
                Account.Mailing_Street_Account_Request__c=MailStrAccReq; 
                
                
                /*****Map shipping street values****/
                string Shipstr ='';
                if(ShippingAddLine1 != null){
                    Shipstr+=ShippingAddLine1;
                }
                if(String.isNotBlank(ShippingAddLine2)){
                    Shipstr+=' ';
                    Shipstr+=ShippingAddLine2;
                }
                Account.ShippingStreet=Shipstr;
                if(!String.isNotEmpty(ShippingAddLine1) && !String.isNotEmpty(ShippingAddLine2)){
                    Account.ShippingStreet = '';
                }
                
                string ShipStrAccReq ='';
                if(ShippingAddLine1 != null){
                    ShipStrAccReq+=ShippingAddLine1;
                    ShipStrAccReq+=';';
                }
                if(ShippingAddLine2 != null){
                    ShipStrAccReq+=ShippingAddLine2;
                }
                Account.Shipping_Street_Account_Request__c=ShipStrAccReq; 
                Account.Request_Notes__c  = RequestNotes;
                
                
                /*****Map values in source of account field****/
                //Get aggregator identifier field value of current login user's account
                String SourceOfAccount = souraceOfAccount();
                
                //If aggregator identifier field value of current login user is GOBI then set source of account field value GOBI
                if(SourceOfAccount == 'GOBI'){
                    Account.Source_of_Account__c='GOBI';
                }
                
                //If aggregator identifier field value of current login user is ProQuest then set source of account field value ProQuest
                if(SourceOfAccount == 'ProQuest'){
                    Account.Source_of_Account__c='ProQuest';
                }
                
                //If mailing, shipping and billing states are not selected then set it as blank
                if(Account.Mailing_State_List__c == '--- None ---'){
                    Account.Mailing_State_List__c = '';
                    Account.BillingState = '';
                }
                if(Account.Mailing_State_List__c != '--- None ---' && String.isNotEmpty(Account.Mailing_State_List__c)){
                    Account.BillingState = Account.Mailing_State_List__c;
                }
                if(Account.Mailing_Country_List__c != '--- None ---' && String.isNotEmpty(Account.Mailing_Country_List__c)){
                    Account.BillingCountry = Account.Mailing_Country_List__c;
                }
                
                if(Account.Shipping_State_List__c == '--- None ---'){
                    Account.Shipping_State_List__c = '';
                }
                
                if(Account.Billing_State_List__c == '--- None ---'){
                    Account.Billing_State_List__c = '';
                }
                
                //If mailing country are not selected then set it to blank, in case of updating an account if someone selecte country as blank then set their state field also blank
                if(Account.Mailing_Country_List__c == '--- None ---'){
                    Account.Mailing_Country_List__c = '';
                    Account.Mailing_State_List__c = '';
                    Account.BillingCountry = '';
                    Account.BillingState = '';
                }
                else{
                    if(mailingCountryNotUpdate == true){
                        //In case of update, if someone change country and does not select any state so, list of dependent state picklist will not contain dependent state which is already present in salesforce then set state as balnk 
                        if(!mailingStateNoneUpdate.contains(Account.Mailing_State_List__c)){
                            Account.Mailing_State_List__c='';
                            Account.BillingState = '';
                        } 
                    }
                }
                
                //If shipping country are not selected then set it to blank, in case of updating an account if someone selecte country as blank then set their state field also blank
                if(Account.Shipping_Country_List__c == '--- None ---'){
                    Account.Shipping_Country_List__c = '';
                    Account.Shipping_State_List__c = '';
                }
                else{
                    if(shippingCountryNotUpdate == true){
                        //In case of update, if someone change country and does not select any state so, list of dependent state picklist will not contain dependent state which is already present in salesforce then set state as balnk 
                        if(!shippingStateNoneUpdate.contains(Account.Shipping_State_List__c)){
                            Account.Shipping_State_List__c='';
                        } 
                    }
                }
                
                //If billing country are not selected then set it to blank, in case of updating an account if someone selecte country as blank then set their state field also blank
                if(Account.Billing_Country_List__c == '--- None ---'){
                    Account.Billing_Country_List__c = '';
                    Account.Billing_State_List__c = '';
                }
                else{
                    if(billingCountryNotUpdate == true){
                        //In case of update, if someone change country and does not select any state so, list of dependent state picklist will not contain dependent state which is already present in salesforce then set state as balnk 
                        if(!billingStateNoneUpdate.contains(Account.Billing_State_List__c)){
                            Account.Billing_State_List__c='';
                        } 
                    }
                }
                
                /*****Verify Account Addresses*****/
                //Hit the SAP API and verify account addresses
                if(verifyAddressesInfo == 'verifying'){
                    String errorStringSetMailing = TF_VerifyAccountRequestAddress.mailingAddressVerify(Account, MailingAddLine1, MailingAddLine2);
                    if(errorStringSetMailing != null){
                        Account.Onboarding_Status__c = 'Draft';
                        errorStringSet.add(errorStringSetMailing);
                    }
                    else{
                        errorStringSet.add('');
                    }
                    
                    String errorStringSetShipping = TF_VerifyAccountRequestAddress.shippingAddressVerify(Account, ShippingAddLine1, ShippingAddLine2);
                    if(errorStringSetShipping != null){
                        Account.Onboarding_Status__c = 'Draft';
                        errorStringSet.add(errorStringSetShipping);
                    }
                    else{
                        errorStringSet.add('');
                    }
                    
                    String errorStringSetBilling = TF_VerifyAccountRequestAddress.billingAddressVerify(Account, BillingAddLine1, BillingAddLine2);
                    if(errorStringSetBilling != null){
                        Account.Onboarding_Status__c = 'Draft';
                        errorStringSet.add(errorStringSetBilling);
                    }
                    else{
                        errorStringSet.add('');
                    }
                }
                
                //Once someone verify account address and then remove all values then blank those fields who stored address verification result
                if(String.isBlank(ShippingAddLine1) && String.isBlank(ShippingAddLine2) && String.isBlank(Account.ShippingCity) && (Account.Shipping_Country_List__c == '--- None ---' || String.isBlank(Account.Shipping_Country_List__c)) && String.isBlank(Account.ShippingPostalCode)){
                    Account.Shipping_Verification_Output__c = '';
                    Account.Shipping_Address_verification_color__c = 'notVerified';
                }
                
                if(String.isBlank(BillingAddLine1) && String.isBlank(BillingAddLine2) && String.isBlank(Account.Billing_City__c) && (Account.Billing_Country_List__c == '--- None ---' || String.isBlank(Account.Billing_Country_List__c)) && String.isBlank(Account.Billing_ZIP__c)){
                    Account.Billing_Verification_Output__c = '';
                    Account.Billing_Address_Verification_Color__c = 'notVerified';
                }
    
                
                system.debug(errorStringSet);
                system.debug(Account);
                /*****Insert Account*****/
                if(updateOrInsert == 'NewCustomer'){
                    system.debug(Account);
                    insert Account;
                }
                
                /*****Update Account*****/
                if(updateOrInsert == 'updateCustomer'){
                    system.debug(Account);
                    update Account;
                }
                
                /*****Update End User Object List in profile data tab****/
                if(updateOrInsert == 'updateCustomer'){
                    //delete[Select id from End_User_Access__c where id IN :NewEndUserRemoteAccessSet OR id IN :NewListForIPSet];
                    List<End_User_Access__c> EndUserIPAccessList = new List<End_User_Access__c>();
                    
                    //Map End User with IP Access record type
                    for (End_User_Access__c EndUser : ListForIP){  
                        End_User_Access__c EU = new End_User_Access__c();
                        EU.Description__c = EndUser.Description__c;
                        EU.IP_Range__c = EndUser.IP_Range__c;
                        EU.Type__c = EndUser.Type__c;
                        EU.Account__c = Account.Id;
                        EU.id = EndUser.id__c;
                        //if(EU.Description__c!='' || EU.IP_Range__c!='' || EU.Type__c!=''){
                        if(String.isNotBlank(EU.Description__c) || String.isNotBlank(EU.IP_Range__c) || String.isNotBlank(EU.Type__c)){    
                            Id recordTypeIdIPAccess = Schema.SObjectType.End_User_Access__c.getRecordTypeInfosByName().get('IP Access').getRecordTypeId();
                            EU.RecordTypeId  = recordTypeIdIPAccess;
                            EndUserIPAccessList.add(EU);
                        }
                    }
                    
                    //Map End User with Remote Access record type
                    for (End_User_Access__c EndUserEntity : EndUserRemoteAccess){                   
                        End_User_Access__c EURemote = new End_User_Access__c();
                        EURemote.Entity_ID__c = EndUserEntity.Entity_ID__c;
                        EURemote.Account__c = Account.Id;
                        EURemote.id = EndUserEntity.id__c;
                        if(String.isNotBlank(EndUserEntity.Entity_ID__c)){
                            
                            Id recordTypeIdRemoteAccess = Schema.SObjectType.End_User_Access__c.getRecordTypeInfosByName().get('Remote Access').getRecordTypeId();
                            EURemote.RecordTypeId  = recordTypeIdRemoteAccess;
                            system.debug(EURemote);
                            EndUserIPAccessList.add(EURemote);
                        }
                    }
                    
                    if(EndUserIPAccessList.size()>0){
                        system.debug(EndUserIPAccessList);
                        upsert EndUserIPAccessList;
                    }
                    
                    Set<id> deleteIpIdSet = new Set<id>();
                    Set<id> deleteRemoteAccessIdSet = new Set<id>();
                    
                    if(NewListForIPSet.size()>0){
                        Set<id> newIpListIdSet = new Set<id>();
                        
                        for(End_User_Access__c ipList: EndUserIPAccessList){
                            newIpListIdSet.add(ipList.id);
                        }
                       
                        for(string OldValues: NewListForIPSet){
                            Boolean idMatch = newIpListIdSet.contains(OldValues);
                            if(!idMatch){
                                deleteIpIdSet.add(OldValues);
                            }
                        }
                    }
                    if(NewEndUserRemoteAccessSet.size()>0){
                        Set<id> newRemoteAccessIdSet = new Set<id>();
                        
                        for(End_User_Access__c remoteList: EndUserIPAccessList){
                            newRemoteAccessIdSet.add(remoteList.id);
                        }
                        for(string OldValuesForRemote: NewEndUserRemoteAccessSet){
                            Boolean idMatchRemote = newRemoteAccessIdSet.contains(OldValuesForRemote);
                            if(!idMatchRemote){
                                deleteRemoteAccessIdSet.add(OldValuesForRemote);
                            }
                        }
                    }
                    system.debug(deleteRemoteAccessIdSet);
                    delete[Select id from End_User_Access__c where id IN :deleteIpIdSet OR id IN :deleteRemoteAccessIdSet];
                    
                }
                
                /*****Insert End User*****/ 
                if(updateOrInsert == 'NewCustomer'){
                    List<End_User_Access__c> insertEndUserIPAccessList = new List<End_User_Access__c>();
                    
                    //Map End User with IP Access record type
                    for (End_User_Access__c EndUser : ListForIP){                   
                        End_User_Access__c EU = new End_User_Access__c();
                        EU.Description__c = EndUser.Description__c;
                        EU.IP_Range__c = EndUser.IP_Range__c;
                        EU.Type__c = EndUser.Type__c;
                        EU.Account__c = Account.Id;
                        //if(EU.Description__c!='' || EU.IP_Range__c!='' || EU.Type__c!=''){
                        if(String.isNotBlank(EU.Description__c) || String.isNotBlank(EU.IP_Range__c) || String.isNotBlank(EU.Type__c)){
                            Id recordTypeIdIPAccess = Schema.SObjectType.End_User_Access__c.getRecordTypeInfosByName().get('IP Access').getRecordTypeId();
                            EU.RecordTypeId  = recordTypeIdIPAccess;
                            insertEndUserIPAccessList.add(EU);
                        }
                    }
                    
                    //Map End User with Remote Access record type
                    for (End_User_Access__c EndUserEntity : EndUserRemoteAccess){                   
                        End_User_Access__c EURemote = new End_User_Access__c();
                        EURemote.Entity_ID__c = EndUserEntity.Entity_ID__c;
                        EURemote.Account__c = Account.Id;
                        if(String.isNotBlank(EURemote.Entity_ID__c)){
                            
                            Id recordTypeIdRemoteAccess = Schema.SObjectType.End_User_Access__c.getRecordTypeInfosByName().get('Remote Access').getRecordTypeId();
                            EURemote.RecordTypeId  = recordTypeIdRemoteAccess;
                            insertEndUserIPAccessList.add(EURemote);
                        }
                    }
                    
                    if(insertEndUserIPAccessList.size()>0){
                        system.debug(insertEndUserIPAccessList);
                        insert insertEndUserIPAccessList;
                    }
                }
                
                /*****Insert and update Contact*****/  
                //if(updateOrInsert == 'NewCustomer'){
                   /**** List<Contact> insertContactList = new List<Contact>();
                    List<Contact> updateContactList = new List<Contact>();
                    //List<Contact> existingContact = new List<Contact>();
                            
                    for (Contact contact : ListForContact){                   
                        Contact con = new Contact();
                        con.LastName = contact.LastName;
                        con.Title = contact.Title;
                        con.Email = contact.Email;
                        con.Phone = contact.Phone;
                        con.Functional_Role__c = contact.Functional_Role__c;
                        con.AccountId = Account.Id;
                        if(con.LastName!='' || con.Title!='' || con.Email!='' || con.Phone!='' || con.Functional_Role__c!=''){
                            
                            
                            
                            if(String.isNotEmpty(contact.Email)){
                                system.debug(contact.Email);
                                
                                List<Contact> existingContact = [Select id, Name, Email from Contact where Email =: contact.Email limit 1];
                                
                                if(existingContact.size() > 0){
                                    con.id = existingContact[0].id;
                                    
                                    updateContactList.add(con);
                                }
                                else{
                                    insertContactList.add(con);
                                }
                                
                            }
                            else{
                                insertContactList.add(con);
                            }
                            //insertContactList.add(con);
                        }
                    }
                    if(insertContactList.size()>0 || updateContactList.size()>0){
                        system.debug(insertContactList);
                        system.debug(NewListForContact);
                        system.debug(updateContactList);
                        
                        if(updateContactList.size()>0){
                            update updateContactList;
                        }
                        
                        delete NewListForContact;
                        
                        if(insertContactList.size()>0){
                            insert insertContactList;
                        }
                    }****/
                    
                //} 
                
                
                /*****Insert Contact List*****/ 
                if(updateOrInsert == 'NewCustomer'){
                    List<Contact> insertContactList = new List<Contact>();
                    List<Contact> updateContactList = new List<Contact>();
                    //List<Contact> existingContact = new List<Contact>();
                            
                    for (Contact contact : ListForContact){                   
                        Contact con = new Contact();
                        con.LastName = contact.LastName;
                        con.Title = contact.Title;
                        con.Email = contact.Email;
                        con.Phone = contact.Phone;
                        con.Functional_Role__c = contact.Functional_Role__c;
                        con.AccountId = Account.Id;
                        
                        //if(con.LastName!='' || con.Title!='' || con.Email!='' || con.Phone!='' || con.Functional_Role__c!=''){
                        if(String.isNotBlank(con.LastName) || String.isNotBlank(con.Title) || String.isNotBlank(con.Email) || String.isNotBlank(con.Phone)){ 
                        if(String.isNotBlank(contact.Email)){
                                List<Contact> existingContact = [Select id, Name, Email,Shared_email_address__c from Contact where Email =: contact.Email limit 1];
                                
                                 if(existingContact.size() > 0 ){
                                   con.Shared_email_address__c=true;
                                   insertContactList.add(con); 
                                }
                                else{
                                    insertContactList.add(con); 
                                }                                
                            }
                            else{
                                insertContactList.add(con);
                            }
                        }
                    }
                    if(insertContactList.size()>0 || updateContactList.size()>0){
                        system.debug(insertContactList);
                        system.debug(updateContactList);
                        
                        if(updateContactList.size()>0){
                            update updateContactList;
                        }
                        if(insertContactList.size()>0){
                            insert insertContactList;
                        }
                    }
                    
                } 
               
                /*****Upsert Contact List*****/  
                if(updateOrInsert == 'updateCustomer'){
                    List<Contact> contactList = new List<Contact>();
                    List<Contact> insertContactList = new List<Contact>();
                    List<Contact> updateContactList = new List<Contact>();
                    system.debug('ListForContact'+ListForContact);
                    for (Contact contact : ListForContact){                   
                        Contact con = new Contact();
                        con.LastName = contact.LastName;
                        con.Title = contact.Title;
                        con.Email = contact.Email;
                        con.Phone = contact.Phone;
                        con.Functional_Role__c = contact.Functional_Role__c;
                        con.AccountId = Account.Id;
                        con.id = contact.id;  
                        if((con.LastName!='' || con.Email!='' || con.Phone!='') && String.isNotEmpty(contact.id)){
                            contactList.add(con);
                        }
                        if(!String.isNotEmpty(contact.id)){
                            List<Contact> existingContact = [Select id, Name, Email from Contact where Email =: contact.Email limit 1];
                                 if(existingContact.size() > 0 ){
                                   con.Shared_email_address__c=true;
                                   insertContactList.add(con); 
                                }
                                else{
                                    insertContactList.add(con); 
                                } 
                        }
                    }
                    
                   
                    if(insertContactList.size()>0){
                        system.debug(insertContactList);
                        //If id is null in the ListForContact then insert that contact 
                        insert insertContactList;
                    }
                    
                    if(NewListForContact.size()>0){
                        if(contactList.size()>0){
                            
                            List<Contact> deleteContactObj = new List<Contact>();
                            List<Contact> updateContactObj = new List<Contact>();
                            Set<id> newConListIdSet = new Set<id>();
                            Set<String> newConListEmailSet = new Set<String>();
                            
                            for(Contact conList: contactList){
                                newConListIdSet.add(conList.id);
                            }
                            
                            for(Contact OldValues: NewListForContact){
                                Boolean idMatch = newConListIdSet.contains(OldValues.id);
                                if(!idMatch){
                                   // deleteContactObj.add(OldValues);
                                }
                                
                                system.debug(idMatch);
                                if(idMatch){
                                    system.debug('updateContactList'+updateContactList +'OldValues.Email'+OldValues.Email+'OldValues.AccountId'+OldValues.AccountId);
                                    List<Contact> existingContact = [Select id, Name, Email, AccountId from Contact where (Email =: OldValues.Email AND AccountId =:OldValues.AccountId) limit 1];
                                    system.debug('existingContact'+existingContact);
                                  
                                    if(existingContact.size() > 0){
                                        /*deleteContactObj.add(existingContact[0]);
                                        updateContactObj.add(OldValues);*/
                                        
                                        /*OldValues.id = existingContact[0].id;
                                        updateContactList.add(OldValues);
                                        system.debug(updateContactList);*/
                                        
                                        //existingContact[0].AccountId = Account.Id;
                                        OldValues.Shared_email_address__c=true;
                                        existingContact[0].Shared_email_address__c=true;
                                        existingContact[0].LastName = OldValues.LastName;
                                        existingContact[0].Title = OldValues.Title;
                                        existingContact[0].Phone = OldValues.Phone;
                                        updateContactObj.add(existingContact[0]);
                                        //deleteContactObj.add(OldValues);
                                        
                                    }else{
                                        updateContactObj.add(OldValues);
                                    }
                                    
                                    //updateContactObj.add(OldValues);
                                }
                            }
                            system.debug(deleteContactObj);
                            if(deleteContactObj.size()>0){
                                //If id is not present in the ListForContact but present in NewListForContact then delete that contact 
                                delete deleteContactObj;
                            }
                            system.debug(updateContactObj);
                            if(updateContactObj.size()>0){
                                system.debug('updateContactObj'+updateContactObj);
                                //If id is present in both ListForContact and NewListForContact then update that contact
                                update updateContactObj;
                            }
                            
                        }
                    }
                    
                    system.debug(updateContactList);
                    if(updateContactList.size()>0){
                        //If email is already exits in Salesforce then update that contact
                        update updateContactList;
                    } 
                    
                }
                
            }            
        } catch (Exception e){  
            System.debug('Message:='+e.getMessage()+'***'+e.getLineNumber());
        }  
        return errorStringSet;
    } 
    
    /**
    * Get Role picklist value
    **/
    @AuraEnabled
    public static Map<String, String> getRoleList(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Contact.Functional_Role__c.getDescribe();
        List<Schema.PicklistEntry> roleList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: roleList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;    
    }
    
    /**
    * Get Type picklist value
    **/
    @AuraEnabled
    public static Map<String, String> getTypeList(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = End_User_Access__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> typeList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: typeList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;    
    }
    
    /**
    * Get list of Account in pending request tab
    **/    
    @AuraEnabled
    public integer offst;
    
    @AuraEnabled  
    public integer total;
    
    @AuraEnabled
    public integer recordStart {get;set;}
    
    @AuraEnabled
    public integer recordEnd {get;set;}
    
    @AuraEnabled
    public Integer pageNumber {get;set;}
        
    @AuraEnabled
    public boolean hasprev;
    
    @AuraEnabled
    public boolean hasnext;
    
    @AuraEnabled
    public Integer pagesize;
    
    @AuraEnabled
    public List<Account> pandingReqAcctList;
    private static integer pagesize=10;
    private static integer offset;
    
    @AuraEnabled
    public static TF_CreateAccountController getAccount(boolean next,boolean prev,Decimal pageNumber,decimal off)
    {
        Integer pNumber = (Integer)pageNumber;
        Integer recordEnd = pagesize * pNumber; 
        
        String SourceOfAccount = souraceOfAccount();
        integer iRecordCount;
        offset = (integer)off;
        
        List<Account> pandingReqAcctList;
        String AccountRequest = 'Third Party Account Request';
        String StatusApproval = 'Submitted for Approval';
        String StatusDraft = 'Draft';
        TF_CreateAccountController pg = new TF_CreateAccountController();
        
        if(SourceOfAccount == 'GOBI'){
            iRecordCount=Database.countQuery('Select Count() FROM Account where ((RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: AccountRequest)) AND Source_of_Account__c INCLUDES (\'GOBI\') AND (Onboarding_Status__c LIKE: StatusApproval OR Onboarding_Status__c LIKE: StatusDraft))');
        }        
        if(SourceOfAccount == 'ProQuest'){
            iRecordCount=Database.countQuery('Select Count() FROM Account where ((RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: AccountRequest)) AND Source_of_Account__c INCLUDES (\'ProQuest\') AND (Onboarding_Status__c LIKE: StatusApproval OR Onboarding_Status__c LIKE: StatusDraft))');
        }
        
        if(next==false && prev==false){
            
        }else if(next==true && (offset+pagesize)<=iRecordCount){
            offset=offset+pagesize;
        }else if(prev==true && offset>0){
            offset=offset-pagesize;
        }  
        
        if(SourceOfAccount == 'GOBI'){
            pandingReqAcctList = [select id, Name, Shipping_State_List__c, Billing_State_List__c, Mailing_State_List__c, Billing_Street_Account_Request__c, Shipping_Street_Account_Request__c, Mailing_Street_Account_Request__c, Onboarding_Status__c, Source_of_Account__c, Aggregator_identifier__c, Phone, Website, BillingStreet, BillingCity, BillingPostalCode, Mailing_Country_List__c, BillingState, ShippingStreet, ShippingCity, ShippingPostalCode, Shipping_Country_List__c, ShippingState, Billing_Street__c, Billing_City__c, Billing_ZIP__c, Billing_Country_List__c, Billing_State__c, Ringgold_Account_ID__c, Request_Notes__c , (select id, LastName, Phone, Email, Title, Functional_Role__c from contacts), (select id, Entity_ID__c, Description__c, IP_Range__c, Type__c,Id__c from End_User_Accesses__r) from Account where ((RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Third Party Account Request')) AND Source_of_Account__c INCLUDES ('GOBI') AND (Onboarding_Status__c = 'Submitted for Approval' OR Onboarding_Status__c = 'Draft')) ORDER BY LastModifiedDate DESC LIMIT :pagesize OFFSET :offset];
            system.debug(pandingReqAcctList);
        }
        if(SourceOfAccount == 'ProQuest'){
            pandingReqAcctList = [select id, Name, Shipping_State_List__c, Billing_State_List__c, Mailing_State_List__c, Billing_Street_Account_Request__c, Shipping_Street_Account_Request__c, Mailing_Street_Account_Request__c, Onboarding_Status__c, Source_of_Account__c, Aggregator_identifier__c, Phone, Website, BillingStreet, BillingCity, BillingPostalCode, Mailing_Country_List__c, BillingState, ShippingStreet, ShippingCity, ShippingPostalCode, Shipping_Country_List__c, ShippingState, Billing_Street__c, Billing_City__c, Billing_ZIP__c, Billing_Country_List__c, Billing_State__c, Ringgold_Account_ID__c,Request_Notes__c , (select id, LastName, Phone, Email, Title, Functional_Role__c from contacts), (select id, Entity_ID__c, Description__c, IP_Range__c, Type__c,Id__c from End_User_Accesses__r) from Account where ((RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Third Party Account Request')) AND Source_of_Account__c INCLUDES ('ProQuest') AND (Onboarding_Status__c = 'Submitted for Approval' OR Onboarding_Status__c = 'Draft')) ORDER BY LastModifiedDate DESC LIMIT :pagesize OFFSET :offset ];
            system.debug(pandingReqAcctList);
        }
        
        //pandingReqAcctList= [select id, Name, Account_Status__c, Phone, Website, BillingStreet, BillingCity, BillingPostalCode, Mailing_Country_List__c, BillingState, ShippingStreet, ShippingCity, ShippingPostalCode, Shipping_Country_List__c, ShippingState, Billing_Street__c, Billing_City__c, Billing_ZIP__c, Billing_Country_List__c, Billing_State__c, Ringgold_Account_ID__c, (select id, LastName, Phone, Email, Title, Functional_Role__c from contacts), (select id, Entity_ID__c, Description__c, IP_Range__c, Type__c from End_User_Accesses__r) from Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Third Party Account Request')) LIMIT :pagesize OFFSET :offset];
        pg.pandingReqAcctList = pandingReqAcctList; 
        pg.offst = offset;
        pg.hasprev = hasprev(offset); 
        pg.hasnext = hasnxt(offset,iRecordCount,pagesize);
        pg.total = iRecordCount;
        pg.recordStart = offset+1;
        pg.pageNumber = pNumber;
        pg.pagesize = 10;
        pg.recordEnd = iRecordCount >= recordEnd ? recordEnd : iRecordCount;
        
        return pg;
    } 
    private static boolean hasprev(integer off){
        if(off>0)
            return false;
        return true;}
    private static boolean hasnxt(integer off,integer li,integer ps){
        if(off+ps<li)
            return false;
        return true;}
    
    @AuraEnabled
    public integer offstSearch;
    
    @AuraEnabled
    public integer totalSearch;
    
    @AuraEnabled
    public integer RecordStartSearch {get;set;}
    
    @AuraEnabled
    public integer RecordEndSearch {get;set;}
    
    @AuraEnabled
    public Integer PageNumberSearch {get;set;}
        
    @AuraEnabled
    public boolean hasPrevSearch;
    
    @AuraEnabled
    public boolean hasNextSearch;
    
    @AuraEnabled
    public Integer pageSizeSearch;
    
    @AuraEnabled
    public List<AccountData> ListOfAccount;
    private static integer pageSizeSearch=10;
    private static integer offSetSearch;
    
    /**
    * Fetch Account by Name or createdDate in approved customer tab
    **/
    @AuraEnabled 
    public static TF_CreateAccountController fetchAccountDataByName(String searchNameKeyword, Date startDate, Date endDate, boolean nextSearch,boolean prevSearch,Decimal PageNumberSearch,decimal off) 
    {
        Integer pNumber = (Integer)PageNumberSearch;
        Integer recordEnd = pageSizeSearch * pNumber; 
        
        integer iRecordCount;
        offSetSearch = (integer)off;
        system.debug(offSetSearch);
        List<AccountData> ListOfAccount1 = new List<AccountData>();
        List<Account> ListOfAccountWithData = new List<Account>();
        String TandFAccounts = 'T&F - Accounts';
        String TandFConsortium = 'T&F - Consortium';
        String Approved ='Approved';
        String searchKey = searchNameKeyword + '%';
        
        TF_CreateAccountController search = new TF_CreateAccountController();
        String SourceOfAccount = souraceOfAccount();
        
        if(SourceOfAccount == 'GOBI'){
            //iRecordCount=Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'GOBI\') AND Onboarding_Status__c LIKE: Approved)');
          if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate == null && endDate == null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND Name LIKE: searchKey  AND Source_of_Account__c INCLUDES (\'GOBI\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate != null && endDate != null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND Name LIKE: searchKey AND (CreatedDate>=:startDate AND CreatedDate<=:endDate)  AND Source_of_Account__c INCLUDES (\'GOBI\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate == null && endDate == null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'GOBI\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate != null && endDate != null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'GOBI\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            } 
        }        
        if(SourceOfAccount == 'ProQuest'){
            //iRecordCount=Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'ProQuest\') AND Onboarding_Status__c LIKE: Approved)');
            if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate == null && endDate == null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND Name LIKE: searchKey AND Source_of_Account__c INCLUDES (\'ProQuest\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate != null && endDate != null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND Name LIKE: searchKey AND (CreatedDate>=:startDate AND CreatedDate<=:endDate)  AND Source_of_Account__c INCLUDES (\'ProQuest\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate == null && endDate == null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'ProQuest\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate != null && endDate != null){
                iRecordCount = Database.countQuery('Select Count() FROM Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name LIKE: TandFAccounts OR Name LIKE: TandFConsortium) AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES (\'ProQuest\') AND Onboarding_Status__c LIKE: Approved)');
              system.debug(iRecordCount);
            }
        }
        
        if(nextSearch==false && prevSearch==false){
            
        }else if(nextSearch==true && (offSetSearch+pageSizeSearch)<=iRecordCount){
            offSetSearch = offSetSearch+pageSizeSearch;
        }else if(prevSearch==true && offSetSearch>0){
      offSetSearch = offSetSearch-pageSizeSearch;
        }  
        
        try{
            //String searchKey = searchNameKeyword + '%';
            if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate == null && endDate == null){  
                //ListOfAccount= [select id, Name, Phone, Account_Status__c from Account where (Name LIKE: searchKey AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Account Request') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Account_Status__c = 'Submit for Approval')];
                if(SourceOfAccount == 'GOBI'){
                    ListOfAccountWithData = [select id, Name, Customer_Id__c, Ringgold_Account_ID__c, Source_of_Account__c, Onboarding_Status__c, (Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'GOBI') from Account where (Name LIKE: searchKey AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('GOBI') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
                if(SourceOfAccount == 'ProQuest'){
                    ListOfAccountWithData = [select id, Name, Customer_Id__c, Ringgold_Account_ID__c, Source_of_Account__c, Onboarding_Status__c, (Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'ProQuest') from Account where (Name LIKE: searchKey AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('ProQuest') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
            }
            if((String.isNotEmpty(searchNameKeyword) || String.isNotBlank(searchNameKeyword)) && startDate != null && endDate != null){
                if(SourceOfAccount == 'GOBI'){
                    ListOfAccountWithData = [select id, Customer_Id__c, Ringgold_Account_ID__c, Name, Source_of_Account__c, Onboarding_Status__c,(Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'GOBI') from Account where (Name LIKE: searchKey AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('GOBI') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
                if(SourceOfAccount == 'ProQuest'){
                    ListOfAccountWithData = [select id, Customer_Id__c, Ringgold_Account_ID__c, Name, Source_of_Account__c, Onboarding_Status__c, (Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'ProQuest') from Account where (Name LIKE: searchKey AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('ProQuest') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate != null && endDate != null){  
                if(SourceOfAccount == 'GOBI'){
                    ListOfAccountWithData = [select id, Name, Customer_Id__c, Ringgold_Account_ID__c, Source_of_Account__c, Onboarding_Status__c,(Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'GOBI') from Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('GOBI') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
                if(SourceOfAccount == 'ProQuest'){
                    ListOfAccountWithData = [select id, Name, Customer_Id__c, Ringgold_Account_ID__c, Source_of_Account__c, Onboarding_Status__c, (Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'ProQuest') from Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND (CreatedDate>=:startDate AND CreatedDate<=:endDate) AND Source_of_Account__c INCLUDES ('ProQuest') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
            }
            if((String.isEmpty(searchNameKeyword) || String.isBlank(searchNameKeyword)) && startDate == null && endDate == null){
                if(SourceOfAccount == 'GOBI'){
                    ListOfAccountWithData = [select id, Customer_Id__c, Ringgold_Account_ID__c, Name, Source_of_Account__c, Onboarding_Status__c,(Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'GOBI') from Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND Source_of_Account__c INCLUDES ('GOBI') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
                if(SourceOfAccount == 'ProQuest'){
                    ListOfAccountWithData = [select id, Customer_Id__c, Ringgold_Account_ID__c, Name, Source_of_Account__c, Onboarding_Status__c , (Select Request_Account_Name__c, Request_CreatedBy__c, Requested_Date__c, Source_of_Account__c  From Account_Request_Details__r where Source_of_Account__c = 'ProQuest') from Account where (RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'T&F - Accounts' OR Name = 'T&F - Consortium') AND Source_of_Account__c INCLUDES ('ProQuest') AND Onboarding_Status__c ='Approved') ORDER BY LastModifiedDate DESC LIMIT :pageSizeSearch OFFSET :offSetSearch];
                    system.debug(ListOfAccountWithData);
                }
            }
       }
        catch(Exception e){
            System.debug('Message:='+e.getMessage()+'***'+e.getLineNumber());
        }
        if(ListOfAccountWithData != null && ListOfAccountWithData.size() > 0){
            for( Account thisAccount : ListOfAccountWithData){
                if(thisAccount.Account_Request_Details__r != null && thisAccount.Account_Request_Details__r.size() > 0){
                    for(Account_Request_Details__c thisARD : thisAccount.Account_Request_Details__r){
                        if(thisARD.Source_of_Account__c == thisAccount.Source_of_Account__c){
                            AccountData thisData = new AccountData();
                            thisData.id = thisAccount.id;
                            thisData.Customer_Id_c = thisAccount.Customer_Id__c;
                            thisData.Ringgold_Account_ID_c = thisAccount.Ringgold_Account_ID__c;
                            thisData.Name = thisAccount.Name;
                            thisData.Source_of_Account_c = thisAccount.Source_of_Account__c;
                            thisData.Onboarding_Status_c = thisAccount.Onboarding_Status__c;
                            thisData.Request_Account_Name_c = thisARD.Request_Account_Name__c;
                            thisData.Request_CreatedBy_c = thisARD.Request_CreatedBy__c;
                            thisData.Requested_Date_c = thisARD.Requested_Date__c; 
                            ListOfAccount1.add(thisData);
                        }
                    }
                }else{
                    AccountData thisData = new AccountData();
                    thisData.id = thisAccount.id;
                    thisData.Customer_Id_c = thisAccount.Customer_Id__c;
                    thisData.Ringgold_Account_ID_c = thisAccount.Ringgold_Account_ID__c;
                    thisData.Name = thisAccount.Name;
                    thisData.Source_of_Account_c = thisAccount.Source_of_Account__c;
                    thisData.Onboarding_Status_c = thisAccount.Onboarding_Status__c;
                    ListOfAccount1.add(thisData); 
                    

                }
            }
            System.debug('ListOfAccount : ' +ListOfAccount1);

        }
        
        search.ListOfAccount = ListOfAccount1; 
        search.offstSearch = offSetSearch;
        search.hasPrevSearch = hasprevSearch(offSetSearch); 
        search.hasNextSearch = hasnxtSearch(offSetSearch,iRecordCount,pageSizeSearch);
        search.totalSearch = iRecordCount;
        search.RecordStartSearch = offSetSearch+1;
        search.PageNumberSearch = pNumber;
        search.pageSizeSearch = 10;
        search.recordEnd = iRecordCount >= recordEnd ? recordEnd : iRecordCount;
        system.debug(search);
        return search;
    } 
    private static boolean hasprevSearch(integer off){
        if(off>0)
            return false;
        return true;}
    private static boolean hasnxtSearch(integer off,integer li,integer ps){
        if(off+ps<li)
            return false;
        return true;}
  
    /**
    * Fetch current User details
    **/    
    @AuraEnabled(cacheable=true) 
    public static user fetchUser(){ 
        User currentUser = [select id,Name,SmallPhotoUrl FROM User Where id =: userInfo.getUserId()];
        return currentUser;
    }
            
    /**
    * Get aggregator identifier field value of current login user's account
    **/
    @AuraEnabled(cacheable=true)
    public static string souraceOfAccount(){
        User currentUserAccount = [select id, Contact.AccountId from User where id =:UserInfo.getUserId()];
        Account SourceAccount = [select id, Aggregator_identifier__c from Account where Id =: currentUserAccount.Contact.AccountId];
        String SourceOfAccount = SourceAccount.Aggregator_identifier__c;
        return SourceOfAccount;
    } 
    
    
    @AuraEnabled(cacheable=true) 
    public static Map<String, List<String>> getMailingDependentMap(sObject Account, string contrfieldApiName, string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = Account.getSObjectType();
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
    
    
    @AuraEnabled(cacheable=true) 
    public static Map<String, List<String>> getShippingDependentMap(sObject Account, string contrfieldApiName, string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = Account.getSObjectType();
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
        List<PicklistEntryWrapperShipping> depEntries = wrapPicklistEntriesShipping(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapperShipping plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }  

    private static List<PicklistEntryWrapperShipping> wrapPicklistEntriesShipping(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapperShipping>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapperShipping>.class);
    }
    
    public class PicklistEntryWrapperShipping{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapperShipping(){            
        }
        
    }
    
    @AuraEnabled(cacheable=true) 
    public static Map<String, List<String>> getBillingDependentMap(sObject Account, string contrfieldApiName, string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = Account.getSObjectType();
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
        List<PicklistEntryWrapperBilling> depEntries = wrapPicklistEntriesBilling(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapperBilling plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }  
    
    private static List<PicklistEntryWrapperBilling> wrapPicklistEntriesBilling(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapperBilling>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapperBilling>.class);
    }
    
    public class PicklistEntryWrapperBilling{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}  
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapperBilling(){            
        }
    }
    
    /**
    * Delete Account from salesforce on click of delete button in pending request tab
    **/
    @AuraEnabled
    public static void deleteAccount(Account acc){
        Delete acc;
    } 
}