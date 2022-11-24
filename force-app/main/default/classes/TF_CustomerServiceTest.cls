@IsTest(SeeAllData=false)
public class TF_CustomerServiceTest {
    
    @isTest
    private static void test_addCustomer_AccountSettings(){

        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/addCustomer';
        request.httpMethod = 'POST';
        String myJSON='{ "contact": { "partyId": "string", "dob": "04-17-1998", "firstName": "Test", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "nvccvsfcd@gmail.com", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        /*request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
      */  
        request.requestUri ='/services/apexrest/v1/customers/addCustomer';
        String notifyJSON='{ "contact": { "partyId": "string", "dob": "04-17-1998", "firstName": "Test", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
        
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        TF_CustomerService.doPost();
        
        request.requestUri ='/services/apexrest/v1/customers/123/account-settings';
        TF_CustomerService.doPost();
        
        request.requestUri ='/services/apexrest/v1/customers/100/account-settings';
        TF_CustomerService.doPost();
        
        request.requestUri ='/services/apexrest/v1/customers//account-settings';
        TF_CustomerService.doPost();
        
        
        TF_CustomerService.CustomerResponse test = new TF_CustomerService.CustomerResponse();
        TF_CustomerService.Customer updateCustomerRequest = (TF_CustomerService.Customer)JSON.deserialize(myJSON, TF_CustomerService.Customer.class);
        
        test.error(updateCustomerRequest, 'exceptionDetails');
        test.setAdditionField('key', 'val');
        test.clear();
        
        
    }
    
