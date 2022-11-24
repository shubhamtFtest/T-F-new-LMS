@IsTest(SeeAllData=false)
global class TF_VerifyAccountRequestAddressTest  {
    
    
    @isTest
    Public static void test_VerifyAccountRequestAddressSuccess(){
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Billing_Street__c ='test';
        testAccount.Billing_City__c ='test';
        testAccount.Fax ='test';
        testAccount.Billing_ZIP__c ='test';
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
        
        String BillingAddLine1='Test';
        String BillingAddLine2='Test';
        String MailingAddLine1='Test';
        String MailingAddLine2='Test';
        String ShippingAddLine1='Test';
        String ShippingAddLine2='Test'; 
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;       
                
        TF_OrgSpecificProps__c  AddressAPIDetails = new TF_OrgSpecificProps__c ();
        AddressAPIDetails.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert AddressAPIDetails;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_VerifyAccountRequestAddress.billingAddressVerify(testAccount, BillingAddLine1, BillingAddLine2);  
        TF_VerifyAccountRequestAddress.mailingAddressVerify(testAccount, MailingAddLine1, MailingAddLine2); 
        TF_VerifyAccountRequestAddress.shippingAddressVerify(testAccount, ShippingAddLine1, ShippingAddLine2); 
        test.stopTest(); 
        
        
        
    }
    
    @isTest
    Public static void test_VerifyAccountRequestAddressFaliure(){
        
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
        
        String BillingAddLine1='Test';
        String BillingAddLine2='Test';
        String MailingAddLine1='Test';
        String MailingAddLine2='Test';
        String ShippingAddLine1='Test';
        String ShippingAddLine2='Test'; 
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;
        
        TF_OrgSpecificProps__c  AddressAPIDetails = new TF_OrgSpecificProps__c ();
        AddressAPIDetails.Verify_Addrress_Endpoint__c  =   'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert AddressAPIDetails;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        TF_VerifyAccountRequestAddress.billingAddressVerify(testAccount, BillingAddLine1, BillingAddLine2);  
        TF_VerifyAccountRequestAddress.mailingAddressVerify(testAccount, MailingAddLine1, MailingAddLine2); 
        TF_VerifyAccountRequestAddress.shippingAddressVerify(testAccount, ShippingAddLine1, ShippingAddLine2); 
        test.stopTest(); 
    }
    
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
        
        String BillingAddLine1='';
        String BillingAddLine2='';
        String MailingAddLine1='';
        String MailingAddLine2='';
        String ShippingAddLine1='';
        String ShippingAddLine2=''; 
        
        TF_VerifyAccountRequestAddress.billingAddressVerify(testAccount, BillingAddLine1, BillingAddLine2);  
        TF_VerifyAccountRequestAddress.mailingAddressVerify(testAccount, MailingAddLine1, MailingAddLine2); 
        TF_VerifyAccountRequestAddress.shippingAddressVerify(testAccount, ShippingAddLine1, ShippingAddLine2); 
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