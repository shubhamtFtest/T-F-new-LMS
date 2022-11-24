@IsTest(SeeAllData=false)
public class AccountRequestOAAutomationServiceTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String ringgoldId = '5629';
            
    private static String mockJsonResponse_Success = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    private static String mockJsonResponse_Error = '{ "ringgold_id": 5629, "name": "University of Oxford", "body_type": "C","post_code": "OX2 0EW","org_type": "Academic/Ag","place":{ "language": "string", "city": "OXFORD", "state": "OX","country_code": "United Kingdom"},"consortia_members": [{ "member_ringgold_id": 0,"name": "string"} ],"urls": [{  "url": "www.ox.ac.uk","type": "PD"}],"data": [{"size": 19919,"staff": 6470}],"classifications": {"rg_tier": "A3", "sfj_tier": "2.2", "carnegie": {"SizeSet2015": "14","BASIC2010": "18", "SizeSet2005": "13", "BASIC2005": "18", "SizeSet2010": "14", "BASIC2015": "18"}},"identifiers": [{"athens": "string", "ipeds": "string","isni": "string", "nacs": "string","nces": "string", "ofr": "string"}],"alt_names": [{"name": "Oxford University","type": "string", "place": {"language": "string","city": "string","country_code": "string"}}]}';

    public AccountRequestOAAutomationServiceTest(integer statusCode, String responseJson){
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
      
	@isTest
    private static void test_create(){
        Account newAccount = new Account();
        newAccount.Name = 'Oxfordtest';
        newAccount.Ringgold_Account_ID__c = '5629';
        newAccount.Website = 'www.testAcc.com';
        newAccount.Source_of_Account__c = 'OA';
        newAccount.BillingStreet = 'teststreet';
        newAccount.BillingCity = 'Bangalore';
        newAccount.BillingState = 'Karnataka';
        newAccount.BillingCountry = 'India';
        newAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
		newAccount.Onboarding_Status__c = 'Draft';
        newAccount.Mailing_Country_List__c = 'India';
        insert newAccount;
        
        End_User_Access__c ipNew = new End_User_Access__c();
        ipNew.Description__c = 'Test ip 1'; 
        ipNew.Account__c = newAccount.id;
        ipNew.IP_Range__c = '10.10.10.10:20.20.20.20';
        insert ipNew;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AccountRequestOAAutomationServiceTest(200, mockJsonResponse_Success));
		Id automateValidateIPJobId = System.enqueueJob( new AccountRequestOAAutomationService( newAccount ));
        Test.stopTest();
        
        List<Account> accountList = [SELECT id, Name FROM Account WHERE Ringgold_Account_ID__c = '5629'];
        System.assert(accountList != null);
        System.assertEquals(accountList.size(),1);
        System.assertEquals(accountList[0].Name, 'University of Oxford');
    }
}