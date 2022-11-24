@isTest
public class ZTEST_TF_IndiaReprintOne_Trig {
        private static IndiaReprintSettings__c settingsInstance;

    static testMethod void testMetho1() {   
        settingsInstance = new IndiaReprintSettings__c();
        settingsInstance.MRP_Conversion_Rate__c=95;
        settingsInstance.Customer_Quote_Conversion_Rate__c=95;
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);

        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook2.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
       TriggerInterfaceHelper.runTrigger('TF_IndiaReprintOne_Trig', 'OpportunityLineItem', 99, 'ai,au', oppRecordtypeId, null);

        try {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                              PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',umc__c=1
                                                             );
            
            insert oli;
            //Update opportunity
            oli.umc__c = 2.1;
            oli.IR_Product_Type__c='New';
            Update oli; 
            
            //Update opportunity
            //oli.mrp__c = 4;
            //Update oli;            
        }
        catch(exception e) {
        }



    }
    static testMethod void testMetho2() {   
        settingsInstance = new IndiaReprintSettings__c();
        settingsInstance.MRP_Conversion_Rate__c=95;
        settingsInstance.Customer_Quote_Conversion_Rate__c=95;
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);

        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook2.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
       TriggerInterfaceHelper.runTrigger('TF_IndiaReprintOne_Trig', 'OpportunityLineItem', 99, 'ai,au', oppRecordtypeId, null);

        try {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                              PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',mrp__c=1
                                                             );
            
            insert oli;
            //Update opportunity
            oli.mrp__c = 2.1;
            Update oli; 
            
            //Update opportunity
            //oli.mrp__c = 4;
            //Update oli;            
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
        product.ProductCode='9780367463151';       
        insert product;
        return product;
    }     
}