/******************************************************************
* Tests: zTEST_TF_IRPUpdateProductInfoToOli_Trig             100%
*******************************************************************/

@isTest
private class zTEST_TF_IRPUpdateProductInfoToOli_Trig {
    
    static testMethod void testMetho1() {   
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
        
        
        TriggerInterfaceHelper.runTrigger('TF_IRPUpdateProductInfoToOli_Trig', 'OpportunityLineItem', 99, 'ai', oppRecordtypeId, null);
        
        try {
            List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                												PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun'
                                                             );
            lstOLIInsert.add(oli);               
            insert lstOLIInsert; 
            
            //update
            List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
            List<OpportunityLineItem> olilst = [SELECT Id, Status__c, Type__c FROM OpportunityLineItem WHERE Id =:lstOLIInsert[0].Id];
            for(OpportunityLineItem oliObj : olilst){
                oliObj.Quantity = 12;
                oliObj.Extent__c = 500;
                oliObj.Text_Colour__c = 'Mono';
                oliObj.UMC__c = 4.5;
                oliObj.MRP__c = 1200;
                oliObj.Customer_Quote__c = 12000;
                oliObj.Version_Type__c = 'Hardback';
                listOliToUpdate.add(oliObj);
            }
            update listOliToUpdate;    
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage());
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