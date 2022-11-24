@isTest(seeAllData=false)
public class TF_ValidateIPRangeCalloutControllerTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata": {"status": "success","message": {}},"data": {"isIpRangeExists": true,"partyId": "100504"}}';
    private static String mockJsonResponse_Error = '{"metadata": {"status": "failure","message": {"key": "Invalid input","value": "ipStart or ipEnd cannot be empty"}},"data": null}';

    public TF_ValidateIPRangeCalloutControllerTest(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }
    
     public HTTPResponse respond(HTTPRequest req) {
       // Create a mock response
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setBody(responseJson);      
        resp.setStatusCode(statusCode);
        return resp;
    }
      
     @istest 
     private static void test_getCalloutResponseContents_Success(){
        TF_OrgSpecificProps__c  ipAPI = new TF_OrgSpecificProps__c ();
        ipAPI.IP_Validate_URL__c  ='https://api-dev.taylorandfrancis.com/v1/ips?';
        insert ipAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount; 
        
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 1'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_ValidateIPRangeCalloutControllerTest(200, mockJsonResponse_Success));
         List <TF_ValidateIPRangeCalloutController.DataWrapper> responseData = TF_ValidateIPRangeCalloutController.getCalloutResponseContents(testAccount.id);
         System.assert(responseData != null);
         Test.stopTest();
       
     }
     @istest 
     private static void test_getCalloutResponseContents_Error(){
        TF_OrgSpecificProps__c  ipAPI = new TF_OrgSpecificProps__c ();
        ipAPI.IP_Validate_URL__c  = 'https://api-dev.taylorandfrancis.com/v1/ips?';
        insert ipAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount;  
        
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 2'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_ValidateIPRangeCalloutControllerTest(400, mockJsonResponse_Error));
         List <TF_ValidateIPRangeCalloutController.DataWrapper> responseData = TF_ValidateIPRangeCalloutController.getCalloutResponseContents(testAccount.id);
         System.assert(responseData == null);
         Test.stopTest();
       
     }
     
     @istest 
     private static void test_updateThirdPartyAccountRejStatus(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United Kingdom';
        countryCode.Country_2__c = 'UK';
        insert countryCode;
         
        Account testAccount = new Account();
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '1231';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        newContact.AccountId = testAccount.id;
        insert newContact;
        
        Contact newContact2 = new Contact();
        newContact2.email = 'test5678@xyz.com';
        newContact2.Party_Id__c = '12323658';
        newContact2.FirstName = 'test';
        newContact2.LastName = '02';
        newContact2.AccountId = testAccount.id;
        insert newContact2;
        
        Account testParentAccount = new Account();
        testParentAccount.name = 'Test Account';
        testParentAccount.type = 'Agent';
        testParentAccount.Customer_Id__c = '123';
        testParentAccount.Ringgold_Account_ID__c = '5629';
        testParentAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testParentAccount;
        
        Contact newContact3 = new Contact();
        newContact3.email = 'test2233@xyz.com';
        newContact3.Party_Id__c = '12323617';
        newContact3.FirstName = 'testAccCon';
        newContact3.LastName = 'acc01';
        newContact3.AccountId = testParentAccount.id;
        insert newContact3;
        
        Contact newContact4 = new Contact();
        newContact4.email = 'test5678@xyz.com';
        newContact4.Party_Id__c = '12320658';
        newContact4.FirstName = 'test';
        newContact4.LastName = 'acc02';
        newContact4.AccountId = testParentAccount.id;
        newContact4.Shared_email_address__c = true;
        insert newContact4;
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 1'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';
        String ipjson = '[{"allowReject":true,"description":"test ip","errorMsg":"121","ipRange":"10.02.11.11:20.11.11.11","name":"EUA-0492","sfid":"'+ip.id+'","status":"Failed"}]';
         Test.startTest();
         TF_ValidateIPRangeCalloutController.updateThirdPartyAccountRejStatus(testAccount.id, '123', ipjson);
         Test.stopTest();
         Account thisAccount = [Select id, Onboarding_Status__c from Account where id=: testAccount.id];
         System.assertEquals('Rejected', thisAccount.Onboarding_Status__c );
         Account thisParentAccount = [Select id, Source_of_Account__c, Onboarding_Status__c from Account where id=: testParentAccount.id];
         System.assertEquals('GOBI', thisParentAccount.Source_of_Account__c );
         List<Contact> thisConList = [Select id, name from Contact where Accountid=: thisParentAccount.id];
         System.assertEquals(3, thisConList.size() );
         List<Contact> newAccConList = [Select id, name from Contact where Accountid=: testAccount.id];
         System.assertEquals(0, newAccConList.size() );
     }
     
     @istest 
     private static void test_updateThirdPartyAccountRejStatus_dupContact(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United Kingdom';
        countryCode.Country_2__c = 'UK';
        insert countryCode;
         Account testAccount = new Account();
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '1231';
         testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        newContact.AccountId = testAccount.id;
        insert newContact;
        
        Contact newContact2 = new Contact();
        newContact2.email = 'test5678@xyz.com';
        newContact2.Party_Id__c = '12323658';
        newContact2.FirstName = 'test';
        newContact2.LastName = '02';
        newContact2.AccountId = testAccount.id;
        insert newContact2;
        
        Account testParentAccount = new Account();
        testParentAccount.name = 'Test Account';
        testParentAccount.type = 'Agent';
        testParentAccount.Customer_Id__c = '123';
        testParentAccount.Ringgold_Account_ID__c = '5629';
        insert testParentAccount;
        
        Contact newContact3 = new Contact();
        newContact3.email = 'test1234@xyz.com';
        newContact3.Party_Id__c = '12323617';
        newContact3.FirstName = 'testAccCon';
        newContact3.LastName = 'acc01';
        newContact3.AccountId = testParentAccount.id;
        newContact3.Shared_email_address__c = true;
        insert newContact3;
        
        Contact newContact4 = new Contact();
        newContact4.email = 'test5678@xyz.com';
        newContact4.Party_Id__c = '12320658';
        newContact4.FirstName = 'test';
        newContact4.LastName = 'acc02';
        newContact4.AccountId = testParentAccount.id;
        newContact4.Shared_email_address__c = true;
        insert newContact4;
        
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 1'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
        
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';
        String ipjson = '[{"allowReject":true,"description":"test ip","errorMsg":"121","ipRange":"10.02.11.11:20.11.11.11","name":"EUA-0492","sfid":"'+ip.id+'","status":"Failed"}]';

         Test.startTest();
         TF_ValidateIPRangeCalloutController.updateThirdPartyAccountRejStatus(testAccount.id, '123', ipjson);
         Test.stopTest();
         Account thisAccount = [Select id, Onboarding_Status__c from Account where id=: testAccount.id];
         System.assertEquals('Rejected', thisAccount.Onboarding_Status__c );
         Account thisParentAccount = [Select id, Source_of_Account__c, Onboarding_Status__c from Account where id=: testParentAccount.id];
         System.assertEquals('GOBI', thisParentAccount.Source_of_Account__c );
         List<Contact> thisConList = [Select id, name from Contact where Accountid=: thisParentAccount.id];
         System.assertEquals(2, thisConList.size() );
         List<Contact> newAccConList = [Select id, name from Contact where Accountid=: testAccount.id];
         System.assertEquals(0, newAccConList.size() );
     }
     
     @istest 
     private static void test_updateThirdPartyAccountRejStatus_contactAccountChange(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United Kingdom';
        countryCode.Country_2__c = 'UK';
        insert countryCode;
        
        Account testAccount = new Account();
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '1231';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        newContact.AccountId = testAccount.id;
        insert newContact;
        
        Contact newContact2 = new Contact();
        newContact2.email = 'test5678@xyz.com';
        newContact2.Party_Id__c = '12323658';
        newContact2.FirstName = 'test';
        newContact2.LastName = '02';
        newContact2.AccountId = testAccount.id;
        insert newContact2;
        
        Account testParentAccount = new Account();
        testParentAccount.name = 'Test Account';
        testParentAccount.type = 'Agent';
        testParentAccount.Customer_Id__c = '123';
        testParentAccount.Ringgold_Account_ID__c = '5629';
        testParentAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testParentAccount;
        
        Contact newContact3 = new Contact();
        newContact3.email = 'test12234@xyz.com';
        newContact3.Party_Id__c = '12323617';
        newContact3.FirstName = 'testAccCon';
        newContact3.LastName = 'acc01';
        newContact3.AccountId = testParentAccount.id;
        insert newContact3;
        
        Contact newContact4 = new Contact();
        newContact4.email = 'test56578@xyz.com';
        newContact4.Party_Id__c = '12320658';
        newContact4.FirstName = 'test';
        newContact4.LastName = 'acc02';
        newContact4.AccountId = testParentAccount.id;
        insert newContact4;
        
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 1'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
        
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';
        String ipjson = '[{"allowReject":true,"description":"test ip","errorMsg":"121","ipRange":"10.02.11.11:20.11.11.11","name":"EUA-0492","sfid":"'+ip.id+'","status":"Failed"}]';

         Test.startTest();
         TF_ValidateIPRangeCalloutController.updateThirdPartyAccountRejStatus(testAccount.id, '123', ipjson);
         Test.stopTest();
         Account thisAccount = [Select id, Onboarding_Status__c from Account where id=: testAccount.id];
         System.assertEquals('Rejected', thisAccount.Onboarding_Status__c );
         Account thisParentAccount = [Select id, Source_of_Account__c, Onboarding_Status__c from Account where id=: testParentAccount.id];
         System.assertEquals('GOBI', thisParentAccount.Source_of_Account__c );
         List<Contact> thisConList = [Select id, name from Contact where Accountid=: thisParentAccount.id];
         System.assertEquals(4, thisConList.size() );
         List<Contact> newAccConList = [Select id, name from Contact where Accountid=: testAccount.id];
         System.assertEquals(0, newAccConList.size() );
     }
     
     @istest 
     private static void test_updateThirdPartyAccountRejStatus_conAccountChange(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United Kingdom';
        countryCode.Country_2__c = 'UK';
        insert countryCode;
         
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '1231';
        testAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testAccount;
        
        Contact newContact3 = new Contact();
        newContact3.email = 'test12234@xyz.com';
        newContact3.Party_Id__c = '12323617';
        newContact3.FirstName = 'testAccCon';
        newContact3.LastName = 'acc01';
        newContact3.AccountId = testAccount.id;
        insert newContact3;
        
        Contact newContact4 = new Contact();
        newContact4.email = 'test56578@xyz.com';
        newContact4.Party_Id__c = '12320658';
        newContact4.FirstName = 'test';
        newContact4.LastName = 'acc02';
        newContact4.AccountId = testAccount.id;
        insert newContact4;
        
        Account testParentAccount = new Account();
        testParentAccount.name = 'Test Account';
        testParentAccount.type = 'Agent';
        testParentAccount.Customer_Id__c = '123';
        testParentAccount.Ringgold_Account_ID__c = '5629';
        testParentAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testParentAccount;
        
        End_User_Access__c ip = new End_User_Access__c();
        ip.Description__c = 'Test ip 1'; 
        ip.Account__c = testAccount.id;
        ip.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip;
        
        
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';
        String ipjson = '[{"allowReject":true,"description":"test ip","errorMsg":"121","ipRange":"10.02.11.11:20.11.11.11","name":"EUA-0492","sfid":"'+ip.id+'","status":"Failed"}]';

         Test.startTest();
         TF_ValidateIPRangeCalloutController.updateThirdPartyAccountRejStatus(testAccount.id,'123', ipjson);
         Test.stopTest();
         Account thisAccount = [Select id, Onboarding_Status__c from Account where id=: testAccount.id];
         System.assertEquals('Rejected', thisAccount.Onboarding_Status__c );
         Account thisParentAccount = [Select id, Source_of_Account__c, Onboarding_Status__c from Account where id=: testParentAccount.id];
         System.assertEquals('GOBI', thisParentAccount.Source_of_Account__c );
         List<Contact> dupAccContList = [Select id, name from Contact where Accountid=: thisParentAccount.id];
         System.assertEquals(2, dupAccContList.size() );
         List<Contact> thisConList = [Select id, name from Contact where Accountid=: testAccount.id];
         System.assertEquals(0, thisConList.size() );
     }
    
}