    @isTest
    private static void test_addCustomer_invalidRequest(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/addCustomer';
        request.httpMethod = 'POST';
        String notifyJSON='{ "contact": { "partyId": "1323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }]} }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
        Test.stopTest();
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '1323657' limit 1];
        System.assertEquals(0,contactList.size());

    }
    
    @isTest
    private static void test_updateCustomer(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'Tester');
        
        List< Platform_Role__c> platformRoleList = [SELECT id, Name, Account__c,Contact__c,Platform__c,Roles__c FROM Platform_Role__c WHERE Contact__c =: contactList[0].id ];
        System.assert(platformRoleList != null);
        System.assertEquals(platformRoleList.size(),1);
        System.assertEquals(testAccount.id,platformRoleList[0].Account__c);
        System.assertEquals('librarian_admin',platformRoleList[0].Roles__c);
    }
    
    @isTest
    private static void test_updateCustomer_invalidRequest(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1214@xyz.com';
        newContact.Party_Id__c = '1323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "1323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }]} }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '1323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'test');

    }
    
    @isTest
    private static void test_updateCustomer_ContactNotPresentException(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1214@xyz.com';
        newContact.Party_Id__c = '1423657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        try{
        Test.startTest();
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "1323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] } }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '1423657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'test');
        } catch(Exception ex){
            System.assertEquals('Contact not found with this party Id',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_updateCustomer_NullPartyIdException(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1214@xyz.com';
        newContact.Party_Id__c = '1423657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        insert newContact;
        try{
        Test.startTest();
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] } }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '1423657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'test');
        } catch(Exception ex){
            System.assertEquals('Party Id cannot be null',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_updateCustomer_ContactListwith2samecontact(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        try{
        Test.startTest();
        insert newContact;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "test1234@xyz.com", "partySfdcId": "string", "contactType": "primary" },{ "contactNumber": "51251521265", "email": "test1231@xyz.com", "partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertEquals(contactList[0].FirstName, 'test');
        }catch(Exception ex){
            System.assertEquals('Both Contacts cannot have the same type',ex.getMessage());
        }
        

    }
    
    @isTest
    private static void test_updateCustomer_emailNotValid(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        try{
        Test.startTest();
        insert newContact;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "test1234xyz.com","partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertNotEquals(contactList[0].FirstName, 'Tester');
        } catch(Exception ex){
            System.assertEquals('Contact email is invalid',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_updateCustomer_AddressListwith2SameAddresstype(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        try{
        Test.startTest();
        insert newContact;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomer';
        request.httpMethod = 'PUT';
        String notifyJSON='{ "contact": { "partyId": "12323657", "dob": "04-17-1998", "firstName": "Tester", "fullName": "string", "lastName": "Test1", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "12233", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" },{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, AMD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "contactList": [{ "contactNumber": "51251521365", "email": "test1234@xyz.com","partySfdcId": "string", "contactType": "primary" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "'+testAccount.id+'", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "s" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "<value of reference attribute>" }] }, "organisations": [{ "partyId": "string", "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "consortium", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "sfdcEnrollment": "string", "sfdcCategory": "srtring", "sfdcNumberOfEmployees": "number", "sfdcClassification": "string", "sfdcType": "string", "sfdcLegalSubcategory": "string", "addressList": [{ "addressId": "string", "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [{ "identifierType": "ringGoldId", "identifierValue": "<toIdentifyOrg>", "objectType": "consortium", "relationshipType": "child/parent" }] }, { "name": "string", "parentRingGoldId": "string", "ringGoldId": "string", "sourceOrgId": "", "organisationType": "string<lookup>", "partySfdcId": "", "description": "string", "isni": "string", "isniName": "string", "url": "string", "comments": "string", "isTestOrg": "boolean", "addressList": [{ "addressLine1": "string", "addressLine2": "string", "addressLine3": "string", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "string", "postalCode": "string", "state": "string", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "string", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }], "relationships": [] } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPut();
        Test.stopTest();
        List<contact> contactList = [SELECT id, Email, FirstName, LastName, AccountId, Party_Id__c FROM Contact WHERE Party_Id__c = '12323657' limit 1];
        System.assert(contactList != null);
        System.assertEquals(contactList.size(),1);
        System.assertNotEquals(contactList[0].FirstName, 'Tester');
        } catch(Exception ex){
            System.assertEquals('Contact cannot have more than one Address with Same Address Type',ex.getMessage());
        }

    }
    
    @isTest
    private static void test_addCustomerAddress(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '33323657';
        insert testAccount;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/addCustomerAddress/33323657/customerAddress';
        request.httpMethod = 'POST';
        String notifyJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, BillingStreet,Billing_BP_Details__c,Billing_BP_Number__c,Billing_City__c,Billing_Country_List__c,Billing_Country__c,Billing_Region__c,Billing_State_List__c,Billing_State__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Billing_BP_Number__c);
        System.assertEquals('Alabama', account[0].Billing_State__c);
    }
    
    @isTest
    private static void test_addCustomerAddress_partyIdNull(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '33323657';
        insert testAccount;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/addCustomerAddress//customerAddress';
        request.httpMethod = 'POST';
        String notifyJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, BillingStreet,Billing_BP_Details__c,Billing_BP_Number__c,Billing_City__c,Billing_Country_List__c,Billing_Country__c,Billing_Region__c,Billing_State_List__c,Billing_State__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertNotEquals('1237248', account[0].Billing_BP_Number__c);
        System.assertNotEquals('Alabama', account[0].Billing_State__c);
    }
    
    @isTest
    private static void test_updateCustomerAddress(){
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '33323657';
        insert testAccount;

        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/updateCustomerAddress/33323657/customerAddress';
        request.httpMethod = 'PATCH';
        String notifyJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPatch();
        Test.stopTest();
        
        List< Account> account = [SELECT id, Name, BillingStreet,Billing_BP_Details__c,Billing_BP_Number__c,Billing_City__c,Billing_Country_List__c,Billing_Country__c,Billing_Region__c,Billing_State_List__c,Billing_State__c FROM Account WHERE id =: testAccount.id ];
        System.assert(account != null);
        System.assertEquals(account.size(),1);
        System.assertEquals('1237248', account[0].Billing_BP_Number__c);
        System.assertEquals('Alabama', account[0].Billing_State__c);
    }
    
    @isTest
    private static void test_updateCustomerAddress_adressCannotBeUpdated(){
        try{
            Account testAccount = new Account();
            testAccount.name = 'Test Account';
            testAccount.type = 'Agent';
            testAccount.Customer_Id__c = '33323657';
            testAccount.Billing_BP_Number__c = '221122';
            insert testAccount;
    
            Test.startTest();
            RestRequest request = new RestRequest();
            RestResponse res = new RestResponse();
            request.requestUri ='/services/apexrest/v1/customers/updateCustomerAddress/33323657/customerAddress';
            request.httpMethod = 'PATCH';
            String notifyJSON='{ "addressId": "string", "addressLine1": "109", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "1237248", "bpPartnerFunction": "BP", "bpBusinessPartnerFunction": "string", "countryCode": "string", "usStateCode": "string", "emailAddress": "string@json.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" }';
            request.requestBody = Blob.valueof(notifyJSON);
            RestContext.request = request;
            RestContext.response = res;
            TF_CustomerService.doPatch();
            Test.stopTest();
            
            List< Account> account = [SELECT id, Name, BillingStreet,Billing_BP_Details__c,Billing_BP_Number__c,Billing_City__c,Billing_Country_List__c,Billing_Country__c,Billing_Region__c,Billing_State_List__c,Billing_State__c FROM Account WHERE id =: testAccount.id ];
            System.assert(account != null);
            System.assertEquals(account.size(),1);
            System.assertNotEquals('1237248', account[0].Billing_BP_Number__c);
            System.assertNotEquals('Alabama', account[0].Billing_State__c);
        }catch(Exception ex){
            System.assertEquals('Address associated with a BP number cannot be updated',ex.getMessage());
        }
    }
    
    @isTest
    private static void test_addCustomer_addOrUpdateOrganisations(){
        User testUser = new User();
        testUser.username = 'testuser123@fgg.com';
        testUser.firstName='FName';
        testUser.LastName='LName';
        testUser.Email='testuser@xyz.com';
        testUser.Alias='Test';
        testUser.TimeZoneSidKey='GMT';
        testUser.LocaleSidKey='en_US';
        testUser.EmailEncodingKey='ISO-8859-1';
        SObject profTest = [ select id from profile where Name= 'System Administrator' LIMIT 1];
        testUser.ProfileId=(ID) profTest.get('ID'); 
        testUser.LanguageLocaleKey = 'en_US';
        testUser.CommunityNickname = 'Test01';
        insert  testUser;
       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.ownerid = testUser.id;
        testAccount.type = 'Agent';
        insert testAccount;
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/customers/addCustomer';
        request.httpMethod = 'POST';
        String notifyJSON='{ "contact": { "partyId": "string", "dob": "04-17-1998", "firstName": "TestPurpose", "fullName": "TestAddCustomer", "lastName": "AddCustomer", "orcid": "string", "partySfdcId": "string", "addressList": [{ "addressId": "string", "addressLine1": "108 ", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "billing", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "", "usStateCode": "", "emailAddress": "testRandom@gmail.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" },{ "addressId": "string", "addressLine1": "120 ", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressEndDate": "timestamp", "addressStartDate": "timestamp", "addressType": "shipping", "city": "AL", "postalCode": "36067", "state": "Alabama", "country": "United States", "province": "", "contactType": "primary", "bpNumber": "string", "bpPartnerFunction": "SP", "bpBusinessPartnerFunction": "string", "countryCode": "", "usStateCode": "", "emailAddress": "testRandom@gmail.com", "title": "string", "firstName": "string", "lastName": "string", "telephone": "string", "taxRegistrationNumber": "string", "taxNumberCategory": "string" } ], "contactList": [ { "contactNumber": "51251521365", "email": "settings@gmail.com", "partySfdcId": "string", "contactType": "primary" }, { "contactNumber": "51251521365", "email": "alternate@gmail.com", "partySfdcId": "string", "contactType": "alternate" }], "relationships": [{ "identifierType": "sfid", "identifierValue": "0011l00000Edmim", "relationshipType": "librarian_admin" }], "preferences": [{ "preferenceName": "opt_in", "preferenceValue": "" }], "references": [{ "orgId": "<organisation party id>", "name": "OPENATHENS", "id": "6516544154316" }, { "orgId": "<organisation party id>", "name": "SAML", "id": "5158451" }, { "orgId": "<organisation party id>", "name": "SHIBBOLETH", "id": "<value of reference attribute>" }, { "orgId": "<organisation party id>", "name": "ORCID", "id": "<value of reference attribute>" }] }, "organisations": [ { "accountSettings": {}, "addressList": [ { "addressEndDate": "string", "addressId": 0, "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressStartDate": "string", "addressType": "billing", "bpBusinessPartnerCategory": "string", "bpNumber": "string", "bpPartnerFunction": "string", "city": "AL", "contactType": "string", "country": "United States", "countryCode": "string", "emailAddress": "string", "firstName": "string", "lastName": "string", "postalCode": "36067", "province": "string", "state": "Alabama", "taxNumberCategory": "string", "taxRegistrationNumber": "string", "telephone": "string", "title": "string", "usStateCode": "string" }, { "addressEndDate": "string", "addressId": 0, "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressStartDate": "string", "addressType": "shipping", "bpBusinessPartnerCategory": "string", "bpNumber": "string", "bpPartnerFunction": "string", "city": "AL", "contactType": "string", "country": "United States", "countryCode": "string", "emailAddress": "string", "firstName": "string", "lastName": "string", "postalCode": "36067", "province": "string", "state": "Alabama", "taxNumberCategory": "string", "taxRegistrationNumber": "string", "telephone": "string", "title": "string", "usStateCode": "string" } ], "comments": "string", "description": "string", "isTestOrg": true, "isni": "string", "isniName": "string", "name": "TestAccount4", "organisationType": "string", "parentRingGoldId": "string", "partyId": 0, "partySfdcId": "string", "relationships": [ { "identifierType": "name", "identifierValue": "TestAccount", "objectType": "string", "relationshipType": "string" } ], "ringGoldId": "425425", "sfdcCategory": "string", "sfdcClassification": "string", "sfdcEnrollment": "string", "sfdcLegalSubcategory": "string", "sfdcNumberOfEmployees": 0, "sfdcType": "string", "sourceOrgId": 0, "url": "string" }, { "accountSettings": {}, "addressList": [ { "addressEndDate": "string", "addressId": 0, "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressStartDate": "string", "addressType": "billing", "bpBusinessPartnerCategory": "string", "bpNumber": "string", "bpPartnerFunction": "string", "city": "AL", "contactType": "string", "country": "United States", "countryCode": "string", "emailAddress": "string", "firstName": "string", "lastName": "string", "postalCode": "36067", "province": "string", "state": "Alabama", "taxNumberCategory": "string", "taxRegistrationNumber": "string", "telephone": "string", "title": "string", "usStateCode": "string" }, { "addressEndDate": "string", "addressId": 0, "addressLine1": "108", "addressLine2": "Oak Valley Dr.", "addressLine3": "Suitland, MD 20746", "addressStartDate": "string", "addressType": "shipping", "bpBusinessPartnerCategory": "string", "bpNumber": "string", "bpPartnerFunction": "string", "city": "AL", "contactType": "string", "country": "United States", "countryCode": "string", "emailAddress": "string", "firstName": "string", "lastName": "string", "postalCode": "36067", "province": "string", "state": "Alabama", "taxNumberCategory": "string", "taxRegistrationNumber": "string", "telephone": "string", "title": "string", "usStateCode": "string" } ], "comments": "string", "description": "string", "isTestOrg": true, "isni": "string", "isniName": "string", "name": "FinalAccount", "organisationType": "string", "parentRingGoldId": "string", "partyId": 0, "partySfdcId": "string", "relationships": [ { "identifierType": "name", "identifierValue": "tt", "objectType": "string", "relationshipType": "string" } ], "ringGoldId": "2865", "sfdcCategory": "string", "sfdcClassification": "string", "sfdcEnrollment": "string", "sfdcLegalSubcategory": "string", "sfdcNumberOfEmployees": 0, "sfdcType": "string", "sourceOrgId": 0, "url": "string" } ] }';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        TF_CustomerService.doPost();
        Test.stopTest();
    }
}