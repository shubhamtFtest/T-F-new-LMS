/**
*  Tests: CAS_Lead_ProductLookup 100%
**/
@isTest
private class zTEST_CAS_Lead_ProductLookup {
    static testMethod void test_CAS_Lead_ProductLookup() {
    
    Id rtId = '0120Y000000Wn6XQAS'; //T&F - Leads
    //zTEST_Shared.runTriggersForRecordtypes.put('CAS_Lead_ProductLookup', new Set<Id>{'01260000000DXrVAAW'});
    TriggerInterfaceHelper.runTrigger('CAS_Lead_ProductLookup_Trig', 'Lead', 99, 'bi,bu', rtId, null);
    
    Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
    Product2 p = zTEST_Shared.noinsertProduct2(productRtId);
    p.ProductCode = '12345678901234';
    insert p;
    
    //Insert Standard GBP & USD Price
    PricebookEntry pbeStdGBP = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, CurrencyIsoCode = 'GBP', UnitPrice=1.60, IsActive=true, UseStandardPrice=false);
    insert pbeStdGBP;
    PricebookEntry pbeStdUSD = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=p.id, CurrencyIsoCode = 'USD', UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
    insert pbeStdUSD;
    
    //Insert Custom GBP & USD Price
    Pricebook2 pb = new Pricebook2();
    pb.Name = 'test';
    insert pb;
    Id pricebook2Id = pb.Id;
        
    PricebookEntry pbeGBP = new PricebookEntry(Pricebook2Id=pricebook2Id, Product2Id=p.id, CurrencyIsoCode = 'GBP', UnitPrice=1.60, IsActive=true, UseStandardPrice=false);
    insert pbeGBP;
    PricebookEntry pbeUSD = new PricebookEntry(Pricebook2Id=pricebook2Id, Product2Id=p.id, CurrencyIsoCode = 'USD', UnitPrice=1.00, IsActive=true, UseStandardPrice=false);
    insert pbeUSD;
    
    User u = zTEST_Shared.insertUser();
        
    Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        
    Lead l = zTEST_Shared.insertLead(u.Id, leadRtId);
    l.ISBN__c = '123-4-5678-90123-4';
    update l;
    
    l = [SELECT Product_Name__c, Price_GBP__c, Price_USD__c FROM Lead WHERE Id = :l.Id]; 
    }
}