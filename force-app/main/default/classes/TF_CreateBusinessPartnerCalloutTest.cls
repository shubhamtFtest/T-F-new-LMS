@isTest(seeAllData=false)
public class TF_CreateBusinessPartnerCalloutTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata": {"code": 201,"timestamp": "2019.11.15.10.45.47.094","details": "Instance 3721989 of object type ISMBusinessPartner has been changed.|Instance 3722238 of object type ISMBusinessPartner has been changed."},"data": [{"externalCustomerAddressId": "1","businessPartnerNumber": "0003721989"}]}';
    private static String mockJsonResponse_Error = '{"metadata": {"code": 400,"timestamp": "2019.11.15.10.45.47.094","details": "Error"},"data": []}';
    public TF_CreateBusinessPartnerCalloutTest(integer statusCode, String responseJson){
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
     private static void test_getSAPBPNumberCallout_Success(){
         TF_OrgSpecificProps__c createBPAPI = new TF_OrgSpecificProps__c ();
         createBPAPI.BPNumber_Generation_Endpoint__c  =   'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
         insert createBPAPI;
        
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         insert testAccount;
        
         SAP_BP__c testSAPBP = new SAP_BP__c();
         testSAPBP.Street__c = 'test street';
         testSAPBP.Country__c = 'INDIA';
         testSAPBP.ZIP__c = '560100';
         testSAPBP.City__c = 'Bengaluru';
         testSAPBP.Email__c = 'testemail@testing.com';
         testSAPBP.First_Name__c = 'Test';
         testSAPBP.Last_Name__c = 'Con1';
         testSAPBP.Address_Type__c = 'Account Mailing';
         testSAPBP.Account_Id__c = testAccount.Id;
         insert testSAPBP;
         List<Id> sapIDList = new List<Id>();
         sapIDList.add(testSAPBP.id);
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_CreateBusinessPartnerCalloutTest(201, mockJsonResponse_Success));
         TF_CreateBusinessPartnerCallout.getSAPBPNumberCallout(sapIDList,'test','test','test');
         Test.stopTest();
       
     }
     @istest 
     private static void test_getSAPBPNumberCallout_nullAddress(){
         TF_OrgSpecificProps__c createBPAPI = new TF_OrgSpecificProps__c ();
         createBPAPI.BPNumber_Generation_Endpoint__c  =   'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
         insert createBPAPI;
        
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '123';
         insert testAccount;
        
         SAP_BP__c testSAPBP = new SAP_BP__c();
         /*testSAPBP.Street__c = 'test street';
         testSAPBP.Country__c = 'INDIA';
         testSAPBP.ZIP__c = '560100';
         testSAPBP.City__c = 'Bengaluru';*/
         testSAPBP.Email__c = 'testemail@testing.com';
         testSAPBP.First_Name__c = 'Test';
         testSAPBP.Last_Name__c = 'Con1';
         testSAPBP.Address_Type__c = 'Account Mailing';
         testSAPBP.Account_Id__c = testAccount.Id;
         insert testSAPBP;
         List<Id> sapIDList = new List<Id>();
         sapIDList.add(testSAPBP.id);
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new TF_CreateBusinessPartnerCalloutTest(201, mockJsonResponse_Success));
         TF_CreateBusinessPartnerCallout.getSAPBPNumberCallout(sapIDList,'test','test','test');
         Test.stopTest();
       
     }
    
    
}