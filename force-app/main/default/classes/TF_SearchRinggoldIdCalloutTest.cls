@isTest(seeAllData=false)
public class TF_SearchRinggoldIdCalloutTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String ringgoldId = '5629';
    private static String mockJsonResponse_Success = '{"metadata": {"status": "Success","message": null,"query": "eyJfc291cmNlIjp7ImV4Y2x1ZGUiOlsibWVzc2FnZSJdLCJpbmNsdWRlIjpbInJpbmdnb2xkX2lkIiwiaW5zdGl0dXRpb25fbmFtZSIsImNpdHkiLCJzdGF0ZSIsInppcF9jb2RlIiwiYWx0X25hbWUiLCJjb3VudHJ5Il19LCJxdWVyeSI6eyJib29sIjp7InNob3VsZCI6W3sibWF0Y2giOnsiaW5zdGl0dXRpb25fbmFtZSI6eyJxdWVyeSI6Ik1hc3NhY2h1c2V0dHMgSW5zdGl0dXRlIG9mIFRlY2hub2xvZ3kgTXVzaWMgUHJvZ3JhbSIsImJvb3N0Ijo1LCJmdXp6aW5lc3MiOiJBVVRPIiwib3BlcmF0b3IiOiJhbmQifX19LHsibWF0Y2giOnsiY2l0eS5rZXl3b3JkIjp7InF1ZXJ5IjoiY2FtYnJpZGdlIiwiYm9vc3QiOjN9fX0seyJtYXRjaCI6eyJzdGF0ZS5rZXl3b3JkIjp7InF1ZXJ5IjoibWEiLCJib29zdCI6M319fSx7Im1hdGNoIjp7InppcF9jb2RlLmtleXdvcmQiOnsicXVlcnkiOiIwMjEzOS00MzA3IiwiYm9vc3QiOjQsImZ1enppbmVzcyI6IkFVVE8ifX19LHsibWF0Y2giOnsiYWx0X25hbWUiOnsicXVlcnkiOiJNYXNzYWNodXNldHRzIEluc3RpdHV0ZSBvZiBUZWNobm9sb2d5IE11c2ljIFByb2dyYW0iLCJib29zdCI6NSwiZnV6emluZXNzIjoiQVVUTyIsIm9wZXJhdG9yIjoiYW5kIn19fSx7InJlZ2V4cCI6eyJ3ZWJzaXRlX2RvbWFpbiI6eyJ2YWx1ZSI6ImRpYmluc3QubWl0LmVkdS4qLioiLCJib29zdCI6NTB9fX0seyJtYXRjaCI6eyJjb3VudHJ5LmtleXdvcmQiOnsicXVlcnkiOiJ1cyIsImJvb3N0Ijo1fX19XX19LCJmcm9tIjowLCJzaXplIjoxMCwibWluX3Njb3JlIjowLjIsImFnZ3MiOnt9LCJzb3J0IjpbeyJfc2NvcmUiOnsib3JkZXIiOiJkZXNjIn19XX0="},"data": {"productCount": 77,"resultSet": [{"country": "US","alt_name": ["Massachusetts Institute of Technology Music and Theater Arts"], "city": "Cambridge",  "state": "MA",                "institution_name": "Massachusetts Institute of Technology Music Program",                "ringgold_id": 195932,"zip_code": "02139-4301",      "es_doc_type": "organization","es_score": 165.4411},{"country": "US","alt_name": [    "Massachusetts Institute of Technology Dibner Institute for the History of Science and Technology" ], "city": "Cambridge", "state": "MA", "institution_name": "Massachusetts Institute of Technology",  "ringgold_id": 2167,  "zip_code": "02139-4307",  "es_doc_type": "organization",   "es_score": 89.379425}],   "esMaxScore": 165.44116  },  "err": null}';
    private static String mockJsonResponse_Error = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    public TF_SearchRinggoldIdCalloutTest(integer statusCode, String responseJson){
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
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount;  
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_SearchRinggoldIdCalloutTest(200, mockJsonResponse_Success));
         List < TF_SearchRinggoldIdCallout.RinggoldDataWrapper > responseData = TF_SearchRinggoldIdCallout.getSearchRinggoldCalloutResponse(testAccount.id);
         System.assert(responseData != null);
         Test.stopTest();
       
     }
     @istest 
     private static void test_getUISearchRinggoldCalloutResponse_Success(){
        TF_OrgSpecificProps__c  rinngoldAPI = new TF_OrgSpecificProps__c ();
        rinngoldAPI.RingGold_Fuzzy_Api_Endpoint__c  =   'https://api-uat.taylorandfrancis.com/v1/search/ringgold';
        rinngoldAPI.Search_Result_Limit__c = '10';
        insert rinngoldAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;  
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_SearchRinggoldIdCalloutTest(200, mockJsonResponse_Success));
         List < TF_SearchRinggoldIdCallout.RinggoldDataWrapper > responseData = TF_SearchRinggoldIdCallout.getUISearchRinggoldCalloutResponse('University of Oxford','www.ox.ac.uk','OXFORD','OX','United Kingdom','110099');
         System.assert(responseData != null);
         Test.stopTest();
       
     }
    
     @istest 
     private static void test_findDupAccount_Success(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
         String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';
         Test.startTest();
         String result = TF_SearchRinggoldIdCallout.findDupAccount(json);
         String expectedResult = System.URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/cmp/c__AccountDetailsComponent?c__recordId='+testAccount.id;
         System.assertEquals(expectedResult, result);
         Test.stopTest();
     }
    @istest 
     private static void test_findDupAccount_Failure(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '562911';
        insert testAccount;
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         Test.startTest();
         String result = TF_SearchRinggoldIdCallout.findDupAccount(json);
         System.assertEquals(null, result);
         Test.stopTest();
     }
    @istest 
     private static void test_getAccountDetails(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
         Account thisAccount = null;
         Test.startTest();
         thisAccount = TF_SearchRinggoldIdCallout.getAccountDetails(testAccount.id);
         Test.stopTest();
         System.assert(thisAccount != null);
         System.assertEquals('Test Account', thisAccount.name);
     }
    @istest 
     private static void test_getAccountDetails_Null(){
         Account thisAccount = null;
         Test.startTest();
         thisAccount = TF_SearchRinggoldIdCallout.getAccountDetails(null);
         Test.stopTest();
         System.assert(thisAccount == null);
     }
     @istest 
     private static void test_updateAccountStatus_Rejected(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount;
         Test.startTest();
         Account testParentAccount = new Account();
        testParentAccount.name = 'Test Account';
        testParentAccount.type = 'Agent';
        testParentAccount.Customer_Id__c = '1234';
        testParentAccount.Ringgold_Account_ID__c = '5629';
        testParentAccount.Mailing_Country_List__c = 'United Kingdom';
        insert testParentAccount;
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         
         TF_SearchRinggoldIdCallout.updateAccountStatus(testAccount.id,json);
         Test.stopTest();
         Account thisAccount = [Select id, Onboarding_Status__c from Account where id=: testAccount.id];
         System.assertEquals('Rejected', thisAccount.Onboarding_Status__c );
     }
     @istest 
     private static void test_updateThirdPartyAccountRejStatus(){
        
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United Kingdom';
        countryCode.Country_2__c = 'UK';
        insert countryCode;
         
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.Customer_Id__c = '123122';
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
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         Test.startTest();
         TF_SearchRinggoldIdCallout.updateThirdPartyAccountRejStatus(testAccount.id, json);
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
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Source_of_Account__c = 'GOBI';
		testAccount.Customer_Id__c = '123';
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
        testParentAccount.Customer_Id__c = '1234';
        testParentAccount.Ringgold_Account_ID__c = '5629';        
        testParentAccount.Mailing_Country_List__c = 'United Kingdom';

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
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         Test.startTest();
         TF_SearchRinggoldIdCallout.updateThirdPartyAccountRejStatus(testAccount.id, json);
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
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.Customer_Id__c = '123223';
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
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         Test.startTest();
         TF_SearchRinggoldIdCallout.updateThirdPartyAccountRejStatus(testAccount.id, json);
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
        testAccount.Customer_Id__c = '123222';
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
        
        
        String json = '[{"accountName":"Test Acc","city":"test city1","country":"United Kingdom","match_percentage":93.5,"ringgoldId":5629,"state":"test state1","zip_code":130004}]';

         Test.startTest();
         TF_SearchRinggoldIdCallout.updateThirdPartyAccountRejStatus(testAccount.id, json);
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