/*
 * Class: TF_SAP_BP_Creation_Handler
 * Created by: Piyush Jain
 * */
@IsTest(SeeAllData=false)
public class zTEST_TF_SAP_BP_Creation_Handler {
    
    @isTest
    Public static void test_SAP_BP_CreateBusinessPartner(){       
        
        Set<id> SapBpIdSet = new Set<id>();
        Set<id> SapBpIdSet_1 = new Set<id>();
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        Map<String, Id> SapIdToLookupMap_1 = new Map<String, Id>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.SAP_BP_Creation__c = 'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
        insert orgSpecificProps;
        
        //Test account
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        //Test sap bp record
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
        SAP_BP_Record.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record;
        //Test sap bp record
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
        SAP_BP_Record_1.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record_1;
        
        //Test opportunity record
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId = acc.id;
        opp.stageName = 'Test';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        insert opp;
        
        //Test order record
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        insert order_Record;
        
        SapBpIdSet.add(SAP_BP_Record.id);
        SapBpIdSet.add(SAP_BP_Record_1.id);
        SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        //Test sap bp record
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_2.City__c = 'Test';
        SAP_BP_Record_2.Country__c = 'India';
        SAP_BP_Record_2.State__c = 'Test';
        SAP_BP_Record_2.Street__c = 'Test';
        SAP_BP_Record_2.ZIP__c = 'Test';
        SAP_BP_Record_2.Region__c = 'Test';
        SAP_BP_Record_2.First_Name__c = 'Test';
        SAP_BP_Record_2.Last_Name__c = 'Test';
        SAP_BP_Record_2.Email__c = 'test@gmail.com';
        insert SAP_BP_Record_2;
        //Test sap bp record
        SAP_BP__c SAP_BP_Record_3 = new SAP_BP__c();
        SAP_BP_Record_3.Name = 'Pending';
        SAP_BP_Record_3.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_3.City__c = 'Test';
        SAP_BP_Record_3.Country__c = 'India';
        SAP_BP_Record_3.State__c = 'Test';
        SAP_BP_Record_3.Street__c = 'Test';
        SAP_BP_Record_3.ZIP__c = 'Test';
        SAP_BP_Record_3.Region__c = 'Test';
        SAP_BP_Record_3.First_Name__c = 'Test';
        SAP_BP_Record_3.Last_Name__c = 'Test';
        SAP_BP_Record_3.Email__c = 'test@gmail.com';
        insert SAP_BP_Record_3;
        //Test opportunity record
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test';
        opp_1.stageName = 'Test';
        opp_1.AccountId = acc.id;
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record_2.id;
        opp_1.Ship_to_BP__c = SAP_BP_Record_3.id;
        insert opp_1;
        
        SapBpIdSet_1.add(SAP_BP_Record_2.id);
        SapBpIdSet_1.add(SAP_BP_Record_3.id);
        SapIdToLookupMap_1.put('Bill to', opp_1.Bill_to_BP__c);
        SapIdToLookupMap_1.put('Ship to', opp_1.Ship_to_BP__c);
        //Insert country object record to get country ISO code
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet, null, opp.id, SapIdToLookupMap, order_Record.id, opp.Account.Name);
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet_1, null, opp_1.id, SapIdToLookupMap_1, order_Record.id, opp_1.Account.Name);
        //TF_SAP_BP_Creation_Handler.retryCase_Sap_BP_Callout(SapBpIdSet, SapBpIdSet, opp.id, SapIdToLookupMap, order_Record.id, opp.Account.Name);
        TF_SAP_BP_Creation_Handler.splitStringBySpace('Test', 40);
        test.stopTest();         
    }
    
    @isTest
    Public static void test_SAP_BP_CreateBusinessPartnerEmptyBody(){       
        Set<id> SapBpIdSet = new Set<id>();
        Set<id> SapBpIdSet_1 = new Set<id>();
        List<SAP_BP__C> sapBpList = new List<SAP_BP__C>();
        Map<String, Id> SapIdToLookupMap_1 = new Map<String, Id>();
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.SAP_BP_Creation__c = 'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
        insert orgSpecificProps;
        
        //Test account
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        //Test sap bp record
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record;
        //Test sap bp record
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'Pending';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record_1;
        
        //Test opportunity record
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Test';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        insert opp;
        
        //Test order record
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        insert order_Record;
        
        SapBpIdSet.add(SAP_BP_Record.id);
        SapBpIdSet.add(SAP_BP_Record_1.id);
        SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        //Test sap bp record
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_2.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record_2;
        //Test sap bp record
        SAP_BP__c SAP_BP_Record_3 = new SAP_BP__c();
        SAP_BP_Record_3.Name = 'Pending';
        SAP_BP_Record_3.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record_3;
        
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test';
        opp_1.stageName = 'Test';
        opp_1.AccountId = acc.id;
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record_2.id;
        opp_1.Ship_to_BP__c = SAP_BP_Record_3.id;
        insert opp_1;
        
        SapBpIdSet_1.add(SAP_BP_Record_2.id);
        SapBpIdSet_1.add(SAP_BP_Record_3.id);
        SapIdToLookupMap_1.put('Bill to', opp_1.Bill_to_BP__c);
        SapIdToLookupMap_1.put('Ship to', opp_1.Ship_to_BP__c);
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;  
        sapBpList.add(SAP_BP_Record);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet, null, opp.id, SapIdToLookupMap, order_Record.id, opp.Account.Name);
        //TF_SAP_BP_Creation_Handler.retryCase_Sap_BP_Callout(SapBpIdSet, SapBpIdSet, opp.id, SapIdToLookupMap, order_Record.id, opp.Account.Name);
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet_1, null, opp_1.id, SapIdToLookupMap_1, order_Record.id, opp_1.Account.Name);
        TF_SAP_BP_Creation_Handler.directSalesRetry(sapBpList, opp, SapIdToLookupMap, order_Record.id, opp.Account.Name);
        test.stopTest();         
    }
    
    @isTest
    Public static void test_SAP_BP_CreateBusinessPartnerError(){       
        
        Set<id> SapBpIdSet = new Set<id>();
        Set<id> SapBpIdSet_1 = new Set<id>();
        Map<String, Id> SapIdToLookupMap_1 = new Map<String, Id>();
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.SAP_BP_Creation__c = 'https://secure-dev.taylorandfrancis.com/createbusinesspartner';
        insert orgSpecificProps;
        
        //Test account
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
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
        SAP_BP_Record.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
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
        opp.AccountId = acc.id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp.Ship_to_BP__c = SAP_BP_Record.id;
        insert opp;
        
        //Test order record
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        insert order_Record;
        
        SapBpIdSet.add(SAP_BP_Record.id);
        SapBpIdSet.add(SAP_BP_Record_1.id);
        SapIdToLookupMap.put('Bill to', opp.Bill_to_BP__c);
        SapIdToLookupMap.put('Ship to', opp.Ship_to_BP__c);
        
        Department__c dept = new Department__c(Name= 'Long department name testing required more than 35 char', Account__c = acc.id);
        insert dept;
        
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Campus';
        SAP_BP_Record_2.Department_Id__c = dept.id;
        SAP_BP_Record_2.City__c = 'Test';
        insert SAP_BP_Record_2;
        
        SAP_BP__c SAP_BP_Record_3 = new SAP_BP__c();
        SAP_BP_Record_3.Name = 'Pending';
        SAP_BP_Record_3.Account_Id__c = acc.id;
        SAP_BP_Record_3.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_3.Street__c = 'Long street name testing required more than 35 char';
        SAP_BP_Record_3.City__c = 'Test';
        SAP_BP_Record_3.Message__c = '~msg~ Bill to: Address Verified ~msg~ Bill to: Address Not Verified ~msg~ Bill to: Generation Failed ~msg~ Bill to: Generated Successfully ~msg~ Ship to: Generated Successfully ~msg~ Ship to: Generation Failed ~msg~ Ship to: Address Verified ~msg~ Ship to: Address Not Verified';
        insert SAP_BP_Record_3;
        
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test';
        opp_1.stageName = 'Test';
        opp_1.AccountId = acc.id;
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record_3.id;
        opp_1.Ship_to_BP__c = SAP_BP_Record_2.id;
        insert opp_1;
        
        SapBpIdSet_1.add(SAP_BP_Record_2.id);
        SapBpIdSet_1.add(SAP_BP_Record_3.id);
        SapIdToLookupMap_1.put('Bill to', opp_1.Bill_to_BP__c);
        SapIdToLookupMap_1.put('Ship to', opp_1.Ship_to_BP__c);
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet, null, opp.id, SapIdToLookupMap, order_Record.id, opp_1.Account.Name);
        TF_SAP_BP_Creation_Handler.sap_BP_Callout(SapBpIdSet_1, null, opp_1.id, SapIdToLookupMap_1, order_Record.id, opp_1.Account.Name);
        TF_SAP_BP_Creation_Handler.updateOppMessageExcp(SAP_BP_Record, 'error', SapIdToLookupMap, opp.id);
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