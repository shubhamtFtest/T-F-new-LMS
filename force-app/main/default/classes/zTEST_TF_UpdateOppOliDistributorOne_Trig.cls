/******************************************************************
* Tests: TF_IRPUpdateOppOLIDistributorOne_Trig             100%
*******************************************************************/

@isTest
private class zTEST_TF_UpdateOppOliDistributorOne_Trig {
    
    static testMethod void testMetho1() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        User newusr = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        //create test account
        Account testacc = new Account();
        testacc.RecordTypeId = accountRecordtypeId;
        testacc.Name = 'test';
        testacc.OwnerId = u.Id;
        testacc.Sales_Contact_Person__c = u.Id;
        insert testacc;
        
        //create demo account
		Account demoacc = new Account();               
        demoacc.RecordTypeId = accountRecordtypeId;
        demoacc.Name = 'demo';
        demoacc.OwnerId = u.Id;
        demoacc.Sales_Contact_Person__c = newusr.Id;
        insert demoacc;
        
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();

        //create an opportunity
        Opportunity opp = new Opportunity();
        Date startDate = date.newInstance(2020, 02, 20);
        Date closeDate = Date.today().addDays(30);
        opp.name = 'test';
        opp.Proposal_Type__c = 'Reprint';
        opp.AccountId = testacc.Id;
        opp.RecordTypeId = oppRecordtypeId;
        opp.StageName = 'Prospect';
        opp.CloseDate = closeDate;
        opp.OwnerId = u.Id;
        insert opp;
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
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                              PricebookEntryId = priceBEList2[0].Id, 
                                                              IR_Product_Type__c = 'Rerun',
                                                              Distributor__c = testacc.Id
                                                             );
            lstOLIInsert.add(oli);               
            insert lstOLIInsert; 
                TriggerInterfaceHelper.runTrigger('TF_IRPUpdateOppOLIDistributorOne_Trig', 'Opportunity', 1, 'ai,au', oppRecordtypeId, null);

        //update opportunity
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opplst = [SELECT Id, AccountId FROM Opportunity WHERE Id =:opp.Id];
        system.debug('#'+opplst);
        for(Opportunity oppLstObj : opplst){
            oppLstObj.AccountId = demoacc.Id;
            oppToUpdate.add(oppLstObj);
        }
        update oppToUpdate;
        
        
     
        
        try {
                
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