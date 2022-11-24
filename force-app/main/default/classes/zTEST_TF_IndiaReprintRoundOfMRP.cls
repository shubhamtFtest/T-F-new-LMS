/******************************************************************
* Tests: TF_IndiaReprintRoundOfMRP             100%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaReprintRoundOfMRP {
    
    static testMethod void testMethod1() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = new Account();
        a.RecordTypeId = accountRecordtypeId;
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Sales_Contact_Person__c = u.Id;
        insert a;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = createOppTestData(a.Id, u.Id, oppRecordtypeId);
        
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
        
        //insert OLI
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',
                                                          Customer_Quote__c = 10
                                                         );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert;
        
        OpportunityLineItem oliobj = new OpportunityLineItem();
        oliobj.Id = lstOLIInsert[0].Id;
        oliobj.UMC__c = 5; 
        oliobj.MRP__c = 930;
        update oliobj;
        
       	OpportunityLineItem getoli = [SELECT Id, MRP__c, UMC__c, Gross_Margin__c FROM OpportunityLineItem WHERE Id=:lstOLIInsert[0].Id LIMIT 1];
        system.debug('GrossMargin1:'+getoli.Gross_Margin__c);
        
       
        List<Id> oliIds = new List<Id>();
        for (OpportunityLineItem ol : lstOLIInsert) {            
        	oliIds.add(ol.Id);           
        }   
        
        test.startTest();
        TF_IndiaReprintRoundOfMRP.roundOfMRP(oliIds);
        test.stopTest();
    }

    static testMethod void testMethod2() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = new Account();
        a.RecordTypeId = accountRecordtypeId;
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Sales_Contact_Person__c = u.Id;
        insert a;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = createOppTestData(a.Id, u.Id, oppRecordtypeId);
        
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
        
        //insert OLI
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',
                                                          Customer_Quote__c = 10
                                                         );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert;
        
        OpportunityLineItem oliobj = new OpportunityLineItem();
        oliobj.Id = lstOLIInsert[0].Id;
        oliobj.UMC__c = 5; 
        oliobj.MRP__c = 1200;
        update oliobj;
        
       	OpportunityLineItem getoli = [SELECT Id, MRP__c, UMC__c, Gross_Margin__c FROM OpportunityLineItem WHERE Id=:lstOLIInsert[0].Id LIMIT 1];
        system.debug('GrossMargin1:'+getoli.Gross_Margin__c);
        
       
        List<Id> oliIds = new List<Id>();
        for (OpportunityLineItem ol : lstOLIInsert) {            
        	oliIds.add(ol.Id);           
        }   
        
        test.startTest();
        TF_IndiaReprintRoundOfMRP.roundOfMRP(oliIds);
        test.stopTest();
    }

    static testMethod void testMethod3() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = new Account();
        a.RecordTypeId = accountRecordtypeId;
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Sales_Contact_Person__c = u.Id;
        insert a;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = createOppTestData(a.Id, u.Id, oppRecordtypeId);
        
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
        
        //insert OLI
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = priceBEList2[0].Id, IR_Product_Type__c = 'Rerun',
                                                          Customer_Quote__c = 10
                                                         );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert;
        
        OpportunityLineItem oliobj = new OpportunityLineItem();
        oliobj.Id = lstOLIInsert[0].Id;
        oliobj.UMC__c = 5; 
        oliobj.MRP__c = 93;
        update oliobj;
        
       	OpportunityLineItem getoli = [SELECT Id, MRP__c, UMC__c, Gross_Margin__c FROM OpportunityLineItem WHERE Id=:lstOLIInsert[0].Id LIMIT 1];
        system.debug('GrossMargin1:'+getoli.Gross_Margin__c);
        
       
        List<Id> oliIds = new List<Id>();
        for (OpportunityLineItem ol : lstOLIInsert) {            
        	oliIds.add(ol.Id);           
        }   
        
        test.startTest();
        TF_IndiaReprintRoundOfMRP.roundOfMRP(oliIds);
        test.stopTest();
    }
    
    
    static testMethod void testMethodRoundOfCustomOptionOne1() {   
        String priceBookName = 'T&F India Pricebook';
        User u = zTEST_Shared.insertUser();
        
        Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        Account a = new Account();
        a.RecordTypeId = accountRecordtypeId;
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Sales_Contact_Person__c = u.Id;
        insert a;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');       
        Product2 prdObj = createProductTestData();
        Opportunity opp = createOppTestData(a.Id, u.Id, oppRecordtypeId);
        
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
        
        //insert OLI
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = priceBEList2[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',
                                                          Customer_Quote__c = 5
                                                         );
        lstOLIInsert.add(oli);               
        insert lstOLIInsert;
        
        OpportunityLineItem oliobj = new OpportunityLineItem();
        oliobj.Id = lstOLIInsert[0].Id;
        oliobj.Customer_Quote__c = 10;
        oliobj.UMC__c = 5; 
        oliobj.MRP__c = 97;
        update oliobj;        
        
       	OpportunityLineItem getoli = [SELECT Id, MRP__c, UMC__c, Gross_Margin__c FROM OpportunityLineItem WHERE Id=:lstOLIInsert[0].Id LIMIT 1];
        system.debug('GrossMargin2:'+getoli.Gross_Margin__c);
        
        List<Id> oliIds = new List<Id>();
        for (OpportunityLineItem ol : lstOLIInsert) {            
        	oliIds.add(ol.Id);           
        }  
        
        Integer mrp1 = 87;
        Integer mrp2 = 1200;
        Integer mrp3 = 678;
        
        test.startTest();
        TF_IndiaReprintRoundOfMRP.RoundOfCustomOptionOne(mrp1, 95);
        TF_IndiaReprintRoundOfMRP.RoundOfCustomOptionOne(mrp2, 95);
        TF_IndiaReprintRoundOfMRP.RoundOfCustomOptionOne(mrp3, 95);
        test.stopTest();
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