@IsTest(SeeAllData=false)
public class zTest_TF_SAP_BP_ErrorHandling {
    
    Private static List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
    @testSetup static void setup() {
        List<opportunity> oppList = new List<Opportunity>();
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.SAP_BP_Creation__c = 'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
        orgSpecificProps.Order_Tax_Calculation__c = 'https://secure-dev.taylorandfrancis.com/calctax';
        insert orgSpecificProps;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.City__c = 'Test';
        SAP_BP_Record.Country__c = 'India';
        SAP_BP_Record.State__c = 'Test';   
        SAP_BP_Record.Street__c = 'Test';  
        SAP_BP_Record.ZIP__c = 'Test';
        SAP_BP_Record.Region__c = 'Test';
        SAP_BP_Record.First_Name__c = 'Test';
        SAP_BP_Record.Last_Name__c = 'Test';
        SAP_BP_Record.Email__c = 'test@gmail.com';
        SAP_BP_Record.Message__c = 'Bill to: Generation Failed ~msg~ Bill to: Address Not Verified';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.City__c = 'Test';
        SAP_BP_Record_1.Country__c = 'India';
        SAP_BP_Record_1.Message__c = 'Ship to: Generation Failed ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record_1;
        
        sapBpList.add(SAP_BP_Record);
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Order_Status__c = 'Failed'; 
        opp.StageName = 'Order Pending';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.Message__c = '';
        opp.RecordtypeId = recId;
        opp.Account_Validate_Opp__c = true;
        insert opp; 
        
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test_1';
        opp_1.Order_Status__c = 'Failed'; 
        opp_1.StageName = 'Order Pending';
        opp_1.AccountId = a.id;
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record.id;
        opp_1.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp_1.Message__c = 'Tax Calculation-Success ~msg~ Posting order to order hub-Success ~msg~ Bill to: Generated Successfully ~msg~ Bill to: Generation Failed ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        opp_1.RecordtypeId = recId;
        opp_1.Account_Validate_Opp__c = true;
        insert opp_1; 
        
        Opportunity opp_2 = new Opportunity();
        opp_2.Name = 'Test_2';
        opp_2.Order_Status__c = 'Failed'; 
        opp_2.StageName = 'Order Pending';
        opp_2.AccountId = a.id;
        opp_2.CloseDate = Date.newInstance(2019, 12, 9);
        opp_2.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp_2.Message__c = 'Ship to: Generated Successfully ~msg~ Ship to: Address Not Verified';
        opp_2.RecordtypeId = recId;
        opp_2.Account_Validate_Opp__c = true;
        insert opp_2; 
        
        Opportunity opp_3 = new Opportunity();
        opp_3.Name = 'Test_3';
        opp_3.stageName = 'Order Pending';
        opp_3.Order_Status__c = 'Failed';
        opp_3.AccountId = a.id;
        opp_3.CloseDate = Date.newInstance(2019, 12, 9);
        opp_3.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp_3.Message__c = 'Bill to: Generated Successfully';
        opp_3.RecordtypeId = recId;
        opp_3.Account_Validate_Opp__c = true;
        insert opp_3; 
        
        Opportunity opp_4 = new Opportunity();
        opp_4.Name = 'Test_4';
        opp_4.Order_Status__c = 'Failed';
        opp_4.stageName = 'Order Pending';
        opp_4.AccountId = a.id;
        opp_4.CloseDate = Date.newInstance(2019, 12, 9);
        opp_4.Message__c = '';
        opp_4.RecordtypeId = recId;
        opp_4.Account_Validate_Opp__c = true;
        insert opp_4; 
        
        
        Opportunity opp_5 = new Opportunity();
        opp_5.Name = 'Test_5';
        opp_5.Order_Status__c = 'Failed';
        opp_5.stageName = 'Order Pending';
        opp_5.AccountId = a.id;
        opp_5.CloseDate = Date.newInstance(2019, 12, 9);
        opp_5.Bill_to_BP__c = SAP_BP_Record.id;
        opp_5.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp_5.Message__c = 'Tax Calculation-Success ~msg~ Posting order to order hub-Success ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Bill to: Address Verified ~msg~ Ship to: Address Verified';
        opp_5.RecordtypeId = recId;
        opp_5.Account_Validate_Opp__c = true;
        insert opp_5; 
        
        Opportunity opp_6 = new Opportunity();
        opp_6.Name = 'Test_6';
        opp_6.Order_Status__c = 'Failed';
        opp_6.stageName = 'Order Pending';
        opp_6.AccountId = a.id;
        opp_6.CloseDate = Date.newInstance(2019, 12, 9);
        opp_6.Bill_to_BP__c = SAP_BP_Record.id;
        opp_6.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp_6.Message__c = 'Bill to: Address Verified ~msg~ Ship to: Address Verified';
        opp_6.RecordtypeId = recId;
        opp_6.Account_Validate_Opp__c = true;
        insert opp_6; 
        
        Opportunity opp_7 = new Opportunity();
        opp_7.Name = 'Test_7';
        opp_7.Order_Status__c = 'Failed';
        opp_7.stageName = 'Order Pending';
        opp_7.AccountId = a.id;
        opp_7.CloseDate = Date.newInstance(2019, 12, 9);
        opp_7.Bill_to_BP__c = SAP_BP_Record.id;
        opp_7.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp_7.Message__c = 'Bill to: Generation Failed';
        opp_7.RecordtypeId = recId;
        opp_7.Account_Validate_Opp__c = true;
        insert opp_7;
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.Id ,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject;
        SBQQ__Quote__c quoteObject_1 = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp_1.Id ,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject_1;
        SBQQ__Quote__c quoteObject_2 = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp_2.Id ,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject_2;
        SBQQ__Quote__c quoteObject_3 = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp_3.Id ,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject_3;
        SBQQ__Quote__c quoteObject_4 = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp_7.Id ,SBQQ__BillingCity__c = 'test Billing',SBQQ__Account__c = a.Id, Payer_Account__c = a.Id, SBQQ__ExpirationDate__c = System.today() + 60, SBQQ__Status__c = 'Accepted', SBQQ__Primary__c=true,Quote_Type__c = 'Direct Sale', RecordTypeId = quoteRecordtypeId); 
        insert quoteObject_4;
        
