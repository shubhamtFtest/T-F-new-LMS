/******************************************************************
* Tests: zTEST_TF_IndiaRePrintCtr             95%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaRePrintCtr {
    
    private static testmethod void testPagedResult(){
        test.startTest();        
        TF_IndiaRePrintCtr.PagedResult pgResultDetail = new  TF_IndiaRePrintCtr.PagedResult();
        pgResultDetail.pageSize = 10;
        pgResultDetail.page = 50;
        pgResultDetail.total = 100;
        test.stopTest();         
    }

    private static testmethod void testFilter(){
        test.startTest();        
        TF_IndiaRePrintCtr.Filter pgResultDetail = new  TF_IndiaRePrintCtr.Filter();
        List<String> vTypes = new List<String>();
        vTypes.add('Paperback');
        pgResultDetail.productName = 'product name';
        pgResultDetail.leadAuthor = 'amit';
        pgResultDetail.publisher = 'publisher';
        pgResultDetail.versionTypes = vTypes;
        pgResultDetail.productFamily = 'productFamily';
        test.stopTest();         
    }

    private static testmethod void testSettingResult(){
        test.startTest();        
        TF_IndiaRePrintCtr.SettingResult pgResultDetail = new  TF_IndiaRePrintCtr.SettingResult();
        pgResultDetail.opportunityId = '01t0Y000009qGjQ';
        pgResultDetail.isOpportunityClosedWon = true;
        pgResultDetail.iSSalesUser = true;
        pgResultDetail.iSCustomerServiceUser = false;
        pgResultDetail.iSProductionUser = false;
        pgResultDetail.iSCreditControlUser = false;
        test.stopTest();         
    }

    private static testmethod void testSettingResult2(){
        test.startTest();        
        TF_IndiaRePrintCtr.SettingResult pgResultDetail = new  TF_IndiaRePrintCtr.SettingResult();
        pgResultDetail.opportunityId = '01t0Y000009qGjQ';
        pgResultDetail.isOpportunityClosedWon = true;
        pgResultDetail.iSSalesUser = false;
        pgResultDetail.iSCustomerServiceUser = false;
        pgResultDetail.iSProductionUser = false;
        pgResultDetail.iSCreditControlUser = false;
        test.stopTest();         
    }    
    
    
    private static testmethod void testOpportunityLineItemDetails(){
        test.startTest();        
        TF_IndiaRePrintCtr.OpportunityLineItemDetails pgResultDetail = new  TF_IndiaRePrintCtr.OpportunityLineItemDetails();
        pgResultDetail.Id = '01t0Y000009qGjQ';
        pgResultDetail.ProductCode = '9781138603837';
        pgResultDetail.Qty = 10;
        pgResultDetail.UMC = 5.3;
        pgResultDetail.MRP = 5.3;
        pgResultDetail.CustomerQuote = 5.3;
        pgResultDetail.GrossMargin = 5.3;
        pgResultDetail.Status = true;
        pgResultDetail.Distributor = 'test';
        test.stopTest();         
    }
    
    private static testmethod void testImportItems(){
        test.startTest();        
        TF_IndiaRePrintCtr.ImportItems pgResultDetail = new  TF_IndiaRePrintCtr.ImportItems();
        pgResultDetail.Id = '01t0Y000009qGjQ';
        pgResultDetail.ProductCode = '9781138603837';
        pgResultDetail.Qty = '10';
        pgResultDetail.UMC = '5.3';
        pgResultDetail.MRP = '5.3';
        pgResultDetail.CustomerQuote = '5.3';
        pgResultDetail.GrossMargin = '5.3';
        pgResultDetail.Status = 'true';        
        pgResultDetail.GlobalISBN = '123';
        pgResultDetail.IndiaISBN = '456';
        pgResultDetail.TitleName = 'TitleName';
        pgResultDetail.ReprintEligibility = 'Pass';
        pgResultDetail.BindingType = 'Hardback';
        pgResultDetail.Size = '9 inch';
        pgResultDetail.Pages = '100';
        pgResultDetail.Inserts = 'true';
        pgResultDetail.TextColor = 'mono';
        pgResultDetail.TextPaper = '60gsm';
        pgResultDetail.Extras = 'Extras';
        test.stopTest();         
    }
        
    static testMethod void test_bulkUpdateOpportunityLineItems() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Product2 prodObject1 = createOriginalProductTestData();
        Product2 prodObject2 = createIndiaReprintProductTestData();

        /* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prodObject1.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prodObject1.Id, UnitPrice = 100.00);                                            
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
        
        String json = '[';
        Integer cnt = oliList.size();
        Integer lastLoop = cnt-1;
        Integer i=0;
        for(OpportunityLineItem oli : oliList){
            json+='{"Id" : \"'+oli.Id+'\","reprintEligibility":true,"SalesComments":"test","CustomerServiceComment":"test", "ProductCode" : \"'+oli.ProductCode+'\","ReprintBind" : "Paperback","IndiaISBN":\"'+prodObject2.productcode+'\", "Qty" : "10", "UMC" : "4.2", "MRP" : "100", "CustomerQuote" : "110", "GrossMargin" : "2", "Status" : "true"}';
            if(i < cnt-1){
              json+=',';  
            }
            i++;
        }
        json+=']'; 
        TF_IndiaRePrintCtr.bulkUpdateOpportunityLineItems(json, opp.Id);       
       // system.debug('bulkUpdateOpportunityLineItems:'+re);
        //System.assert(re != 'ERROR');
        test.stopTest();        
    }
    
    static testMethod void test_getProductName() {
        test.startTest();      
        Product2 prodObject = createOriginalProductTestData();
        TF_IndiaRePrintCtr.getProductName(prodObject.Id);             
        test.stopTest();        
    }    

    static testMethod void test_IsPricingRequested() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.IsPricingRequested(oppObj.Id); 
        System.assert(result != null);
        test.stopTest();        
    }

    static testMethod void test_IsUMCRequested() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.IsUMCRequested(oppObj.Id); 
        System.assert(result != null);
        test.stopTest();        
    }

    static testMethod void test_checkIsPricingEntered() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.checkIsPricingEntered(oppObj.Id);
        System.assert(result != null);
        test.stopTest();        
    }  
 
    static testMethod void test_checkIsMRPRequestSent() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.checkIsMRPRequestSent(oppObj.Id);
        System.assert(result != null);
        test.stopTest();        
    }

    static testMethod void test_checkOpportunityOverallReprintEligibility() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.checkOpportunityOverallReprintEligibility(oppObj.Id);
        //System.assert(result != null);
        test.stopTest();        
    }
    
    static testMethod void test_checkIsApproved() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        String result = TF_IndiaRePrintCtr.checkIsApproved(oppObj.Id); 
        System.assert(result != null);
        test.stopTest();        
    }    
       


    static testMethod void test_getOpportunity() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        Opportunity opp = TF_IndiaRePrintCtr.getOpportunity(oppObj.Id); 
        System.assert(opp != null);
        test.stopTest();        
    }
    
    
    
    static testMethod void testGetPublicGroupName(){
        test.startTest();      
        String ret1 = TF_IndiaRePrintCtr.getPublicGroupName('ReprintEligibility'); 
        System.assert(ret1 == 'IR_Sales Profile Users');
        
        String ret2 = TF_IndiaRePrintCtr.getPublicGroupName('UMC Requested'); 
        System.assert(ret2 == 'IR_Production Profile Users');

        String ret3 = TF_IndiaRePrintCtr.getPublicGroupName('MRP Requested'); 
        System.assert(ret3 == 'IR_CSD Profile Users');

        String ret4 = TF_IndiaRePrintCtr.getPublicGroupName('Pricing Entered'); 
        System.assert(ret4 == 'IR_CSD Profile Users');        
        test.stopTest();         
    }
    
    static testMethod void test_getTotalOLIs() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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
        
        Integer ret = TF_IndiaRePrintCtr.getTotalOLIs(oliList[0].Id); 
        TF_IndiaRePrintCtr.doesProductCodeExistInOpp(prdObj.productcode,opp.Id);
        //System.assert(ret != null);
        test.stopTest();        
    }    
    
    static testMethod void testMethod_getOLIDetails() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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
        OpportunityLineItem oli = TF_IndiaRePrintCtr.getOLIDetails(oliList[0].Id); 
        System.assert(oli != null);
        test.stopTest();        
    }

    static testMethod void testMethod_exportExcelAction() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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

        TF_IndiaRePrintCtr.OpportunityLineItemDetails pgResultDetail = new  TF_IndiaRePrintCtr.OpportunityLineItemDetails();
        TF_IndiaRePrintCtr.exportExcelAction(opp.Id); 
        
        //System.assert(opp != null);
        test.stopTest();        
    }
 
    static testMethod void testMethod_renegotiateUMCAction() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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
        String result = TF_IndiaRePrintCtr.renegotiateUMCAction(oliList, opp.Id, 'UMCRenegotiateReason'); 
        System.assert(result == 'Record has been updated successfully.');
        test.stopTest();        
    }     
    
    static testMethod void testMethod_isOpportunityClosedWon_false() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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
        Boolean result = TF_IndiaRePrintCtr.isOpportunityClosedWon(opp.Id); 
        System.assert(result == false);
        test.stopTest();        
    }     

    static testMethod void testMethod_isOpportunityClosedWon_true() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
        
        //update opportunity
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opplst = [SELECT Id, AccountId FROM Opportunity WHERE Id =:opp.Id];
        for(Opportunity oppLstObj : opplst){
            oppLstObj.StageName = 'Closed Won';
            oppToUpdate.add(oppLstObj);
        }
        update oppToUpdate;               
		/* end pricebook entry */
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        Boolean result = TF_IndiaRePrintCtr.isOpportunityClosedWon(opp.Id); 
        System.assert(result == true);
        test.stopTest();        
    }
    
    static testMethod void testMethod_getAllOpportunityLineItems() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
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
        
        TF_IndiaRePrintCtr.getAllOpportunityLineItems('10', '5', opp.Id,''); 
        //System.assert(result != null);
        test.stopTest();        
    } 

    static testMethod void testMethod_getOliRemarkHelper() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.getOliRemarkHelper(oliList[0].Id); 
        System.assert(result == 'test');
        test.stopTest();        
    } 

    static testMethod void testMethod_saveGrossMarginApproval() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.saveGrossMarginApproval(oliList[0].Id, 'comment'); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }
    
    static testMethod void testMethod_approveOverride() {
        test.startTest();      
       User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.approveOverride(oliList[0].Id, 'Pass', 'comment'); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }

    static testMethod void testMethod_IsPricingRequested() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.approveOverrideRequest(oliList[0].Id, 'Pass', 'comment'); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }
    
    static testMethod void testMethod_finalApproval_true() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test',
                                                          Reprint_Eligibility__c = 'Pass',Indian_Isbn__c = '1234567890123',
                                                          Customer_Quote__c = 20, UMC__c = 5
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.finalApproval(opp.Id, oliList); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }

    static testMethod void testMethod_finalApproval_false() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.finalApproval(opp.Id, oliList); 
        System.assert(result == 'NOT_ALLOW_TO_APPROVE');
        test.stopTest();        
    }


    static testMethod void testMethod_checkLineItemReprintEligibilityStatus() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.checkLineItemReprintEligibilityStatus(opp.Id, oliList); 
        System.assert(result == 'NOT_ALLOW_TO_CHECK_REPRINT_ELIGIBILITY');
        test.stopTest();        
    }

    static testMethod void testMethod_checkLineItemReprintEligibilityStatus_success() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.checkLineItemReprintEligibilityStatus(opp.Id, oliList); 
        System.assert(result == 'SUCCESS');
        test.stopTest();        
    }


    static testMethod void testMethod_checkLineItemStatus_success() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass',
                                                          Status__c = 'UMC Entered'
                                                         );
        oliList.add(oliObj);               
        insert oliList;        
        String result = TF_IndiaRePrintCtr.checkLineItemStatus(opp.Id, oliList); 
        System.assert(result == 'SUCCESS');
        test.stopTest();        
    }

    static testMethod void testMethod_checkLineItemStatus_error() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;        
        String result = TF_IndiaRePrintCtr.checkLineItemStatus(opp.Id, oliList); 
        System.assert(result == 'NOT_ALLOW_TO_REQUEST_MRP');
        test.stopTest();        
    }
    
    static testMethod void testMethod_checkLineItemStatusBeforeApproval_success() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass',
                                                          Status__c = 'Pricing Entered'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.checkLineItemStatusBeforeApproval(opp.Id, oliList); 
        System.assert(result == 'SUCCESS');
        test.stopTest();        
    }

    static testMethod void testMethod_checkLineItemStatusBeforeApproval_error() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass',
                                                          Status__c = 'Pending'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.checkLineItemStatusBeforeApproval(opp.Id, oliList); 
        System.assert(result == 'NOT_ALLOW_TO_REQUEST_APPROVAL');
        test.stopTest();        
    }

    static testMethod void testMethod_updateGMOverride() {      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass',
                                                          Status__c = 'Pending'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        
		Id OrgWideEmailAddressId = [select id from OrgWideEmailAddress where address = 'apc@tandf.co.uk'].id;      
        
        test.startTest();
        String result = TF_IndiaRePrintCtr.updateGMOverride(opp.Id, oliList); 
        System.assert(result == 'Record has been updated successfully');   
        test.stopTest();        
    }
    
    static testMethod void testMethod_updateOppAndOppLineItems() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass',
                                                          Status__c = 'Pending'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        
		Id OrgWideEmailAddressId = [select id from OrgWideEmailAddress where address = 'apc@tandf.co.uk'].id;      
        
        
        String result = TF_IndiaRePrintCtr.updateOppAndOppLineItems(opp.Id, 'UMC Entered', oliList, ''); 
        System.assert(result == 'Record has been updated successfully');
        
        /*
        String result2 = TF_IndiaRePrintCtr.updateOppAndOppLineItems(opp.Id, 'UMC Requested', oliList, ''); 
        System.assert(result2 == 'Record has been updated successfully');

        String result3 = TF_IndiaRePrintCtr.updateOppAndOppLineItems(opp.Id, 'MRP Requested', oliList, ''); 
        System.assert(result3 == 'Record has been updated successfully');

        String result4 = TF_IndiaRePrintCtr.updateOppAndOppLineItems(opp.Id, 'Pricing Requested', oliList, ''); 
        System.assert(result4 == 'Record has been updated successfully');

        String result5 = TF_IndiaRePrintCtr.updateOppAndOppLineItems(opp.Id, 'Pricing Entered', oliList, ''); 
        System.assert(result5 == 'Record has been updated successfully');
		*/        
        test.stopTest();        
    }

    static testMethod void testMethod_oliPricingEntered() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.oliPricingEntered(opp.Id, oliList); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }  
    
    static testMethod void testMethod_inlineUpdateOpportunityLineItem() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        Boolean result = TF_IndiaRePrintCtr.inlineUpdateOpportunityLineItem(oliList); 
        system.debug('inlineUpdateOpportunityLineItem::'+result);
        //System.assert(result != null);
        test.stopTest();        
    }    

    static testMethod void testMethod_deleteOpportunityLineItem() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.deleteOpportunityLineItem(oliList[0].Id); 
        System.assert(result == 'RECORD_DELETED');
        test.stopTest();        
    }

    static testMethod void testMethodOverrideOpportunityLineItem() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prdObj = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Version_Type__c = 'Paperback'
                                          );  
        insert prdObj;
		/* start pricebook entry */
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, Pricebook2Id = standardPricebookId, 
            										  Product2Id = prdObj.Id, UnitPrice = 100.00
                                                    );                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPriceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPriceBook;
        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = customPriceBook.Id, 
                                                     Product2Id = prdObj.Id, UnitPrice = 100.00);                                            
        customPBEList.add(customPBE);                              
        insert customPBEList;
		/* end pricebook entry */
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun',Remarks__c = 'test', Reprint_Eligibility__c='Pass'
                                                         );
        oliList.add(oliObj);               
        insert oliList;
        String result = TF_IndiaRePrintCtr.overrideOpportunityLineItem(oliList[0].Id); 
        System.assert(result == 'RECORD_UPDATED');
        test.stopTest();        
    }


    static testMethod void testMethod_checkUserHasCustomPermissionAccess() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        
        Boolean result = TF_IndiaRePrintCtr.checkUserHasCustomPermissionAccess('India Reprint Customer services'); 
        System.assert(result != null);
        test.stopTest();        
    }
    
    static testMethod void testMethod_getselectOptions() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        TF_IndiaRePrintCtr.getselectOptions(new Account(), 'Type'); 
        test.stopTest();        
    }
    
    static testMethod void testMethod_checkUserPermissionAndOpp() {
        test.startTest();      
		Opportunity oppObj = insertOpportunity();
        TF_IndiaRePrintCtr.checkUserPermissionAndOpp(oppObj.Id); 
        test.stopTest();        
    }

    static testMethod void testMethod_iSSalesUser() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        Boolean result = TF_IndiaRePrintCtr.iSSalesUser();
        //system.debug('iSSalesUser::'+ result);
        //System.assert(result == true);
        test.stopTest();        
    }    

    static testMethod void testMethod_iSCreditControlUser() {
        test.startTest();      
        Opportunity oppObj = insertOpportunity();
        Boolean result = TF_IndiaRePrintCtr.iSCreditControlUser();
        //System.assert(result == true);
        test.stopTest();        
    }

    static testMethod void testMethod_sendEmailNotification() {
        test.startTest(); 
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Opportunity oppObj = insertOpportunity();
        Id OrgWideEmailAddressId = [select id from OrgWideEmailAddress where address = 'apc@tandf.co.uk'].id;
        
        Contact con = new Contact();
        con.FirstName = 'amit';
        con.LastName = 'kumar';
        con.Email = 'amit.kumar@tandfindia.com';
        con.Account = a;
        insert con;    
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'ReprintEligibility');
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'ReprintEligibilityPending');
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'UMC Requested');
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'MRP Requested');
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'Pricing Requested');
        TF_IndiaRePrintCtr.sendEmailNotification(oppObj.Id, 'Pricing Entered');
        test.stopTest();        
    }
    
    /*
    static testMethod void testGetEmailAddresses() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);       
       
        String groupName = 'Test Group1';
        //Create Parent Group
        Group grp = new Group();
        grp.name = groupName;
        grp.Type = 'Regular'; 
        Insert grp; 
 
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
        
        list<String> lst = TF_IndiaRePrintCtr.getEmailAddresses(groupName); 
        System.assert(lst.size() != 0);
        test.stopTest();        
    }
    */
    static testMethod void testGetOppList() {
        test.startTest();      
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);       
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);         
        list<Opportunity> oppList = TF_IndiaRePrintCtr.getOppList(); 
        System.assert(oppList.size() != 0);
        test.stopTest();        
    }  
    
	/* start test data setup */    
    private static Product2 createIndiaReprintProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prodObject = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode = '9781138603837', Popular_Formats__c	= '5.5 X 8.5', Version_Type__c= 'Indian Edition Paperback',
                                           Format_Height_mm__c = 100, Format_Width_mm__c	= 200,
                                           Text_Colour__c	= 'Mono', Paper_Type__c	= 'Hadback',       
                                           UMC__c	= 5, Date_of_Last_UMC__c = startDate,Last_UMC_Popular_Formats__c = '5.5 X 8.5', 
                                           Last_UMC_Format_Height_mm__c = 100, Last_UMC_Format_Width_mm__c = 200,	        
                                           Last_UMC_Version_Type__c = 'Hadback',Last_UMC_Text_Colour__c = 'Mono',
                                           Last_UMC_Paper_Type__c	= '80gsm',Last_UMC_Quantity__c = 5,Last_UMC_Customer_Quote__c	= 500
                                          );  
        insert prodObject;
		return prodObject;       
    }
    
    private static Product2 createOriginalProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = date.newInstance(2020, 02, 20);   
        Product2 prodObject = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode='9780367463151', Popular_Formats__c	= '5.5 X 8.5',Version_Type__c = 'Paperback',
                                           Format_Height_mm__c = 100, Format_Width_mm__c	= 200,
                                           Text_Colour__c	= 'Mono', Paper_Type__c	= 'Hadback',       
                                           UMC__c	= 5, Date_of_Last_UMC__c = startDate,Last_UMC_Popular_Formats__c = '5.5 X 8.5', 
                                           Last_UMC_Format_Height_mm__c = 100, Last_UMC_Format_Width_mm__c = 200,	        
                                           Last_UMC_Version_Type__c = 'Hadback',Last_UMC_Text_Colour__c = 'Mono',
                                           Last_UMC_Paper_Type__c	= '80gsm',Last_UMC_Quantity__c = 5,Last_UMC_Customer_Quote__c	= 500
                                          );  
        insert prodObject;
		return prodObject;       
    }
    
    private static List<PricebookEntry> createPriceBookEntryTestData(Id productId) {         
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> standardPBEList = new List<PricebookEntry>();        
        PricebookEntry standardPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, 
                                                     Pricebook2Id = standardPricebookId, Product2Id = productId, UnitPrice = 100.00);                                  
        standardPBEList.add(standardPBE);                              
        insert standardPBEList;
        
        Pricebook2 customPB = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPB;        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry customPBE = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, 
                                                     Pricebook2Id = customPB.Id, Product2Id = productId, UnitPrice = 100.00);    
        
        customPBEList.add(customPBE);                              
        insert customPBEList;            
        return customPBEList;
    }

    private static List<OpportunityLineItem> createOpportunityLineItemTestData(String oppId, String accId, String pbeOriginal, String pbeReprint) {
        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = oppId, 
            Quantity = 5, 
            Required_Version_Type__c = 'Paperback',
            PricebookEntryId = pbeOriginal, 
            Distributor__c = accId,
            IR_Product_Type__c = 'Original'
        );
        lstOLIInsert.add(oli1); 
        
        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = oppId, 
            Quantity = 9, 
            Required_Version_Type__c = 'Paperback',
            PricebookEntryId = pbeOriginal, 
            Distributor__c = accId,
            IR_Product_Type__c = 'Reprint'
        );
        lstOLIInsert.add(oli2);
        
        insert lstOLIInsert;        
        return lstOLIInsert;
    } 
    
    public static Account insertAccount(String ownerId){
        Id accRecordTypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        User salesUser = zTEST_Shared.insertUser();
        Account a = new Account();
        a.recordtypeid = accRecordTypeId;
        a.Name = 'test';
        a.Sales_Contact_Person__c = salesUser.Id;       
        a.OwnerId = ownerId;       
        return a;
    }
    
    public static Opportunity insertOpportunity() {
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        User u = zTEST_Shared.insertUser();
        Account acc = insertAccount(u.Id);        
        Opportunity opp = new Opportunity(name='Test', recordtypeid = oppRecordtypeId, StageName = 'Prospect',
                                          CloseDate = date.today(), OwnerId = u.Id, Proposal_Type__c = 'Reprint',
                                          Overall_Reprint_Eligibility__c = '',Is_Reprint_Eligibility_Request_Sent__c = false,
                                          Is_Pricing_Request_Sent__c = false, Is_UMC_Request_Sent__c = false,Is_MRP_Request_Sent__c = false,
                                          Is_Pricing_Entered__c = false, Is_Approved__c = false
                                         );
        insert opp;
        return opp;
    }
    
    //T&F India Reprint Customer services
    //T&F India Reprint Production
    //T&F India Reprint Sales
    
	static void createPermissionSetAndAssignUser(String permissionSetName, User u) {
		PermissionSet ps = new PermissionSet();
		ps.Name = permissionSetName;
		ps.Label = permissionSetName;
		ps.PermissionsModifyAllData = true;
		ps.PermissionsAssignTopics = true;
		ps.PermissionsConnectOrgToEnvironmentHub = true;
		ps.PermissionsConvertLeads = true;
		ps.PermissionsCreateCustomizeFilters = true;
		ps.PermissionsCreateTopics = true;
		ps.PermissionsDeleteTopics = true;
		ps.PermissionsEditEvent = true;
		ps.PermissionsEditPublicDocuments = true;
		ps.PermissionsEditPublicFilters = true;
		ps.PermissionsEditPublicTemplates = true;
		ps.PermissionsEditTask = true;
		ps.PermissionsEditTopics = true;
		ps.PermissionsImportLeads = true;
		ps.PermissionsManageCategories = true;
		ps.PermissionsManageNetworks = true;
		ps.PermissionsRunReports = true;
		ps.PermissionsSolutionImport = true;
		ps.PermissionsTransferAnyEntity = true;
		ps.PermissionsTransferAnyLead = true;
		ps.PermissionsUseTeamReassignWizards = true;
		ps.PermissionsViewAllData = true;
		ps.PermissionsViewEventLogFiles = true;
		ps.PermissionsViewSetup = true;
		insert ps;

		PermissionSetAssignment psa = new PermissionSetAssignment();
		psa.AssigneeId = u.Id;
		psa.PermissionSetId = ps.Id;
		insert psa;
	}    
}