/******************************************************************
* Tests: TF_IRPCreateOLIHistory             95%
*******************************************************************/

@isTest
private class zTEST_TF_IRPCreateOLIHistory {
    static testMethod void test_sendCreateOLIHistoryNotification() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id accountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Account', RecordTypeId = accountsRecordTypeId, 
                                        Type = 'Customer', OwnerId = u.Id, Sales_Contact_Person__c = u.Id); 
        insert accObject;  
        
        //Create a product                 
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', RecordTypeId = TFProductsRecordTypeId, Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA', Open_Access_Category__c = 'Open', ProductCode = '9780367001209',
                                           IsActive = true, Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        /* start PricebookEntry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = standardPricebookId, 
                                                     Product2Id = prodObject.Id,UnitPrice = 100.00);                                  
        priceBEList.add(standardPBE);                              
        insert priceBEList;

        Pricebook2 createCustomPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert createCustomPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR', Pricebook2Id = createCustomPriceBook.Id, Product2Id = prodObject.Id, UnitPrice = 100.00, IsActive = True);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
        /* end PricebookEntry */         

        // Create an opportunity
        Id TFOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - India Reprint').getRecordTypeId();
        Opportunity newOpp = new Opportunity(Name = 'Test Opportunity Name', Proposal_Type__c = 'Reprint', CurrencyIsoCode = 'INR',
                                             StageName = 'Prospect', CloseDate = system.today(), AccountId = a.Id,
                                             RecordTypeId = TFOpportunityRecordTypeId
                                            );                
        
        insert newOpp; 
        
        //Create contact     
        Contact conObject = new Contact(AccountId = a.Id, FirstName = 'test', LastName = 'test');      
        insert conObject;
        
        //Add contact role to opportunity 
        OpportunityContactRole newContactRoleList = new OpportunityContactRole(ContactId = conObject.Id, OpportunityId = newOpp.Id, Role = 'Decision Maker', IsPrimary = true);
        insert newContactRoleList;     

        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = newOpp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                             PricebookEntryId = customPBEList[0].Id, IR_Product_Type__c = 'Rerun'
                                                            );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert;
        
        //update OLI
        List<OpportunityLineItem> listOliToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> olilst = [SELECT Id, Status__c, Type__c, UMC__c FROM OpportunityLineItem WHERE Id =:lstOLIInsert[0].Id];
        for(OpportunityLineItem oliObj : olilst){
            oliObj.UMC__c = 4.5;
            listOliToUpdate.add(oliObj);
        }
        update listOliToUpdate;
        
		List<Id> oliIds = new List<Id>();
        for(OpportunityLineItem oliObj: lstOLIInsert){
            oliIds.add(oliObj.Id);
        }
        
        test.startTest();
        TF_IRPCreateOLIHistory.sendCreateOLIHistoryNotification(oliIds);       
        test.stopTest();
    }    
}