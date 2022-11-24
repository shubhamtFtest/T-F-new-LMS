@IsTest(SeeAllData=false)
public class zTEST_TF_OrderTaxCalculation_Handler {

    
    @isTest
    Public static void test_TF_OrderTaxCalculation_Handler(){       
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
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
        SAP_BP_Record.BP__c = 'Test';
        insert SAP_BP_Record;
		sapBpList.add(SAP_BP_Record);
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        insert opp;
        
        Product2 pro = new Product2();
        pro.Name = 'Test';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        Order order_Record = new Order();
        //order_Record.CurrencyIsoCode = '';
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Failed';
        insert order_Record;
        
        Order order_Record2 = new Order();
        order_Record2.OpportunityId = opp.id;
        order_Record2.Pricebook2Id = Test.getStandardPricebookId();
        order_Record2.AccountId = acc.id;
        order_Record2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record2.Status = 'Draft';
        order_Record2.Message__c = 'Tax Calculation-Success';
        insert order_Record2;
        
        SAP_BP__c SAP_BP_Record1 = new SAP_BP__c();
        SAP_BP_Record1.Name = 'Test';
        SAP_BP_Record1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record1.City__c = '';
        SAP_BP_Record1.Country__c = '';
        SAP_BP_Record1.State__c = '';
        SAP_BP_Record1.Street__c = '';
        SAP_BP_Record1.ZIP__c = '';
        SAP_BP_Record1.Region__c = '';
        SAP_BP_Record1.First_Name__c = '';
        SAP_BP_Record1.Last_Name__c = '';
        SAP_BP_Record1.Email__c = '';
        SAP_BP_Record1.BP__c = '';
        insert SAP_BP_Record1;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test';
        opp3.stageName = 'Prospect';
        opp3.CloseDate = Date.newInstance(2019, 12, 9);
        opp3.Bill_to_BP__c = SAP_BP_Record1.id;
        insert opp3;
        
        Order order_Record3 = new Order();
        order_Record3.OpportunityId = opp3.id;
        order_Record3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record3.AccountId = acc.id;
        order_Record3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record3.Status = 'Draft';
        order_Record3.Message__c = '';
        insert order_Record3;
        
        List<OrderItem> orderProducts = new List<OrderItem>();
        OrderItem orderProduct1 = new OrderItem();
        orderProduct1.OrderId = order_Record.id;
        orderProduct1.Quantity = 1;
        orderProduct1.UnitPrice = 20;
        orderProduct1.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct1);  
        
