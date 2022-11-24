@IsTest(SeeAllData=false)
global class TF_VerifyAccountAddressTest  {
    @isTest
    Public static void test_EmptyAddress(){       
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        insert testAccount;
        
        TF_OrgSpecificProps__c  AddressAPIDetails = new TF_OrgSpecificProps__c ();
        AddressAPIDetails.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert AddressAPIDetails;
        
        TF_VerifyAccountAddress.getaccountId(testAccount.Id);
        Account accData = [Select Id from Account where id=:testAccount.Id];        
        TF_VerifyAccountAddress.shippingAddressVerify(accData);
        TF_VerifyAccountAddress.mailingAddressVerify(accData);
        TF_VerifyAccountAddress.billingAddressVerify(accData);
        
        TF_VerifyAccountAddress.getaccountIdLightning(testAccount.Id);        
        Account accDataForLightning = [Select Id from Account where id=:testAccount.Id];        
        TF_VerifyAccountAddress.shippingAddressVerify(accDataForLightning);
        TF_VerifyAccountAddress.mailingAddressVerify(accDataForLightning);
        TF_VerifyAccountAddress.billingAddressVerify(accDataForLightning);
        
    }
    
    @isTest
    Public static void test_AddressVerificationSuccess(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Billing_Street__c ='test\ntest';
        testAccount.Billing_City__c ='test';
        testAccount.Fax ='test';
        testAccount.Billing_ZIP__c ='test';
        testAccount.Billing_Country_List__c='India';
        
        testAccount.BillingStreet ='test\ntest';
        testAccount.BillingCity ='test';
        testAccount.BillingPostalCode ='test';
        testAccount.Mailing_Country_List__c='India';
        
        testAccount.ShippingStreet ='test\ntest';
        testAccount.ShippingCity ='test';
        testAccount.ShippingPostalCode ='test';
        testAccount.Shipping_Country_List__c='India';
        insert testAccount;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;       
                
        TF_OrgSpecificProps__c  AddressAPIDetails = new TF_OrgSpecificProps__c ();
        AddressAPIDetails.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert AddressAPIDetails;
        //TF_VerifyAccountAddress.getaccountId(testAccount.Id);  
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_VerifyAccountAddress.getaccountId(testAccount.Id);
        test.stopTest(); 
        
        
        Account accData = [Select Id from Account where id=:testAccount.Id];      
        
        TF_VerifyAccountAddress.billingAddressVerify(accData);  
        TF_VerifyAccountAddress.mailingAddressVerify(accData); 
        TF_VerifyAccountAddress.shippingAddressVerify(accData); 
        
    }
    @isTest
    Public static void test_AddressVerificationFailure(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Billing_Street__c ='test';
        testAccount.Billing_City__c ='test';
        testAccount.Fax ='test';        
        testAccount.Billing_Country_List__c='India';
        
        testAccount.BillingStreet ='test';
        testAccount.BillingCity ='test';
        testAccount.BillingPostalCode ='test';
        testAccount.Mailing_Country_List__c='India';
        
        testAccount.ShippingStreet ='test';
        testAccount.ShippingCity ='test';
        testAccount.ShippingPostalCode ='test';
        testAccount.Shipping_Country_List__c='India';
        insert testAccount;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;
        
       TF_OrgSpecificProps__c  AddressAPIDetails = new TF_OrgSpecificProps__c ();
        AddressAPIDetails.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert AddressAPIDetails;

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        TF_VerifyAccountAddress.getaccountId(testAccount.Id);
        test.stopTest(); 
        
        
        Account accData = [Select Id from Account where id=:testAccount.Id];      
        
        TF_VerifyAccountAddress.billingAddressVerify(accData);  
        TF_VerifyAccountAddress.mailingAddressVerify(accData); 
        TF_VerifyAccountAddress.shippingAddressVerify(accData); 
        
        
    }
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody(JSON.serialize(token));
            res.setStatusCode(200);
            return res;
        }
    }
    public class TokenDetailsGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody(JSON.serialize(token));
            res.setStatusCode(400);
           return res;
        }
    }
    class TokenDetails {
        private String details ='An invalid address field value has been entered, please correct and confirm.\'\"},\'' ;
        private String access_token ='123';
        private String token_type ='123';
        private Decimal expires_in = 123;
        private String id_token='123'; 
        private String refresh_token='123';
    } 

}