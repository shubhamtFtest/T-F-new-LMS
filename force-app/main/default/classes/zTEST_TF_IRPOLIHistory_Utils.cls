/******************************************************************
* Tests: zTEST_TF_IRPOLIHistory_Utils             95%
*******************************************************************/

@isTest
private class zTEST_TF_IRPOLIHistory_Utils {
    
    static testMethod void test_createOLIHistoryRecord() {   
        
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
                                             StageName = 'Prospect', CloseDate = System.today(), AccountId = a.Id,
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
        
        test.startTest();
        
        OLIHistory__c historyObj = createOLIHistoryTestData(newOpp.Id, lstOLIInsert[0].Id);
        Set<Id> sStrings = new Set<Id>();
        sStrings.add(lstOLIInsert[0].Id);
        TF_IRPOLIHistory_Utils.createOLIHistoryRecord(lstOLIInsert[0].Id);
        TF_IRPOLIHistory_Utils.createOLIHistory(sStrings);
        
        test.stopTest();
    }
    
    static testMethod void test_deleteOLIHistoryRecords() {   
        
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
                                             StageName = 'Prospect', CloseDate =System.today(), AccountId = a.Id,
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
        
        test.startTest();
        
        OLIHistory__c historyObj = createOLIHistoryTestData(newOpp.Id, lstOLIInsert[0].Id);
        TF_IRPOLIHistory_Utils.deleteOLIHistoryRecords(lstOLIInsert);
        
        test.stopTest();
    }
    
    private static OLIHistory__c createOLIHistoryTestData(String oppId, String oliId){
        OLIHistory__c OLIHistoryObj = new OLIHistory__c();
        Date startDate = System.today();        
        OLIHistoryObj.Is_Approved_UMC__c = true;
        OLIHistoryObj.OpportunityId__c = oppId;
        OLIHistoryObj.OpportunityLineItemId__c = oliId;
        OLIHistoryObj.UMC__c = 4.2;
        OLIHistoryObj.MRP__c = 100;
        OLIHistoryObj.Customer_Quote__c = 100;
        OLIHistoryObj.Gross_Margin__c = 2;
        OLIHistoryObj.Text_Color__c = 'Mono';
        OLIHistoryObj.Paper_size__c = 564;
        OLIHistoryObj.Paper_GSM__c = '80gsm';
        OLIHistoryObj.Date_of_Last_UMC__c = startDate;
        OLIHistoryObj.Version_Type__c = 'Paperback';
        OLIHistoryObj.Quantity__c = 5;
        OLIHistoryObj.Popular_Formats__c = '5.5 X 8.5';
        OLIHistoryObj.Format_Height_mm__c = 100;
        OLIHistoryObj.Format_Width_mm__c =200;       
        insert OLIHistoryObj;
        return OLIHistoryObj;        
    }
    
    private static List<PricebookEntry> createProductPriceBookEntryTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = System.today();
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
            //Distributor__c = oppObj.AccountId,
            IR_Product_Type__c = 'Reprint'
        );
        lstOLIInsert.add(oliNew);               
        insert lstOLIInsert;        
        return lstOLIInsert;
    }    
}