        OrderItem orderProduct2 = new OrderItem();
        orderProduct2.OrderId = order_Record.id;
        orderProduct2.Quantity = 1;
        orderProduct2.UnitPrice = 20;
        orderProduct2.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct2); 
        insert orderProducts;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record2.id, true, true, opp, sapBpList);
        //TF_OrderTaxCalculation_Handler.orderCallout(order_Record3.id, true, true, opp, sapBpList);
        test.stopTest();         
     }
    
    @isTest
    Public static void test_TF_OrderTaxCalculation_HandlerError(){       
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Order_Tax_Calculation__c = 'https://secure-dev.taylorandfrancis.com/calctax';
        insert orgSpecificProps;
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        Set<Id> generatedSapBPIdsSet = new Set<Id>();
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Test';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.City__c = '';
        SAP_BP_Record.Country__c = '';
        SAP_BP_Record.State__c = '';
        SAP_BP_Record.Street__c = '';
        SAP_BP_Record.ZIP__c = '';
        SAP_BP_Record.Region__c = '';
        SAP_BP_Record.First_Name__c = '';
        SAP_BP_Record.Last_Name__c = '';
        SAP_BP_Record.Email__c = '';
        SAP_BP_Record.BP__c = '';
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
        SAP_BP_Record_1.BP__c = 'Test';
        insert SAP_BP_Record_1;
        generatedSapBPIdsSet.add(SAP_BP_Record_1.id);
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record_2;
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F OA Journal Opportunity').getRecordTypeId();
        //Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp;
        sapBpList.add(SAP_BP_Record);
        
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test';
        opp_1.stageName = 'Prospect';
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp_1;
        
        Opportunity opp_2 = new Opportunity();
        opp_2.Name = 'Test';
        opp_2.stageName = 'Prospect';
        opp_2.CloseDate = Date.newInstance(2019, 12, 9);
        opp_2.Bill_to_BP__c = SAP_BP_Record_2.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp_2;
        
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Failed ~msg~ Posting order to order hub-Failed';
        insert order_Record;        
                
        Order order_Record2 = new Order();
        order_Record2.OpportunityId = opp_1.id;
        order_Record2.Pricebook2Id = Test.getStandardPricebookId();
        order_Record2.AccountId = acc.id;
        order_Record2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record2.Status = 'Draft';
        order_Record2.Message__c = '';
        insert order_Record2;
        
        Order order_Record_3 = new Order();
        order_Record_3.OpportunityId = opp_2.id;
        order_Record_3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_3.AccountId = acc.id;
        order_Record_3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_3.Status = 'Draft';
        order_Record_3.Message__c = 'error';
        insert order_Record_3;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record2.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record_3.id, true, true, opp_2, sapBpList);
        TF_OrderTaxCalculation_Handler.updateOrderInException(order_Record, 'error');
        TF_OrderTaxCalculation_Handler.directOrderCallout(order_Record.id, true, true, opp.id, generatedSapBPIdsSet);
        //TF_OrderTaxCalculation_Handler.retryOrderCallout(order_Record.id, true, true);
        test.stopTest();         
    }
    
    @isTest
    Public static void test_TF_OrderTaxCalculation_HandlerError_1(){       
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Order_Tax_Calculation__c = 'https://secure-dev.taylorandfrancis.com/calctax';
        insert orgSpecificProps;
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        Set<Id> generatedSapBPIdsSet = new Set<Id>();
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Test';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.City__c = '';
        SAP_BP_Record.Country__c = '';
        SAP_BP_Record.State__c = '';
        SAP_BP_Record.Street__c = 'test';
        SAP_BP_Record.ZIP__c = '';
        SAP_BP_Record.Region__c = '';
        SAP_BP_Record.First_Name__c = '';
        SAP_BP_Record.Last_Name__c = '';
        SAP_BP_Record.Email__c = '';
        SAP_BP_Record.BP__c = '';
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
        SAP_BP_Record_1.BP__c = 'Test';
        insert SAP_BP_Record_1;
        generatedSapBPIdsSet.add(SAP_BP_Record_1.id);
        SAP_BP__c SAP_BP_Record_2 = new SAP_BP__c();
        SAP_BP_Record_2.Name = 'Pending';
        SAP_BP_Record_2.Address_Type__c = 'Account Mailing';
        insert SAP_BP_Record_2;
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F OA Journal Opportunity').getRecordTypeId();
        //Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BP_Record.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp;
        sapBpList.add(SAP_BP_Record);
        
        Opportunity opp_1 = new Opportunity();
        opp_1.Name = 'Test';
        opp_1.stageName = 'Prospect';
        opp_1.CloseDate = Date.newInstance(2019, 12, 9);
        opp_1.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp_1;
        
        Opportunity opp_2 = new Opportunity();
        opp_2.Name = 'Test';
        opp_2.stageName = 'Prospect';
        opp_2.CloseDate = Date.newInstance(2019, 12, 9);
        opp_2.Bill_to_BP__c = SAP_BP_Record_2.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp_2;
        
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Failed ~msg~ Posting order to order hub-Failed';
        insert order_Record;        
                
        Order order_Record2 = new Order();
        order_Record2.OpportunityId = opp_1.id;
        order_Record2.Pricebook2Id = Test.getStandardPricebookId();
        order_Record2.AccountId = acc.id;
        order_Record2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record2.Status = 'Draft';
        order_Record2.Message__c = '';
        insert order_Record2;
        
        Order order_Record_3 = new Order();
        order_Record_3.OpportunityId = opp_2.id;
        order_Record_3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record_3.AccountId = acc.id;
        order_Record_3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record_3.Status = 'Draft';
        order_Record_3.Message__c = 'error';
        insert order_Record_3;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorFailure());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record2.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record_3.id, true, true, opp_2, sapBpList);
        TF_OrderTaxCalculation_Handler.updateOrderInException(order_Record, 'error');
        TF_OrderTaxCalculation_Handler.directOrderCallout(order_Record.id, true, true, opp.id, generatedSapBPIdsSet);
        //TF_OrderTaxCalculation_Handler.retryOrderCallout(order_Record.id, true, true);
        test.stopTest();         
    }
    
    @isTest
    Public static void test_TF_OrderTaxCalculation_Handler_BPC_orders(){       
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        orgSpecificProps.Order_Tax_Calculation__c = 'https://secure-dev.taylorandfrancis.com/calctax';
        insert orgSpecificProps;
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        Set<Id> generatedSapBPIdsSet = new Set<Id>();
        
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
        SAP_BP_Record_1.BP__c = 'Test';
        insert SAP_BP_Record_1;
        generatedSapBPIdsSet.add(SAP_BP_Record_1.id);
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordTypeId = oppRecordTypeId;
        insert opp;
        sapBpList.add(SAP_BP_Record_1);
        
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
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = '';
        insert order_Record;      
        
        OrderItem orderProduct1 = new OrderItem();
        orderProduct1.OrderId = order_Record.id;
        orderProduct1.Quantity = 1;
        orderProduct1.UnitPrice = 20;
        orderProduct1.PricebookEntryId = priceBookEntry.id;
        insert orderProduct1;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        test.stopTest();         
    }
    
    @isTest
    Public static void test2_LMS(){       
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
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
        SAP_BP_Record.BP__c = 'Test';
        insert SAP_BP_Record;
		sapBpList.add(SAP_BP_Record);
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        insert opp;
        
        String bespokeRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        Product2 pro = new Product2();
        pro.RecordTypeId = bespokeRecordTypeId;
        pro.Product_Type_Author_Facing__c = 'Manual Curation';
        pro.Name = 'Test';
        insert pro;
        
        Bundle_Line_Item__c bundleItem = new Bundle_Line_Item__c();
        bundleItem.Product_Bundle_Parent__c = pro.Id;
        bundleItem.CurrencyIsoCode = 'USD';
        bundleItem.PriceUSD__c = 100;
        bundleItem.Product_Isbn__c = '9781003056478';
        insert bundleItem;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        Order order_Record = new Order();
        //order_Record.CurrencyIsoCode = '';
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Failed';
        insert order_Record;
        
        Order order_Record2 = new Order();
        order_Record2.OpportunityId = opp.id;
        order_Record2.Pricebook2Id = Test.getStandardPricebookId();
        order_Record2.AccountId = acc.id;
        order_Record2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record2.Status = 'Draft';
        order_Record2.Message__c = 'Tax Calculation-Success';
        insert order_Record2;
        
        SAP_BP__c SAP_BP_Record1 = new SAP_BP__c();
        SAP_BP_Record1.Name = 'Test';
        SAP_BP_Record1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record1.City__c = '';
        SAP_BP_Record1.Country__c = '';
        SAP_BP_Record1.State__c = '';
        SAP_BP_Record1.Street__c = '';
        SAP_BP_Record1.ZIP__c = '';
        SAP_BP_Record1.Region__c = '';
        SAP_BP_Record1.First_Name__c = '';
        SAP_BP_Record1.Last_Name__c = '';
        SAP_BP_Record1.Email__c = '';
        SAP_BP_Record1.BP__c = '';
        insert SAP_BP_Record1;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test';
        opp3.stageName = 'Prospect';
        opp3.CloseDate = Date.newInstance(2019, 12, 9);
        opp3.Bill_to_BP__c = SAP_BP_Record1.id;
        insert opp3;
        
        Order order_Record3 = new Order();
        order_Record3.OpportunityId = opp3.id;
        order_Record3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record3.AccountId = acc.id;
        order_Record3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record3.Status = 'Draft';
        order_Record3.Message__c = '';
        insert order_Record3;
        
        List<OrderItem> orderProducts = new List<OrderItem>();
        OrderItem orderProduct1 = new OrderItem();
        orderProduct1.OrderId = order_Record.id;
        orderProduct1.Product2Id = pro.id;
        orderProduct1.Quantity = 1;
        orderProduct1.UnitPrice = 20;
        orderProduct1.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct1);  
        
        OrderItem orderProduct2 = new OrderItem();
        orderProduct2.OrderId = order_Record.id;
        orderProduct2.Quantity = 1;
        orderProduct2.Product2Id = pro.id;
        orderProduct2.UnitPrice = 20;
        orderProduct2.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct2); 
        insert orderProducts;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record2.id, true, true, opp, sapBpList);
        //TF_OrderTaxCalculation_Handler.orderCallout(order_Record3.id, true, true, opp, sapBpList);
        test.stopTest();         
     }
    //Added by shubham kumar
    //@description : This method is for testing the item list for Collection Sales
    @isTest
    Public static void testItemListAsCollection(){       
        List<SAP_BP__c> sapBpList = new List<SAP_BP__c>();
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
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
        SAP_BP_Record.BP__c = 'Test';
        insert SAP_BP_Record;
		sapBpList.add(SAP_BP_Record);
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Prospect';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record.id;
        insert opp;
        
        String bespokeRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Collection').getRecordTypeId();
        Product2 pro = new Product2();
        pro.RecordTypeId = bespokeRecordTypeId;
        pro.Product_Type_Author_Facing__c = 'Manual Curation';
        pro.Name = 'Test';
        pro.businessId__c = 'THE-AI-ML';
        pro.Sales_Channels__c = 'OPC';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
        
        Order order_Record = new Order();
        //order_Record.CurrencyIsoCode = '';
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        order_Record.Message__c = 'Tax Calculation-Failed';
        insert order_Record;
        
        Order order_Record2 = new Order();
        order_Record2.OpportunityId = opp.id;
        order_Record2.Pricebook2Id = Test.getStandardPricebookId();
        order_Record2.AccountId = acc.id;
        order_Record2.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record2.Status = 'Draft';
        order_Record2.Message__c = 'Tax Calculation-Success';
        insert order_Record2;
        
        SAP_BP__c SAP_BP_Record1 = new SAP_BP__c();
        SAP_BP_Record1.Name = 'Test';
        SAP_BP_Record1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record1.City__c = '';
        SAP_BP_Record1.Country__c = '';
        SAP_BP_Record1.State__c = '';
        SAP_BP_Record1.Street__c = '';
        SAP_BP_Record1.ZIP__c = '';
        SAP_BP_Record1.Region__c = '';
        SAP_BP_Record1.First_Name__c = '';
        SAP_BP_Record1.Last_Name__c = '';
        SAP_BP_Record1.Email__c = '';
        SAP_BP_Record1.BP__c = '';
        insert SAP_BP_Record1;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test';
        opp3.stageName = 'Prospect';
        opp3.CloseDate = Date.newInstance(2019, 12, 9);
        opp3.Bill_to_BP__c = SAP_BP_Record1.id;
        insert opp3;
        
        Order order_Record3 = new Order();
        order_Record3.OpportunityId = opp3.id;
        order_Record3.Pricebook2Id = Test.getStandardPricebookId();
        order_Record3.AccountId = acc.id;
        order_Record3.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record3.Status = 'Draft';
        order_Record3.Message__c = '';
        insert order_Record3;
        
        List<OrderItem> orderProducts = new List<OrderItem>();
        OrderItem orderProduct1 = new OrderItem();
        orderProduct1.OrderId = order_Record.id;
        orderProduct1.Product2Id = pro.id;
        orderProduct1.Quantity = 1;
        orderProduct1.UnitPrice = 20;
        orderProduct1.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct1);  
        
        OrderItem orderProduct2 = new OrderItem();
        orderProduct2.OrderId = order_Record.id;
        orderProduct2.Quantity = 1;
        orderProduct2.Product2Id = pro.id;
        orderProduct2.UnitPrice = 20;
        orderProduct2.PricebookEntryId = priceBookEntry.id;
        orderProducts.add(orderProduct2); 
        insert orderProducts;
        
        Country__c CountryObj = new Country__c();
        CountryObj.Country_2__c  = 'IN';
        CountryObj.Name  = 'India'; 
        insert CountryObj;    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenDetailsGeneratorSuccess());
        TF_OrderTaxCalculation_Handler.orderCallout(order_Record.id, true, true, opp, sapBpList);
        //TF_OrderTaxCalculation_Handler.orderCallout(order_Record2.id, true, true, opp, sapBpList);
        //TF_OrderTaxCalculation_Handler.orderCallout(order_Record3.id, true, true, opp, sapBpList);
        test.stopTest();         
     }
    public class TokenDetailsGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            String response = '{ "metadata": { "code": 200, "timestamp": "2019.11.20.12.01.14.638", "details": null }, "data": { "productType": "TF-EBOOK", "items": [ { "offerCode": "ZMSC", "quantity": 1, "priceCode": null, "productId": "9781315179636", "price": 120.00, "tax": 24.00, "taxRates": [ 20.00 ] }, { "offerCode": "ZMSC", "quantity": 1, "priceCode": null, "productId": "9781315731162", "price": 264.00, "tax": 52.80, "taxRates": [ 20.00 ] } ] } }';
            res.setBody(response);
            res.setStatusCode(200);
            return res;
        }
    }
    public class TokenDetailsGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            TokenDetails token = new TokenDetails();
            res.setBody('{"metadata":{"code":422,"timestamp":"2019.11.29.08.31.04.095","details":"Billing address verification failed; rejecting tax calculation request"},"data":null}');
            res.setStatusCode(422);
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