        opp.SBQQ__PrimaryQuote__c = quoteObject.id;
        oppList.add(opp);
        opp_1.SBQQ__PrimaryQuote__c = quoteObject_1.id;
        oppList.add(opp_1);
        opp_2.SBQQ__PrimaryQuote__c = quoteObject_2.id;
        oppList.add(opp_2);
        opp_3.SBQQ__PrimaryQuote__c = quoteObject_3.id;
        oppList.add(opp_3);
        opp_7.SBQQ__PrimaryQuote__c = quoteObject_4.id;
        oppList.add(opp_7);
        update oppList;
        
        Product2 pro = new Product2();
        pro.Name = 'Test';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = a.id;
        order_Record.SBQQ__Quote__c = quoteObject.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = '';
        insert order_Record;
        
        Order order_Record_1 = new Order();
        order_Record_1.OpportunityId = opp_1.id;
        order_Record_1.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_1.AccountId = a.id;
        order_Record_1.SBQQ__Quote__c = quoteObject_1.id;
        order_Record_1.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_1.Status = 'Draft';
        order_Record_1.Message__c = 'Tax Calculation-Failed ~msg~ Posting order to order hub-Failed';
        insert order_Record_1;
        
        Order order_Record_2 = new Order();
        order_Record_2.OpportunityId = opp_2.id;
        order_Record_2.Pricebook2Id = Test.getStandardPricebookId();  
        order_Record_2.AccountId = a.id;
        order_Record_2.SBQQ__Quote__c = quoteObject_2.id;
        order_Record_2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_2.Status = 'Draft';
        order_Record_2.Message__c = 'Tax Calculation-Success ~msg~ Posting order to order hub-Success';
        insert order_Record_2;
        
        Order order_Record_3 = new Order();
        order_Record_3.OpportunityId = opp_3.id;
        order_Record_3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_3.AccountId = a.id;
        order_Record_3.SBQQ__Quote__c = quoteObject_3.id;
        order_Record_3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_3.Status = 'Draft';
        order_Record_3.Message__c = 'Tax Calculation-Success ~msg~ Posting order to order hub-Success';
        insert order_Record_3;
        
