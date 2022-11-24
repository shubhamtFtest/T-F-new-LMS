@IsTest(SeeAllData=false)
public class IndividualCustomerServiceTest {
    
    @isTest
    private static void test_doPostPersonAcc(){
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United States';
        countryCode.Country_2__c = 'US';
        insert countryCode;
        
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
       
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/PersonAccount/doPost';
        request.httpMethod = 'POST';
        String notifyJSON='{"partyID":"","sfdcId":"","firstName":"Test01","lastName":"Person Accoun 01","email":"test.personacc@testing.com","phoneNumber":"7768987699","address":{"street":"test street","city":"Oxford","zip":"OX111STTTT","country":"United States"}}';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        IndividualCustomerService.doPost();
        Test.stopTest();
        
        List<Account> accList = [SELECT id, FirstName, LastName FROM Account WHERE PersonEmail = 'test.personacc@testing.com' limit 1];
        System.assertEquals(1,accList.size());

    }
    
    @isTest
    private static void test_convertToPersonAcc(){
        
        Contact newContact = new Contact();
        newContact.email = 'test.personacc@testing.com';
        newContact.Party_Id__c = '12323657';
        newContact.FirstName = 'test01';
        newContact.LastName = 'Con01';
        insert newContact;
       
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/PersonAccount/test.personacc@testing.com/Convert';
        request.httpMethod = 'PUT';
        RestContext.request = request;
        RestContext.response = res;
        IndividualCustomerService.doPut();
        Test.stopTest();
    }
    
    @isTest
    private static void test_doPostPersonAccException(){
        try{
        Country__c countryCode = new Country__c();
        countryCode.Name = 'United States';
        countryCode.Country_2__c = 'US';
        insert countryCode;
        
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
       
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/v1/PersonAccount/doPost';
        request.httpMethod = 'POST';
        String notifyJSON='{"partyID":"","sfdcId":"","firstName":"Test01","lastName":"Person Accoun 01","email":"","phoneNumber":"7768987699","address":{"street":"test street","city":"Oxford","zip":"OX111STTTT","country":"United States"}}';
        request.requestBody = Blob.valueof(notifyJSON);
        RestContext.request = request;
        RestContext.response = res;
        IndividualCustomerService.doPost();
        Test.stopTest();
        
        }catch(Exception ex){
           System.debug('ex'+ex); 
        }

    }
    
}