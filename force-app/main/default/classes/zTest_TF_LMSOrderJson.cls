/***************************************************************************
Author : Vikas Varshney
Apex class : TF_LMSOrderJson
****************************************************************************/

@isTest
global class zTest_TF_LMSOrderJson {
    
    static testMethod void OrderJsonTest() {
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BPShip_Record = new SAP_BP__c();
        SAP_BPShip_Record.Name = 'Pending';
        SAP_BPShip_Record.Address_Type__c = 'Account Mailing';
        SAP_BPShip_Record.Country__c = 'India';
        insert SAP_BPShip_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.StageName = 'Acceptance';
        opp.TF_eBook_License_Type__c = 'Static';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today();
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        opp.Ship_to_BP__c = SAP_BPShip_Record.id;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c( 
        CurrencyIsoCode = 'USD', 
        SBQQ__Opportunity2__c = opp.Id, 
        SBQQ__BillingCity__c = 'Test Billing', 
        SBQQ__Account__c = acc.Id, 
        Payer_Account__c = acc.Id, 
        SBQQ__ExpirationDate__c = System.today().addDays(60), 
        SBQQ__Status__c = 'Accepted', 
        SBQQ__Primary__c = true, 
        Quote_Type__c = 'Direct Sale', 
        Quote_Sales_Type__c = 'Bespoke Collection',
        RecordTypeId = quoteRecordtypeId ); 
        insert quoteObject;
        
        String prodRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        Product2 p = new Product2();
        p.RecordTypeid = prodRTId;
        p.Product_Type_Author_Facing__c = 'Manual Curation';
        p.Name = 'TestProd';
        p.ISBN__c = '123456';
        p.CurrencyIsoCode = 'USD';
        p.ProductCode = '9781003099277';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        p.Applicable_Customer_Types__c = 'Institution';
        p.Applicable_License_Types__c = 'Perpetual';
        p.Collection_Valid_From__c = system.today();
        p.List_Price__c = 1234; 
        insert p;
        
        String stdPBEStr = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry( 
        Pricebook2Id = stdPBEStr, 
        Product2Id = p.id, 
        UnitPrice = 100, 
        IsActive = true );
        insert standardPBE;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPBE = new PricebookEntry( 
        Pricebook2Id = customPB.Id, 
        Product2Id = p.Id, 
        UnitPrice = 120, 
        IsActive = true);
        insert customPBE;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = p.Id;
        qli.SBQQ__PricebookEntryId__c = customPBE.Id;
        qli.PCM_ISBN__c = '123456';
        qli.PCM_UUID__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        qli.PCM_Product_Name__c = 'TestProd';
        qli.PCM_Author_Name__c = 'TestAuthor';
        qli.SBQQ__ListPrice__c = 100;
        qli.Line_reference__c = 'Test';
        qli.PCM_DOI__c = 'Test';
        insert qli;
        
        Order ord = new Order();
        ord.OpportunityId = opp.id;
        ord.AccountId = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Draft';
        ord.OrderReferenceNumber = 'Test';
        ord.Pricebook2Id = customPB.id;
        insert ord;
        
        OrderItem ordItem = new OrderItem();
        ordItem.orderid = ord.id;
        ordItem.Quantity = 1;
        ordItem.UnitPrice = 50;
        ordItem.SBQQ_NetTotal__c = 100;
        ordItem.SBQQ__TaxAmount__c = 10;
        ordItem.SBQQ__TaxCode__c = 'Test';
        ordItem.PCM_UUID__c = p.Hub_Id__c;
        ordItem.SBQQ__QuotedListPrice__c = 100;
        ordItem.SBQQ__OrderedQuantity__c = 1;
        ordItem.PricebookEntryId = customPBE.id;
        insert ordItem;
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = p.Id;
        lineitem.Title__c  = p.name;
        lineitem.Authors__c = 'TestAuthor';
        lineitem.doi__c = 'Test';
        lineItem.Product_Doi__c =  'productDoi' + p.id;
        lineItem.Product__c = p.Id;
        lineItem.Source__c = 'PCM';
        lineItem.Type__c = 'Type';
        lineItem.Valid__c = 'true';
        lineitem.uuid__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a'; //p.Hub_Id__c;
        lineItem.mediaType__c = 'Test';
        lineItem.lineItemStatus__c = 'IsInsert';
        lineItem.Publisher__c = 'Publisher';
        lineItem.Open_access__c = true;
        lineItem.Publication_Date__c = Date.today();        
        lineItem.Content_Position__c  = 1;
        lineItem.PriceUSD__c = 100;
        lineItem.PriceGBP__c = 100;
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.Product_Isbn__c = 'HSS-AFRICAN-2018';
        insert lineItem;
        
        Test.startTest();
        List<String> quoteIdsList = new List<String>();
        quoteIdsList.add(quoteObject.id);
        TF_LMSOrderJson.createLMSOrderJson( quoteIdsList );
        Test.stopTest();
    }
    
    static testMethod void OrderJsonTest2() {
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting;
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.StageName = 'Acceptance';
        opp.TF_eBook_License_Type__c = 'Static';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today();
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c( 
        CurrencyIsoCode = 'GBP', 
        SBQQ__Opportunity2__c = opp.Id, 
        SBQQ__BillingCity__c = 'Test Billing', 
        SBQQ__Account__c = acc.Id, 
        Payer_Account__c = acc.Id, 
        SBQQ__ExpirationDate__c = System.today().addDays(60), 
        SBQQ__Status__c = 'Accepted', 
        SBQQ__Primary__c = true, 
        Quote_Type__c = 'Direct Sale', 
        Quote_Sales_Type__c = 'Collection',
        RecordTypeId = quoteRecordtypeId ); 
        insert quoteObject;
        
        String prodRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        Product2 p = new Product2();
        p.RecordTypeid = prodRTId;
        p.Product_Type_Author_Facing__c = 'Rule based';
        p.Name = 'TestProd';
        p.ISBN__c = '123456';
        p.CurrencyIsoCode = 'GBP';
        p.ProductCode = '9781003099277';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        p.Applicable_Customer_Types__c = 'Institution';
        p.Applicable_License_Types__c = 'Perpetual';
        p.Collection_Valid_From__c = system.today();
        p.List_Price__c = 1234; 
        insert p;
        
        String stdPBEStr = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry( 
        Pricebook2Id = stdPBEStr, 
        Product2Id = p.id, 
        UnitPrice = 100, 
        IsActive = true );
        insert standardPBE;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPBE = new PricebookEntry( 
        Pricebook2Id = customPB.Id, 
        Product2Id = p.Id, 
        UnitPrice = 120, 
        IsActive = true);
        insert customPBE;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = p.Id;
        qli.SBQQ__PricebookEntryId__c = customPBE.Id;
        qli.PCM_ISBN__c = '123456';
        //qli.PCM_UUID__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        qli.PCM_Product_Name__c = 'TestProd';
        qli.PCM_Author_Name__c = 'TestAuthor';
        qli.SBQQ__ListPrice__c = 100;
        qli.Line_reference__c = 'Test';
        qli.PCM_DOI__c = 'Test';
        insert qli;
        
        Order ord = new Order();
        ord.OpportunityId = opp.id;
        ord.AccountId = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Draft';
        ord.OrderReferenceNumber = 'Test';
        ord.Pricebook2Id = customPB.id;
        insert ord;
        
        OrderItem ordItem = new OrderItem();
        ordItem.orderid = ord.id;
        ordItem.Quantity = 1;
        ordItem.UnitPrice = 50;
        ordItem.SBQQ_NetTotal__c = 100;
        ordItem.SBQQ__TaxAmount__c = 10;
        ordItem.SBQQ__TaxCode__c = 'Test';
        ordItem.PCM_UUID__c = p.Hub_Id__c;
        ordItem.SBQQ__QuotedListPrice__c = 100;
        ordItem.SBQQ__OrderedQuantity__c = 1;
        ordItem.PricebookEntryId = customPBE.id;
        insert ordItem;
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = p.Id;
        lineitem.Title__c  = p.name;
        lineitem.Authors__c = 'TestAuthor';
        lineitem.doi__c = 'Test';
        lineItem.Product_Doi__c =  'productDoi' + p.id;
        lineItem.Product__c = p.Id;
        lineItem.Source__c = 'PCM';
        lineItem.Type__c = 'Type';
        lineItem.Valid__c = 'true';
        lineitem.uuid__c = p.Hub_Id__c;
        lineItem.mediaType__c = 'Test';
        lineItem.lineItemStatus__c = 'IsInsert';
        lineItem.Publisher__c = 'Publisher';
        lineItem.Open_access__c = true;
        lineItem.Publication_Date__c = Date.today();        
        lineItem.Content_Position__c  = 1;
        lineItem.PriceUSD__c = 100;
        lineItem.PriceGBP__c = 100;
        lineItem.CurrencyIsoCode = 'GBP';
        insert lineItem;
        
        Test.startTest();
        List<String> quoteIdsList = new List<String>();
        quoteIdsList.add(quoteObject.id);
        TF_LMSOrderJson.createLMSOrderJson( quoteIdsList );
        Test.stopTest();
    }
    
    static testMethod void OrderJsonTest3() {
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.StageName = 'Acceptance';
        opp.TF_eBook_License_Type__c = 'Static';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today();
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c( 
        CurrencyIsoCode = 'GBP', 
        SBQQ__Opportunity2__c = opp.Id, 
        SBQQ__BillingCity__c = 'Test Billing', 
        SBQQ__Account__c = acc.Id, 
        Payer_Account__c = acc.Id, 
        SBQQ__ExpirationDate__c = System.today().addDays(60), 
        SBQQ__Status__c = 'Accepted', 
        SBQQ__Primary__c = true, 
        Quote_Type__c = 'Direct Sale', 
        Quote_Sales_Type__c = 'Single Title',
        RecordTypeId = quoteRecordtypeId ); 
        insert quoteObject;
        
        String prodRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        Product2 p = new Product2();
        p.RecordTypeid = prodRTId;
        p.Product_Type_Author_Facing__c = 'Manual Curation';
        p.Name = 'TestProd';
        p.ISBN__c = '123456';
        p.CurrencyIsoCode = 'GBP';
        p.ProductCode = '9781003099277';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        p.Applicable_Customer_Types__c = 'Institution';
        p.Applicable_License_Types__c = 'Perpetual';
        p.Collection_Valid_From__c = system.today();
        p.List_Price__c = 1234; 
        insert p;
        
        String stdPBEStr = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry( 
        Pricebook2Id = stdPBEStr, 
        Product2Id = p.id, 
        UnitPrice = 100, 
        IsActive = true );
        insert standardPBE;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPBE = new PricebookEntry( 
        Pricebook2Id = customPB.Id, 
        Product2Id = p.Id, 
        UnitPrice = 120, 
        IsActive = true);
        insert customPBE;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = p.Id;
        qli.SBQQ__PricebookEntryId__c = customPBE.Id;
        qli.PCM_ISBN__c = '123456';
        qli.PCM_UUID__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        qli.PCM_Product_Name__c = 'TestProd';
        qli.PCM_Author_Name__c = 'TestAuthor';
        qli.SBQQ__ListPrice__c = 100;
        qli.Line_reference__c = 'Test';
        qli.PCM_DOI__c = 'Test';
        insert qli;
        
        Order ord = new Order();
        ord.OpportunityId = opp.id;
        ord.AccountId = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Draft';
        ord.OrderReferenceNumber = 'Test';
        ord.Pricebook2Id = customPB.id;
        insert ord;
        
        OrderItem ordItem = new OrderItem();
        ordItem.orderid = ord.id;
        ordItem.Quantity = 1;
        ordItem.UnitPrice = 50;
        ordItem.SBQQ_NetTotal__c = 100;
        ordItem.SBQQ__TaxAmount__c = 10;
        ordItem.SBQQ__TaxCode__c = 'Test';
        ordItem.PCM_UUID__c = p.Hub_Id__c;
        ordItem.SBQQ__QuotedListPrice__c = 100;
        ordItem.SBQQ__OrderedQuantity__c = 1;
        ordItem.PricebookEntryId = customPBE.id;
        insert ordItem;
        
        Test.startTest();
        List<String> quoteIdsList = new List<String>();
        quoteIdsList.add(quoteObject.id);
        TF_LMSOrderJson.createLMSOrderJson( quoteIdsList );
        Test.stopTest();
    }
    
    static testMethod void OrderJsonTest4() {
        Account acc = new Account();
        acc.Customer_Id__c = '98422';
        acc.name = 'TestAcc';
        insert acc;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.OrderHubCalcTaxApi_URL__c = 'https://secure-uat.taylorfrancis.com/api/v4.0/tax/compute';
        setting.OrderHubApi_URL__c = 'https://api-uat.taylorandfrancis.com/v1/orders/';
        setting.UBX_Order_Platform_uri__c = 'https://api-uat.taylorfrancis.com';
        setting.New_Platform_Api_URL__c = 'https://api-uat.taylorfrancis.com';
        setting.Quote_Items_Threshold__c = '50';
        setting.EmailAddressForOrderHubAlarmNotification__c = 'test@gmail.com';
        setting.Order_Hub_Mandatory_Countries__c = 'US,CA,BR';
        setting.EmailAddressFoTaxrAlarmNotification__c='test@gmail.com';
        insert setting; 
        
        Country__c countryRecord = new Country__c(Name = 'India', Country_2__c ='IN');
        insert countryRecord;
        
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'Pending';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Country__c = 'India';
        insert SAP_BP_Record;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.StageName = 'Acceptance';
        opp.TF_eBook_License_Type__c = 'Static';
        opp.AccountId = acc.id;
        opp.CloseDate = Date.today();
        opp.Order_Status__c = 'Pending';
        opp.Account_Validate_Opp__c = true;
        opp.recordTypeId = oppRecordTypeId;
        opp.Bill_To_BP__c = SAP_BP_Record.id;
        insert opp;
        
        Id quoteRecordtypeId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'Automated eBook Direct Sales Orders');
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c( 
        CurrencyIsoCode = 'GBP', 
        SBQQ__Opportunity2__c = opp.Id, 
        SBQQ__BillingCity__c = 'Test Billing', 
        SBQQ__Account__c = acc.Id, 
        Payer_Account__c = acc.Id, 
        SBQQ__ExpirationDate__c = System.today().addDays(60), 
        SBQQ__Status__c = 'Accepted', 
        SBQQ__Primary__c = true, 
        Quote_Type__c = 'Direct Sale', 
        Quote_Sales_Type__c = 'Bespoke Collection',
        RecordTypeId = quoteRecordtypeId ); 
        insert quoteObject;
        
        String prodRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        Product2 p = new Product2();
        p.RecordTypeid = prodRTId;
        p.Product_Type_Author_Facing__c = 'Manual Curation';
        p.Name = 'TestProd';
        p.ISBN__c = '123456';
        p.CurrencyIsoCode = 'GBP';
        p.ProductCode = '9781003099277';
        p.IsActive = true;
        p.Hub_Id__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        p.inLanguage__c = 'en';
        p.Applicable_Customer_Types__c = 'Institution';
        p.Applicable_License_Types__c = 'Perpetual';
        p.Collection_Valid_From__c = system.today();
        p.List_Price__c = 1234; 
        insert p;
        
        String stdPBEStr = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry( 
        Pricebook2Id = stdPBEStr, 
        Product2Id = p.id, 
        UnitPrice = 100, 
        IsActive = true );
        insert standardPBE;
        
        Pricebook2 customPB = new Pricebook2(Name='T&F - eBooks Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPBE = new PricebookEntry( 
        Pricebook2Id = customPB.Id, 
        Product2Id = p.Id, 
        UnitPrice = 120, 
        IsActive = true);
        insert customPBE;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = quoteObject.Id;
        qli.SBQQ__Product__c = p.Id;
        qli.SBQQ__PricebookEntryId__c = customPBE.Id;
        qli.PCM_ISBN__c = '123456';
        qli.PCM_UUID__c = 'e4f2d8f7-4a29-43af-91fd-2d40f0e36e3a';
        qli.PCM_Product_Name__c = 'TestProd';
        qli.PCM_Author_Name__c = 'TestAuthor';
        qli.SBQQ__ListPrice__c = 100;
        qli.Line_reference__c = 'Test';
        qli.PCM_DOI__c = 'Test';
        insert qli;
        
        Order ord = new Order();
        ord.OpportunityId = opp.id;
        ord.AccountId = acc.id;
        ord.EffectiveDate = Date.today();
        ord.Status = 'Draft';
        ord.OrderReferenceNumber = 'Test';
        ord.Pricebook2Id = customPB.id;
        insert ord;
        
        OrderItem ordItem = new OrderItem();
        ordItem.orderid = ord.id;
        ordItem.Quantity = 1;
        ordItem.UnitPrice = 50;
        ordItem.SBQQ_NetTotal__c = 100;
        ordItem.SBQQ__TaxAmount__c = 10;
        ordItem.SBQQ__TaxCode__c = 'Test';
        ordItem.PCM_UUID__c = p.Hub_Id__c;
        ordItem.SBQQ__QuotedListPrice__c = 100;
        ordItem.SBQQ__OrderedQuantity__c = 1;
        ordItem.PricebookEntryId = customPBE.id;
        insert ordItem;
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Product_Bundle_Parent__c = p.Id;
        lineitem.Title__c  = p.name;
        lineitem.Authors__c = 'TestAuthor';
        lineitem.doi__c = 'Test';
        lineItem.Product_Doi__c =  'productDoi' + p.id;
        lineItem.Product__c = p.Id;
        lineItem.Source__c = 'PCM';
        lineItem.Type__c = 'Type';
        lineItem.Valid__c = 'true';
        lineitem.uuid__c = p.Hub_Id__c;
        lineItem.mediaType__c = 'Test';
        lineItem.lineItemStatus__c = 'IsInsert';
        lineItem.Publisher__c = 'Publisher';
        lineItem.Open_access__c = true;
        lineItem.Publication_Date__c = Date.today();        
        lineItem.Content_Position__c  = 1;
        lineItem.PriceUSD__c = 100;
        lineItem.PriceGBP__c = 100;
        lineItem.CurrencyIsoCode = 'GBP';
        insert lineItem;
        
        Test.startTest();
        List<String> quoteIdsList = new List<String>();
        quoteIdsList.add(quoteObject.id);
        TF_LMSOrderJson.createLMSOrderJson( quoteIdsList );
        Test.stopTest();
    }
}