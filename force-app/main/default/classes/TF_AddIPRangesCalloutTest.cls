@isTest(seeAllData=false)
public class TF_AddIPRangesCalloutTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata": {"status": "success","message": {}},"data": [{"ip_access_control_id": "919724","ip_start": "38.127.198.2","ip_end": "38.127.198.2","access_type": "allow","party_id": "100","db_add_date": "2019-12-12T10:47:50.209Z","db_update_date": "2019-12-12T10:47:50.209Z","created_by": "aravind.kumar@taylorandfrancis.com","updated_by": "aravind.kumar@taylorandfrancis.com","deleted_on": null,"description": "string","ip_type_id": 1}]}';
    private static String mockJsonResponse_Error = '{"metadata": {"status": "failure","message": {"key": "UNEXPECTED_ERROR", "value": "Internal Error"}},"data": null}';
	private static String mockJsonResponse_Error1 = '{"metadata": {"status": "success","message": "Ip range already exists"},"data": {"validIPCounts": 0,"inValidIPCounts": 0,"inValidIPRanges": [],"validIPRanges": null,"existingIpRanges": [{"ip_access_control_id": "78438","ip_start": "1.186.69.33", "ip_end": "1.186.69.33", "access_type": "allow", "ip_type_id": 1, "party_id": "102233", "description": "IPs" }],"existingIpRangesCount": 1}}';
    public TF_AddIPRangesCalloutTest(integer statusCode, String responseJson){
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
        TF_OrgSpecificProps__c  addaiAPI = new TF_OrgSpecificProps__c ();
        addaiAPI.Add_IP_List_URL__c  =   'https://api-uat.taylorandfrancis.com/v1/ipauth/party/';
        insert addaiAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '100';
        insert testAccount;
        
        End_User_Access__c testip1 = new End_User_Access__c();
         testip1.IP_Range__c = '1.1.1.1:2.2.2.2';
         testip1.Account__c = testAccount.Id;
         testip1.Description__c = 'test ip1';
         insert testip1;
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_SearchRinggoldIdCalloutTest(200, mockJsonResponse_Success));
         TF_AddIPRangesCallout.getCalloutResponseContents('100', testAccount.id);
         Test.stopTest();
       
     }

     @istest 
     private static void test_getCalloutResponseContents_Error(){
        TF_OrgSpecificProps__c  addaiAPI = new TF_OrgSpecificProps__c ();
        addaiAPI.Add_IP_List_URL__c  =   'https://api-uat.taylorandfrancis.com/v1/ipauth/party/';
        insert addaiAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '100';
        insert testAccount;  
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_SearchRinggoldIdCalloutTest(301, mockJsonResponse_Error));
         TF_AddIPRangesCallout.getCalloutResponseContents('100', testAccount.id);
         Test.stopTest();
       
     }
    
    @istest 
     private static void test_getCalloutResponseContents_InvalidIP(){
        TF_OrgSpecificProps__c  addaiAPI = new TF_OrgSpecificProps__c ();
        addaiAPI.Add_IP_List_URL__c  =   'https://api-uat.taylorandfrancis.com/v1/ipauth/party/';
        insert addaiAPI;
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '100';
        insert testAccount;
        
        End_User_Access__c testip1 = new End_User_Access__c();
         testip1.IP_Range__c = '1.1.1.1:2.2.2.2';
         testip1.Account__c = testAccount.Id;
         testip1.Description__c = 'test ip1';
         insert testip1; 
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_SearchRinggoldIdCalloutTest(200, mockJsonResponse_Error1));
         TF_AddIPRangesCallout.getCalloutResponseContents('100', testAccount.id);
         Test.stopTest();
       
     }

}