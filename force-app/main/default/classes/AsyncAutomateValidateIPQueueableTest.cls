@IsTest(SeeAllData=false)
public class AsyncAutomateValidateIPQueueableTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata": {"status": "success","message": {}},"data": {"isIpRangeExists": true,"partyId": "1234"}}';
    private static String mockJsonResponse_Success2 = '{"metadata": {"status": "success","message": {}},"data": {"isIpRangeExists": true,"partyId": "12345"}}';
	private static String mockJsonResponse_Error = '{"metadata": {"status": "failure","message": {"key": "Invalid input","value": "ipStart or ipEnd cannot be empty"}},"data": null}';

    public AsyncAutomateValidateIPQueueableTest(integer statusCode, String responseJson){
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
        TF_OrgSpecificProps__c  ipAPI = new TF_OrgSpecificProps__c ();
        ipAPI.IP_Validate_URL__c  ='https://api-dev.taylorandfrancis.com/v1/ips?';
        insert ipAPI;
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
        Test.setMock(HttpCalloutMock.class, new AsyncAutomateValidateIPQueueableTest(200, mockJsonResponse_Success));
		Id automateValidateIPJobId = System.enqueueJob( new AsyncAutomateValidateIPQueueable( newAccount ));
        Test.stopTest();
    }
}