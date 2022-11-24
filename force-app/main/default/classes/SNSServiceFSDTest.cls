@IsTest
public class SNSServiceFSDTest { 
    @testSetup 
    private static void createdata() 
    { 
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        
        Product2 pro = new Product2();
        pro.Name = 'Test';
        insert pro;
        
        PricebookEntry priceBookEntry = new PricebookEntry();
        priceBookEntry.UnitPrice = 1;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = pro.id;
        insert priceBookEntry;
               
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Accepted', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId);
        insert quote;
        
        SBQQ__QuoteLine__c oli = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.id,
            SBQQ__Product__c = pro.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 100);
        insert oli;
        
        SBQQ__Quote__c quote1 = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Draft', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId,
            Is_Create_Quote__c = false);
        insert quote1;
        
        SBQQ__QuoteLine__c oli1 = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote1.id,
            SBQQ__Product__c = pro.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 200);
        insert oli1;
    }

    private static testMethod void testMethodOne()
    {
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        TriggerInterfaceHelper.runTrigger('SNSServiceQuote_Trigger', 'SBQQ__Quote__c', 1, 'au', recId, null); 
        
        Test.startTest();
        SBQQ__Quote__c quote = [select id, Is_Create_Quote__c 
                                from SBQQ__Quote__c 
                                where SBQQ__Status__c = 'Accepted' 
                                limit 1];
        system.assert(quote != null);
        update quote;
        Test.stopTest(); 
    }
    
    private static testMethod void testMethodTwo()
    {
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        TriggerInterfaceHelper.runTrigger('SNSServiceQuote_Trigger', 'SBQQ__Quote__c', 1, 'au', recId, null); 
        
        Test.startTest();
        SBQQ__Quote__c quote = [select id, Is_Create_Quote__c 
                                from SBQQ__Quote__c 
                                where SBQQ__Status__c = 'Draft' 
                                limit 1];
        system.assert(quote != null);
        update quote;
        system.assertEquals(false, quote.Is_Create_Quote__c);
        Test.stopTest();        
    }
    
    private static testMethod void testMethodThree()
    {
        Id recId = MiscFunctions.getRecordtypeId('SBQQ__Quote__c', 'T&F - CPQ Quote');
        Product2 pro = [Select id 
                        from Product2 
                        limit 1];
        
        Test.startTest();
        SBQQ__Quote__c quote2 = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(), 
            SBQQ__StartDate__c = system.today(),
            SBQQ__Status__c = 'Draft', 
            SBQQ__Primary__c=true,
            SBQQ__ExpirationDate__c = date.today()+20,
            recordTypeId = recId);
        insert quote2;
        
        SBQQ__QuoteLine__c oli2 = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote2.id,
            SBQQ__Product__c = pro.id,
            SBQQ__PricebookEntryId__c = Test.getStandardPricebookId(),
            CurrencyIsoCode = 'USD',
            SBQQ__Quantity__c = 1,
            SBQQ__ListPrice__c = 300);
        insert oli2;
        
        TriggerInterface_SBQQ_QuoteLine.trig  triggerObj = new TriggerInterface_SBQQ_QuoteLine.trig();
        triggerObj.isAfter = true;
        triggerObj.isInsert = true;
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        quoteLineList.add(oli2);
        system.assert(quoteLineList != null);
        triggerObj.newList = quoteLineList;
        
        SNSServiceQuoteline_trigger  controller = new SNSServiceQuoteline_trigger ();
        controller.run(triggerObj);
        
        system.assertEquals(false, oli2.SBQQ__Quote__r.Is_Create_Quote__c);
        Test.stopTest();        
    }
}