@isTest
public class ztest_TF_OrignalProductUpdate_Trig {
    static testMethod void testMetho1() { 
        String priceBookName = 'T&F Pricebook';
        String standardPricebookId = Test.getStandardPricebookId();
        
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'GBP', IsActive = True, Pricebook2Id = standardPricebookId, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'GBP',IsActive = True, Pricebook2Id = priceBook2.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
        TriggerInterfaceHelper.runTrigger('TF_OrignalProductUpdate_Trig', 'OpportunityLineItem', 99, 'bi', oppRecordtypeId, null);
        
        try{
            OpportunityLineItem oli = new OpportunityLineItem(Global_ISBN__c='9780710301741',OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                              PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',umc__c=1
                                                             );
            insert oli;
        }  
        catch(exception e) {
        }
        
        
    }
    private static Product2 createProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 product = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        product.name='test';
        product.IsActive=true;
        product.Description='test';
        product.RecordTypeId=productRecordtypeId;
        product.ProductCode='9780710301741';       
        insert product;
        return product;
    }     
}