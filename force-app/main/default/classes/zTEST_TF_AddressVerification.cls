@IsTest(SeeAllData=false)
public class zTEST_TF_AddressVerification {
    
    private static List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
    @IsTest
    Public static void test_TF_SAP_BPAddressVerificationEmptyAddress(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert orgSpecificProps;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record_1;

        sapBpList.add(SAP_BP_Record_1);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;
        
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Id = opp.Bill_to_BP__c;
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Account Mailing';
        update SAP_BP_Record_2;
        
        SAP_BP__c SAP_BP_Record_3 = new SAP_BP__c();
        SAP_BP_Record_3.Id = opp.Ship_to_BP__c;
        SAP_BP_Record_3.Name = 'Pending';
        SAP_BP_Record_3.Address_Type__c = 'Account Mailing';
        update SAP_BP_Record_3;

        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        Test.stopTest();
        TF_AddressVerification.retryAddressVerification(opp, sapBpList);
    }
    
    @isTest
    Public static void test_TF_SAP_BPAddressVerificationEmptyAddressNotMsg(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert orgSpecificProps;
        
        Direct_sales_order_settings__c directSalesSettings = Direct_sales_order_settings__c.getOrgDefaults();
        directSalesSettings.OrderHub_post_order_domain__c = 'test';
        directSalesSettings.Alert_Email_Addresses__c = 'test';
        directSalesSettings.Send_emails_on_failure__c = True;
        directSalesSettings.Post_orders_to_OH__c = True;
        insert directSalesSettings;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Message__c = 'Bill to: Address Not Verified';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.Message__c = 'Ship to: Address Not Verified';
        insert SAP_BP_Record_1;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;

        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        Test.stopTest();
        TF_AddressVerification.retryAddressVerification(opp, sapBpList);
    }
    
   @isTest
    Public static void test_TF_SAP_BPAddressVerificationWithEmptyAdd(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null);
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
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
        SAP_BP_Record.Message__c = '';
        insert SAP_BP_Record;

        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.City__c = 'Test';
        SAP_BP_Record_1.Country__c = 'India';
        SAP_BP_Record_1.State__c = 'Test';
        SAP_BP_Record_1.Street__c = 'Test';
        SAP_BP_Record_1.ZIP__c = 'Test';
        SAP_BP_Record_1.Region__c = 'Test';
        SAP_BP_Record_1.First_Name__c = 'Test';
        SAP_BP_Record_1.Last_Name__c = 'Test';
        SAP_BP_Record_1.Email__c = 'test@gmail.com';
        SAP_BP_Record_1.Message__c = '';
        insert SAP_BP_Record_1;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 

        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;   
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        Test.stopTest();
    } 
    
    @IsTest
    Public static void test_TF_SAP_BPAddressVerificationError(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
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
        SAP_BP_Record.Message__c = 'Bill to: Address Not Verified';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1= new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.City__c = 'Test';
        SAP_BP_Record_1.Country__c = 'India';
        SAP_BP_Record_1.State__c = 'Test';
        SAP_BP_Record_1.Email__c = 'test@gmail.com';
        SAP_BP_Record_1.Message__c = 'Ship to: Address Not Verified';
        insert SAP_BP_Record_1;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        Test.stopTest();
    } 
    
    @IsTest
    Public static void test_TF_SAP_BPAddressVerificationSuccess(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
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
        SAP_BP_Record.Message__c = 'Bill to: Address Not Verified';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1= new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.City__c = 'Test';
        SAP_BP_Record_1.Country__c = 'India';
        SAP_BP_Record_1.State__c = 'Test';
        SAP_BP_Record_1.Email__c = 'test@gmail.com';
        SAP_BP_Record_1.Message__c = 'Ship to: Address Not Verified';
        insert SAP_BP_Record_1;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;
        
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        Test.stopTest();
        TF_AddressVerification.updateOppMessageExcp(SAP_BP_Record, 'Posting order to order hub', SapIdToLookupMap, opp.id);
        TF_AddressVerification.updateOppMessageField(sapBpList, opp.id, SapIdToLookupMap, false);
    } 
    
    @IsTest
    Public static void test_TF_SAP_BPAddressVerificationSuccessEmptyMsg(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TriggerInterfaceHelper.runTrigger('TF_AddressVerification', 'Opportunity', 1, 'au', recId, null); 
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
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
        SAP_BP_Record.Message__c = '';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1= new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.City__c = 'Test';
        SAP_BP_Record_1.Country__c = 'India';
        SAP_BP_Record_1.State__c = 'Test';
        SAP_BP_Record_1.Email__c = 'test@gmail.com';
        SAP_BP_Record_1.Message__c = '';
        insert SAP_BP_Record_1;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;
        
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        Test.stopTest();
        TF_AddressVerification.updateOppMessageExcp(SAP_BP_Record_1, 'error', SapIdToLookupMap, opp.id);
    } 
    
    @isTest
    Public static void test_TF_SAP_BPAddressVerificationEmptySapList(){
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Verify_Addrress_Endpoint__c = 'https://secure-uat.taylorandfrancis.com/verifyaddress';
        insert orgSpecificProps;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Message__c = 'Bill to: Address Verified';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.Message__c = 'Ship to: Address Verified';
        insert SAP_BP_Record_1;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp; 
        update opp;

        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        TF_AddressVerification.retryAddressVerification(opp, sapBpList);
    }
    
    
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setStatusCode(200);
            res.setBody('{ "metadata": { "code": 200, "timestamp": "2019.12.11.11.21.32.011", "details": "New Customer" } }');
            return res;
        }
    }
    public class TokenDetailsGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse(); 
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody('{ "metadata": { "code": 400, "timestamp": "2019.12.11.11.17.55.190", "details": "Validation failure; field Failed to validate country code. Country code should be in ISO 3166-2 uppercase value.; field must not be blank" }, "data": null }');
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