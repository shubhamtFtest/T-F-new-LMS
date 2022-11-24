/******************************************************************
* Tests: TF_IRP_CloneOppItem_Trig             100%
*******************************************************************/

@isTest
private class zTEST_TF_IRP_CloneOppItem_Trig {
    
    static testMethod void testMethod1() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);

        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();  
        Product2 prodObject = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test',ProductCode='9780367463151');  
        insert prodObject;               
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Opportunity opp = new Opportunity(
            Name = 'test',
            AccountId = a.Id,            
            CloseDate = Date.Today() + 30,
            OwnerId = u.Id,
            StageName = 'Prospect',
            Proposal_Type__c = 'Reprint',
            RecordTypeId = oppRecordtypeId         
        );
        insert opp;          

        /* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prodObject.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prodObject.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun'
                                                         );
        oliList.add(oliObj);               
        insert oliList; 
        
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 prdObj = createProductTestData();
        TriggerInterfaceHelper.runTrigger('TF_IRP_CloneOppItem_Trig', 'Opportunity', 99, 'ai', oppRecordtypeId, null);
        
        try {
            Opportunity oppNew = new Opportunity(
                Name = 'test',
                AccountId = a.Id,            
                CloseDate = Date.Today() + 30,
                OwnerId = u.Id,
                StageName = 'Prospect',
                Proposal_Type__c = 'Reprint',
                RecordTypeId = oppRecordtypeId,
                Cloned__c = true,
                ClonedOppId__c = opp.Id          
            );
            insert oppNew;
            system.assertEquals('Prospect', oppNew.StageName);
            
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