        Order order_Record_4 = new Order();
        order_Record_4.OpportunityId = opp_7.id;
        order_Record_4.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_4.AccountId = a.id;
        order_Record_4.SBQQ__Quote__c = quoteObject_4.id;
        order_Record_4.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_4.Status = 'Draft';
        order_Record_4.Message__c = '';
        insert order_Record_4;
        
        OrderItem orderProduct = new OrderItem();
        orderProduct.OrderId = order_Record.id;
        orderProduct.Quantity = 1;
        orderProduct.UnitPrice = 20;
        orderProduct.PricebookEntryId = priceBookEntry.id;
        insert orderProduct;
    }
    
    @IsTest
    Public static void TF_SAP_BP_EmptyOppMessageField(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        List<Opportunity> opp = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test']);
        if(!opp.isEmpty() && opp != NULL){
            TF_SAP_BP_ErrorHandling.getErrorMessage(opp.get(0).id, 'Opportunity');
            TF_SAP_BP_ErrorHandling.retry(null, opp.get(0).id, null);
        }
        
        List<Opportunity> opp_1 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_1']);
        if(!opp_1.isEmpty() && opp_1 != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp_1.get(0).id, 'Opportunity');
        
        List<Opportunity> opp_2 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_4']);
        if(!opp_2.isEmpty() && opp_2 != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp_2.get(0).id, 'Opportunity');
        test.stopTest();
        
    }
    
    @IsTest
    Public static void TF_SAP_BP_errorInOppMessageField(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        List<Opportunity> opp_1 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_7']);
        if(!opp_1.isEmpty() && opp_1 != NULL) TF_SAP_BP_ErrorHandling.retry(null, opp_1.get(0).id,null);
        
        List<Opportunity> opp_2 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_1']);
        if(!opp_2.isEmpty() && opp_2 != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp_2.get(0).id, 'Opportunity');
        test.stopTest();
    }
    
    @IsTest
    Public static void TF_SAP_BP_errorInOppMessageField_1(){
        test.startTest();
        List<Opportunity> opp = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_2']);
        if(!opp.isEmpty() && opp != NULL) TF_SAP_BP_ErrorHandling.retry(null, opp.get(0).id, null);
        
        List<Opportunity> opp_1 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_5']);
        if(!opp_1.isEmpty() && opp_1 != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp_1.get(0).id, 'Opportunity');
        test.stopTest();
    }
    
    @IsTest
    Public static void TF_SAP_BP_errorInOppMessageField_2(){
        test.startTest();
        List<Opportunity> opp = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_2']);
        if(!opp.isEmpty() && opp != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp.get(0).id, 'Opportunity');
        
        List<Opportunity> opp_2 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_3']);
        if(!opp_2.isEmpty() && opp_2 != NULL) TF_SAP_BP_ErrorHandling.addressVerification(opp_2.get(0), sapBpList);
        test.stopTest();
    }
    
    @IsTest
    Public static void TF_SAP_BP_errorInOppMessageField_3(){
        test.startTest();
        List<Opportunity> opp = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_3']);
        if(!opp.isEmpty() && opp != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp.get(0).id, 'Opportunity');
        
        List<Opportunity> opp_1 = new List<Opportunity>([Select id, Name from Opportunity where Name ='Test_6']);
        if(!opp_1.isEmpty() && opp_1 != NULL) TF_SAP_BP_ErrorHandling.getErrorMessage(opp_1.get(0).id, 'Opportunity');
        test.stopTest();
    }
    
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody('{"metadata":{"code":201,"timestamp":"2019.11.29.07.48.16.661","details":"ISMBusinessPartner 3722380 has been created. External reference:"},"data":[{"externalCustomerAddressId":"2583","businessPartnerNumber":"0003722380"}]}');
            res.setStatusCode(201);
            return res;
        }
    }
    public class TokenDetailsGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse(); 
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody('{"metadata":{"code":400,"timestamp":"2019.11.29.07.55.14.770","details":"Validation failure; field must not be blank"},"data":null}');
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