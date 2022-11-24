@isTest
private class zTEST_Journals_Multi_Year_Deal_Product {
    static testMethod void testmethodforcoverage1() {
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        TriggerInterfaceHelper.runTrigger('Journals_Multi_Year_Deal_Product_Trig', 'OpportunityLineItem', 99, 'ai,au,ad', oppRecordtypeId, null);
        Test.startTest();
        Account accRec = new Account();
        accRec.Name = 'testAcc';
        accRec.BillingCity = 'Test Billing';
        accRec.BillingStreet = 'Test Billing';
        accRec.BillingPostalCode = '111111';
        accRec.ShippingCity = 'Test Shipping';
        insert accRec;
        
        Contact conRec = new Contact();
        conRec.LastName = 'testCon11';
        conRec.AccountId = accRec.Id;
        conRec.Email = 'test@test.com';
        insert conRec;
        
        //String standardPricebookId =Test.getStandardPricebookId();
        //PricebookEntry pbeRec = new PricebookEntry(CurrencyIsoCode = 'AUD',IsActive = True, Pricebook2Id = standardPricebookId,
        //UnitPrice = 100.00);
        PricebookEntry pbeRec = zTEST_Shared.insertPricebookEntry();
        
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = oppRecordtypeId;
        opp1.Name = 'testOpp77';
        opp1.AccountId = accRec.Id;
        opp1.StageName = 'Prospect';
        opp1.Type = 'New Business';
        opp1.LeadSource = 'Direct';
        opp1.CloseDate = Date.Today();
        opp1.Currency__c = 'USD -U.S. Dollar';
        opp1.Volume_Year__c = '1';
        insert opp1;
        
        Product2 prodRec1  = [select id ,Family,IsActive,Description from Product2 where id =: pbeRec.Product2Id ];
        prodRec1.Family = 'Modern Archive'; 
        prodRec1.IsActive = true;
        prodRec1.Description ='test';
        update prodRec1;
        Product2 prodRec2  = [select id ,Family,IsActive,Description from Product2 where id =: pbeRec.Product2Id ];
        prodRec2.Family = 'Article Pass'; 
        prodRec2.IsActive = true;
        prodRec2.Description ='test';
        update prodRec2;
        
        OpportunityLineItem oliRec1 = new OpportunityLineItem();
        oliRec1.OpportunityId = opp1.Id;
        oliRec1.Product2Id = prodRec1.Id;
        oliRec1.PricebookEntryId = pbeRec.Id;
        insert oliRec1;
        
        OpportunityLineItem oliRec2 = new OpportunityLineItem();
        oliRec2.OpportunityId = opp1.Id;
        oliRec2.Product2Id = prodRec2.Id;
        oliRec2.PricebookEntryId = pbeRec.Id;
        insert oliRec2;
        
        Opportunity opp = [SELECT Id,Multi_year_deal__c FROM Opportunity Where Id=:opp1.Id limit 1];
        System.assertEquals('No',opp.Multi_year_deal__c);
        delete oliRec1;
        
        delete oliRec2;
        Opportunity oppDel = [SELECT Id,Multi_year_deal__c FROM Opportunity Where Id=:opp1.Id limit 1];
        System.assertEquals('No',oppDel.Multi_year_deal__c);   
        Test.stopTest();
    }
}