@isTest(seeAllData=false)
public class TF_SAP_BP_VerificationTest implements HttpCalloutMock {
    private integer statusCode;
    private String responseJson;
    private static String mockJsonResponse_Success = '{"metadata": {"status": 200,"details": "Instance 3721989 of object type ISMBusinessPartner has been changed.|Instance 3722238 of object type ISMBusinessPartner has been changed."},"data":""}';
    private static String mockJsonResponse_Error = '{"metadata": {"status": 400,"details": "Error"},"data": []}';
    public TF_SAP_BP_VerificationTest(integer statusCode, String responseJson){
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
    
    public class SapbpWrapper{
        public String RecordId {get;set;}
        public String Country {get;set;}
        public String AddressLine1 {get;set;}
        public String AddressLine2 {get;set;}
        public String AddressLine3 {get;set;}
        public String PostalCode {get;set;}
        public String State {get;set;}
        public String City {get;set;}
        public String emailAddress {get;set;}
        public String title {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        
    }
    
    @isTest
    public static void TestMethodSapBpNegative(){
        TF_OrgSpecificProps__c orgSpecificProps = new TF_OrgSpecificProps__c();
        orgSpecificProps.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert orgSpecificProps;
        
        account acc = new account();
        acc.Name='test';
        acc.Customer_Id__c='abcd';
        insert acc;
        
        SAP_BP__c sapbpobj=new SAP_BP__c();
        sapbpobj.City__c='Test';
        sapbpobj.Street__c='Test';
        sapbpobj.Account_Id__c=acc.id;
        sapbpobj.State__c='Test';
        sapbpobj.Email__c='Test@test.in';
        sapbpobj.Country__c='Test';
        sapbpobj.Address_Type__c='Account Billing';
        sapbpobj.First_Name__c = 'Test';
        sapbpobj.Last_Name__c = 'Test';
        insert sapbpobj;
        SapbpWrapper sapbp =new SapbpWrapper();
        sapbp.RecordId=acc.id;
        sapbp.Country='Test';
        sapbp.AddressLine1='Test';
        sapbp.AddressLine2='Test';
        sapbp.AddressLine3='Test';
        sapbp.PostalCode='Test';
        sapbp.State='Test';
        sapbp.emailAddress='Test@test.in';
        sapbp.title='test';
        sapbp.firstName='Test';
        sapbp.lastName='Test';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TF_SAP_BP_VerificationTest(400, mockJsonResponse_Success));
        TF_SAP_BP_Verification.VerifyAddressController(sapbp); 
        TF_SAP_BP_Verification.shippingAddressVerify(sapbp); 
        TF_SAP_BP_Verification.CreateSAPBP(sapbp); 
        TF_SAP_BP_Verification.getDependentMap(acc,'Mailing_Country_List__c','Mailing_State_List__c');
        Test.stopTest();    
        
        
    }
    
    
}