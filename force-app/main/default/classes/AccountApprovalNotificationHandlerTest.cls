@isTest(seeAllData=false)
public class AccountApprovalNotificationHandlerTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata":{"orgsCount":1,"message":"party with 4376718 found","status":"success"},"data":{"contact":null,"organisations":[{"partyId":4376718,"name":"Saba Software Technology 1","parentRingGoldId":null,"ringGoldId":"374239","sourceOrgId":0,"organisationType":null,"partySfdcId":"0011w00000fL8uTAAS","addressList":[{"addressId":40853,"contactType":null,"addressLine1":"18 Lehmann Way","addressLine2":null,"addressLine3":null,"postalCode":"03444","state":"NH","city":"Dublin","country":"United States","province":null,"addressType":"billing","externalCustomerAddressId":null,"addressStartDate":null,"addressEndDate":null,"bpNumber":"0004105131","bpPartnerFunction":"SP","bpBusinessPartnerCategory":"2","countryCode":"US","usStateCode":null,"emailAddress":"gilberstalinetest01@testing.com","title":null,"firstName":"null","lastName":"Gilbert Staline","telephone":null,"taxRegistrationNumber":null,"taxNumberCategory":null,"houseNumber":null,"sfdcId":"a4w1w000000IxUoAAK","source":null,"salesforceRecordId":null,"addressUseType":null}],"relationships":[],"description":null,"comments":null,"url":null,"isni":null,"isniName":null,"accountSettings":null,"sfdcEnrollment":null,"sfdcNumberOfEmployees":null,"sfdcCategory":"Corporate","sfdcClassification":"Institution","sfdcType":null,"sfdcLegalSubcategory":"Tech","ptReferenceId":null,"isTestOrg":false}],"source":null}}';
	private static String mockJsonResponse_SuccessNoOrg = '{"metadata":{"orgsCount":0,"message":"party with 4376718 found","status":"success"},"data":{"contact":null,"organisations":[],"source":null}}';
    private static String mockJsonResponse_Error ='{"id":"7a7814db-f700-4e68-94f7-430063205897","timeStamp":"2020.06.09.07.03.15.903","requestURL":"http://api-uat.taylorandfrancis.com/customers/party/433","requestMethod":"GET","error":"Internal Server Error"}';
    public AccountApprovalNotificationHandlerTest(integer statusCode, String responseJson){
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
     private static void test_handleAccountApprovalNotification_Success(){
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '4376718';
         insert testAccount;
         Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'APPROVED';
        log.Source__c = 'OA';
        insert log;
         
         SAP_BP__c testSAP = new SAP_BP__c();
         testSAP.First_Name__c = 'testS';
         testSAP.Last_Name__c = 'uBPN';
         testSAP.Email__c = 'testS.uBPN@testing.com';
         testSAP.Name = 'PENDING';
         testSAP.Address_Type__c = 'Account Billing';
         insert testSAP;
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new AccountApprovalNotificationHandlerTest(200, mockJsonResponse_Success));
         AccountApprovalNotificationHandler.handleAccountApprovalNotification(testAccount.id,testAccount.id,testAccount.Customer_Id__c,testSAP.id);
         Test.stopTest();
       
     }
    
    @istest 
     private static void test_handleAccountApprovalNotification_SuccessWithSAPBPNumber(){
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '4376718';
         insert testAccount;
         Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'APPROVED';
        log.Source__c = 'OA';
        insert log;
         
         SAP_BP__c testSAP = new SAP_BP__c();
         testSAP.First_Name__c = 'testS';
         testSAP.Last_Name__c = 'uBPN';
         testSAP.Email__c = 'testS.uBPN@testing.com';
         testSAP.Name = '00043567';
         testSAP.Address_Type__c = 'Account Billing';
         insert testSAP;
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new AccountApprovalNotificationHandlerTest(200, mockJsonResponse_Success));
         AccountApprovalNotificationHandler.handleAccountApprovalNotification(testAccount.id,testAccount.id,testAccount.Customer_Id__c,testSAP.id);
         Test.stopTest();
       
     }
    
    @istest 
     private static void test_handleAccountApprovalNotification_SuccessNoOrganisation(){
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '4376718';
         insert testAccount;
         Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'APPROVED';
        log.Source__c = 'OA';
        insert log;
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new AccountApprovalNotificationHandlerTest(200, mockJsonResponse_SuccessNoOrg));
         AccountApprovalNotificationHandler.handleAccountApprovalNotification(testAccount.id,testAccount.id,testAccount.Customer_Id__c,'1234');
         Test.stopTest();
       
     }
    
    @istest 
     private static void test_handleAccountApprovalNotification_Fail(){
         Account testAccount = new Account();
         testAccount.name = 'Test Account';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '4376718';
         insert testAccount;
         Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'APPROVED';
        log.Source__c = 'OA';
        insert log;
        
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new AccountApprovalNotificationHandlerTest(500, mockJsonResponse_Error));
         AccountApprovalNotificationHandler.handleAccountApprovalNotification(testAccount.id,testAccount.id,testAccount.Customer_Id__c,'1234');
         Test.stopTest();
       
     }
}