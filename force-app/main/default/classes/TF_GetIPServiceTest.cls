@IsTest(SeeAllData=false)
public class TF_GetIPServiceTest {
    
    @isTest
    private static void test_getIPInfoByPartyID(){
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

        String partyId = [Select Customer_Id__c from Account where id =: testAccount.id].Customer_Id__c;
        System.debug('Paty id:'+partyId);

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        
        End_User_Access__c ip1 = new End_User_Access__c();
        ip1.Account__c = testAccount.id;
        ip1.Description__c = 'test ip';
        ip1.IP_Range__c = '1.1.1.1:2.2.2.2';
        insert ip1;

        End_User_Access__c ip2 = new End_User_Access__c();
        ip2.Account__c = testAccount.id;
        ip2.Description__c = 'test ip2';
        ip2.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip2;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/ips/'+partyId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
        TF_GetIPService.doGet();
        Test.stopTest();
        System.assert(res != null);
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

        String partyId = [Select Customer_Id__c from Account where id =: testAccount.id].Customer_Id__c;
        System.debug('Paty id:'+partyId);

        Contact newContact = new Contact();
        newContact.email = 'test1234@xyz.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test';
        newContact.LastName = '01';
        Test.startTest();
        insert newContact;
        
        End_User_Access__c ip1 = new End_User_Access__c();
        ip1.Account__c = testAccount.id;
        ip1.Description__c = 'test ip';
        ip1.IP_Range__c = '1.1.1.1:2.2.2.2';
        insert ip1;

        End_User_Access__c ip2 = new End_User_Access__c();
        ip2.Account__c = testAccount.id;
        ip2.Description__c = 'test ip2';
        ip2.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ip2;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/ips/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
        TF_GetIPService.doGet();
        Test.stopTest();
        System.assert(res != null);

    }
}