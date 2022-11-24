@isTest(seeAllData=false)
public class OnBoardingRetryBatchTest implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata":{"orgsCount":1,"message":"party with 5274821 found","status":"success"},"data":{"contact":null,"organisations":[{"partyId":4376718,"name":"Saba Software Technology 1","parentRingGoldId":null,"ringGoldId":"374239","sourceOrgId":0,"organisationType":null,"partySfdcId":"0011w00000fL8uTAAS","addressList":[{"addressId":40853,"contactType":null,"addressLine1":"18 Lehmann Way","addressLine2":null,"addressLine3":null,"postalCode":"03444","state":"NH","city":"Dublin","country":"United States","province":null,"addressType":"billing","externalCustomerAddressId":null,"addressStartDate":null,"addressEndDate":null,"bpNumber":"0004105131","bpPartnerFunction":"SP","bpBusinessPartnerCategory":"2","countryCode":"US","usStateCode":null,"emailAddress":"gilberstalinetest01@testing.com","title":null,"firstName":"null","lastName":"Gilbert Staline","telephone":null,"taxRegistrationNumber":null,"taxNumberCategory":null,"houseNumber":null,"sfdcId":"a4w1w000000IxUoAAK","source":null,"salesforceRecordId":null,"addressUseType":null}],"relationships":[],"description":null,"comments":null,"url":null,"isni":null,"isniName":null,"accountSettings":null,"sfdcEnrollment":null,"sfdcNumberOfEmployees":null,"sfdcCategory":"Corporate","sfdcClassification":"Institution","sfdcType":null,"sfdcLegalSubcategory":"Tech","ptReferenceId":null,"isTestOrg":false}],"source":null}}';
	private static String mockJsonResponse_SuccessNoOrg = '{"metadata":{"orgsCount":0,"message":"party with 5274821 found","status":"success"},"data":{"contact":null,"organisations":[],"source":null}}';
    private static String mockJsonResponse_Error ='{"id":"7a7814db-f700-4e68-94f7-430063205897","timeStamp":"2020.06.09.07.03.15.903","requestURL":"http://api-uat.taylorandfrancis.com/customers/party/433","requestMethod":"GET","error":"Internal Server Error"}';
    public OnBoardingRetryBatchTest(integer statusCode, String responseJson){
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
     private static void test_execute(){
         Account testAccount = new Account();
         testAccount.name = 'Institut Lumiere Matiere';
         testAccount.website = 'TestAccount@xyz.com';
         testAccount.BillingCity = 'Test City';
         testAccount.BillingPostalCode = '23398';
         testAccount.Mailing_State_List__c = 'XY';
         testAccount.type = 'Agent';
         testAccount.Customer_Id__c = '5274821';
         insert testAccount;
         Account_Request_Log__c newlog = new Account_Request_Log__c();
         newlog.Account_ID__c = testAccount.id;
         newlog.Request_ID__c = '0017R000025UwoMQAS';
         newlog.Request_JSON__c = '{"website":null,"source":"OA","ringGoldId":"131859","name":"Institut Lumiere Matiere","ips":null,"contact":[{"lastname":"Macheboeuf","firstname":"Christelle","email":"christelle.macheboeuf@univ-lyon1.fr"}],"address":[{"taxRegistrationNumber":null,"taxNumberCategory":null,"state":null,"postalCode":"F69622","country":"France","city":"Villeurbanne","addressType":"billing","addressLine3":null,"addressLine2":null,"addressLine1":"10 rue Ada Biron"}]}';
         newlog.Party_ID__c = '5274821';
         newlog.BP_Numbers__c = 'a4w7R000000huqTQAQ';
         newlog.Status__c = 'SYNC PENDING';
         newlog.Source__c = 'OA';
         insert newlog;
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new AccountApprovalNotificationHandlerTest(200, mockJsonResponse_Success));

         OnBoardingRetryBatch obj = new OnBoardingRetryBatch();
         DataBase.executeBatch(obj,100); 
         Test.stopTest();
         
         Account_Request_Log__c thisLog = [Select Id,Status__c From Account_Request_Log__c where id =: newlog.id];
         System.assertEquals('NOTIFIED', thisLog.Status__c);
     }
       

}