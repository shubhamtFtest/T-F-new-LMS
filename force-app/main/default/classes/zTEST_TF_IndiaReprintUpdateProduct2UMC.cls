/******************************************************************
* Tests: zTEST_TF_IndiaReprintUpdateProduct2UMC             100%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaReprintUpdateProduct2UMC {
    static testMethod void test_updateProductUMC() {   
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntryWithCurrency('INR');
        
        List<PricebookEntry> pbeNew = createProductPriceBookEntryTestData();
        List<OpportunityLineItem> oliObj = createTestData(opp.Id, pbeNew[0].Id);
               
        List<OpportunityLineItem> oliLst = [SELECT Id From OpportunityLineItem Where opportunityId =:opp.Id];
        List<Id> lstId = new List<id>();
        for(OpportunityLineItem oli : oliLst) {
            lstId.add(oli.Id);
        }
        TF_IndiaReprintUpdateProduct2UMC.updateProductUMC(lstId);       
        test.stopTest();
    }
    
    private static List<PricebookEntry> createProductPriceBookEntryTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);
        String priceBookName = 'T&F India Pricebook';   
        Product2 prodObject = new Product2(Name = 'Test', 
                                           RecordTypeId = productRecordtypeId,
                                           Description='test',
                                           ProductCode='9780367463151',
                                           Popular_Formats__c	= '5.5 X 8.5',
                                           Format_Height_mm__c = 100,
                                           Format_Width_mm__c	= 200,
                                           Text_Colour__c	= 'Mono',
                                           Paper_Type__c	= 'Hadback',       
                                           UMC__c	= 5,
                                           Date_of_Last_UMC__c = startDate,	        
                                           Last_UMC_Popular_Formats__c = '5.5 X 8.5',	        
                                           Last_UMC_Format_Height_mm__c = 100,   
                                           Last_UMC_Format_Width_mm__c = 200,	        
                                           Last_UMC_Version_Type__c = 'Hadback',	
                                           Last_UMC_Text_Colour__c = 'Mono',
                                           Last_UMC_Paper_Type__c	= '80gsm',
                                           Last_UMC_Quantity__c = 5,
                                           Last_UMC_Customer_Quote__c	= 500
                                          );  
        insert prodObject;                 
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();        
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id, UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id, UnitPrice = 100.00);    
        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;
            
        return priceBEList2;
    }

    private static List<OpportunityLineItem> createTestData(String oppId, String priceBE2) {
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oliNew = new OpportunityLineItem(
            OpportunityId = oppId, 
            Quantity = 5, 
            Required_Version_Type__c = 'Paperback',
            PricebookEntryId = priceBE2, 
            IR_Product_Type__c = 'Rerun'
        );
        lstOLIInsert.add(oliNew);               
        insert lstOLIInsert;        
        return lstOLIInsert;
    }    
}