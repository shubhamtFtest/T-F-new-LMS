/******************************************************************
* Tests: TF_IRPUpdateOppOwner_Trig             95%
*******************************************************************/

@isTest
private class zTEST_TF_IRPUpdateOppOwner_Trig {
    
    static testMethod void testMetho1() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        User newUsr = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account act = new Account();
        act.RecordTypeId = accountRecordtypeId;
        act.Name = 'test';
        act.OwnerId = u.Id;
        act.Sales_Contact_Person__c = u.Id;
        insert act;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = createOppTestData(act.Id, u.Id, oppRecordtypeId);
        
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
        
        TriggerInterfaceHelper.runTrigger('TF_IRPUpdateOppOwner_Trig', 'Account', 99, 'au', accountRecordtypeId, null);
        
        try {
            List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                												PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun'
                                                             );
            lstOLIInsert.add(oli);               
            insert lstOLIInsert; 
            
            //update account sales contact person
            list<Account> accs = new list<Account>([SELECT Id, Sales_Contact_Person__c FROM Account WHERE Id =:act.Id]);
            List<Account> accToUpdate = new List<Account>();
            for(Account ac: accs){
                Account accObj = new Account();
                accObj.Id = ac.Id;
                accObj.Sales_Contact_Person__c = newUsr.Id;
                accToUpdate.add(accObj);
            } 
            update accToUpdate;
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
    
    private static Opportunity createOppTestData(Id accId, Id userId, Id oppRecordtypeId) {               
        Opportunity opp = new Opportunity();
        Date startDate = date.newInstance(2020, 02, 20);
        Date closeDate = Date.today().addDays(30);
        opp.name = 'test';
        opp.Proposal_Type__c = 'Reprint';
        opp.AccountId = accId;
        opp.RecordTypeId = oppRecordtypeId;
        opp.StageName = 'Prospect';
        opp.CloseDate = closeDate;
        opp.OwnerId = userId;
        insert opp;
        return opp;
    }    
}