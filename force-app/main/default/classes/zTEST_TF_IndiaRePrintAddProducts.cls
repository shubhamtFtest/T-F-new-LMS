/******************************************************************
* Tests: zTEST_TF_IndiaRePrintAddProducts             95%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaRePrintAddProducts {
    
    private static testmethod void testProductDetails(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.ProductDetails pgResultDetail = new  TF_IndiaRePrintAddProducts.ProductDetails();
        pgResultDetail.productId = '01t0Y000009qGjQ';
        pgResultDetail.productCode = '9781138603837';
        pgResultDetail.versionType = 'Paperback';
        pgResultDetail.DACKey = 'C2018-0-79204-9';
        test.stopTest();         
    }

    private static testmethod void testProductSearchResult(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.ProductSearchResult pgResultDetail = new  TF_IndiaRePrintAddProducts.ProductSearchResult();
        pgResultDetail.productId = '01t0Y000009qGjQ';
        pgResultDetail.productCode = '9781138603837';
        pgResultDetail.versionType = 'Paperback';
        pgResultDetail.DACKey = 'C2018-0-79204-9';
        pgResultDetail.unitPrice = 100;
        pgResultDetail.currencyIsoCode = 'INR';
        test.stopTest();         
    }

    private static testmethod void testSearchResult(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.SearchResult pgResultDetail = new  TF_IndiaRePrintAddProducts.SearchResult();
        pgResultDetail.pbId = '01t0Y000009qGjQ';
        pgResultDetail.productId = '01t0Y000009qGjQ';
        pgResultDetail.productName = 'product name';
        pgResultDetail.productCode = '9781138603837';
        pgResultDetail.versionType = 'Paperback';
        pgResultDetail.unitPrice = 100;
        pgResultDetail.currencyIsoCode = 'INR';
        test.stopTest();         
    }

    private static testmethod void testPagedResult(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.PagedResult pgResultDetail = new  TF_IndiaRePrintAddProducts.PagedResult();
        pgResultDetail.pageSize = 10;
        pgResultDetail.page = 1;
        pgResultDetail.total = 100;
        test.stopTest();         
    }

    private static testmethod void testItems(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.Items pgResultDetail = new  TF_IndiaRePrintAddProducts.Items();
        pgResultDetail.Binding = 'Paperback';
        pgResultDetail.ISBN = '9781138603837';
        pgResultDetail.Quantity = '10';
        pgResultDetail.Id = '01t0Y000009qGjQ';
        pgResultDetail.IndianISBN = '123';
        test.stopTest();         
    }

    private static testmethod void testListItems(){
        test.startTest();        
        TF_IndiaRePrintAddProducts.ListItems listItemObj = new  TF_IndiaRePrintAddProducts.ListItems();
        listItemObj.WorkNumber = 'sdsd';
        listItemObj.Binding = 'Paperback';
        listItemObj.requiredBinding = 'Hadback';
        listItemObj.ISBN = '9781138603837';
        listItemObj.Quantity = '10';
        listItemObj.Id = '01t0Y000009qGjQ';
        //listItemObj.IndianISBN = '123';
        listItemObj.isRerun = 'true';
        test.stopTest();         
    }
    
    static testMethod void test_isProductExistInTandFIndiaPricebook_true() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Product2 prodObject = createProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id);              
        Boolean re = TF_IndiaRePrintAddProducts.isProductExistInTandFIndiaPricebook(prodObject.Id);       
        System.assert(re == true);
        test.stopTest();        
    }
    
    static testMethod void test_checkAndCreateStandardPriceBookEntryRECORD_EXIST() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Product2 prodObject = createProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id);              
        String re = TF_IndiaRePrintAddProducts.checkAndCreateStandardPriceBookEntry(prodObject.Id);       
        System.assert(re == 'RECORD_EXIST');
        test.stopTest();        
    }
    
    static testMethod void test_checkAndCreateStandardPriceBookEntryRECORD_CREATED() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Product2 prodObject = createProductTestData();             
        String re = TF_IndiaRePrintAddProducts.checkAndCreateStandardPriceBookEntry(prodObject.Id);       
        System.assert(re == 'RECORD_CREATED');
        test.stopTest();        
    }
 
    static testMethod void test_checkAndCreateCustomPriceBookEntryRECORD_EXIST() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Product2 prodObject = createProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id);              
        String re = TF_IndiaRePrintAddProducts.checkAndCreateCustomPriceBookEntry(prodObject.Id);       
        System.assert(re == 'RECORD_EXIST');
        test.stopTest();        
    }
    
    static testMethod void test_checkAndCreateCustomPriceBookEntryRECORD_CREATED() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Product2 prodObject = createProductTestData();             
        String re = TF_IndiaRePrintAddProducts.checkAndCreateCustomPriceBookEntry(prodObject.Id);       
        System.assert(re == 'RECORD_CREATED');
        test.stopTest();        
    }

    static testMethod void test_createOpportunityLineItem() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.accountid= a.Id;
        opp.CurrencyIsoCode='INR';
        insert opp;        
        Product2 prodObject = createProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id);		
        String re = TF_IndiaRePrintAddProducts.createOpportunityLineItem(prodObject.Id, opp.Id, 'INR', '5', 'Paperback', '123', '234');       
        TF_IndiaRePrintAddProducts.doesProductExistInActiveOpp(prodObject.Id, opp.Id, 'INR', '5', 'Paperback', '123', '234');       

        System.assert(re == 'Record inserted successfully');       
        test.stopTest();        
    } 
 
    /*
    static testMethod void test_createOpportunityLineItem_OriginalTitle() {
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);        
        Product2 prdObj = createProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id);
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
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();         
        OpportunityLineItem oliObj = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, Required_Version_Type__c = 'Paperback',
                                                          PricebookEntryId = customPBEList[0].Id, 
                                                          IR_Product_Type__c = 'Rerun'
                                                         );
        oliList.add(oliObj);               
        insert oliList;        
        
        String re = TF_IndiaRePrintAddProducts.createOpportunityLineItem(prdObj.Id, opp.Id, 'INR', '5', 'Paperback', '123', '234');       
        System.assert(re == 'Record inserted successfully');       
        test.stopTest();        
    } 
    */
    static testMethod void test_getProduct_success() {
        test.startTest();  
        TF_IndiaRePrintAddProducts.ProductDetails pgResult = new  TF_IndiaRePrintAddProducts.ProductDetails();
        Product2 prodObject = createProductTestData();
        String name;
        String isbn = prodObject.ProductCode;
        TF_IndiaRePrintAddProducts.getProduct(name, isbn);             
        test.stopTest();        
    }  

    static testMethod void test_getProductRearch_success() {
        test.startTest();  
        TF_IndiaRePrintAddProducts.ProductSearchResult pgResult = new  TF_IndiaRePrintAddProducts.ProductSearchResult();
        Product2 prodObject = createProductTestData();
        String name;
        String isbn = prodObject.ProductCode;
        //TF_IndiaRePrintAddProducts.getProductRearch(name, isbn);             
        test.stopTest();        
    } 
 
    static testMethod void test_getListOfPriceBookEntry() {
        test.startTest();    
        Product2 prodObject = createProductTestData();
        String name;
        String isbn = prodObject.ProductCode;
        //TF_IndiaRePrintAddProducts.getListOfPriceBookEntry('', name, isbn);             
        test.stopTest();        
    } 

    static testMethod void test_getListOfPriceBookEntryNew() {
        test.startTest(); 
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);        
        Product2 prodObject = createProductTestData();
        String name;
        String isbn = prodObject.ProductCode;
        TF_IndiaRePrintAddProducts.getListOfPriceBookEntryNew(opp.Id, name, isbn);             
        test.stopTest();        
    }
 
    static testMethod void test_getListOfPriceBookEntryNew2() {
        test.startTest(); 
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);        
        Product2 prodObject = createProductTestData();
        Product2 prodObject2 = createIndiaReprintProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id); 
        String name;
        String isbn = prodObject.ProductCode;
        TF_IndiaRePrintAddProducts.getListOfPriceBookEntryNew(opp.Id, name, isbn);             
        test.stopTest();        
    }    

    static testMethod void test_importOpportunityLineItems() {
        test.startTest(); 
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);        
        Product2 prodObject = createProductTestData();
        Product2 prodObject2 = createIndiaReprintProductTestData();
        List<PricebookEntry> pbe = createPriceBookEntryTestData(prodObject.Id); 
        String name;
        String isbn = prodObject.ProductCode;
        String json = '[{"ISBN":"9781138603837","Quantity":"9","Binding":"Hardback"}]';
        TF_IndiaRePrintAddProducts.importOpportunityLineItems(json, opp.Id);
        TF_IndiaRePrintAddProducts.checkexistingProposal(json, opp.Id);
        TF_IndiaRePrintAddProducts.checkCurrentProposalDuplicate(json, opp.Id);

        
        test.stopTest();        
    }
    
    private static Product2 createIndiaReprintProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = System.today();   
        Product2 prodObject = new Product2(Name = 'Test', RecordTypeId = productRecordtypeId, Description='test', DAC_Key__c = 'C2016-0-25406-X',
                                           ProductCode = '9781138603837', Popular_Formats__c	= '5.5 X 8.5', Version_Type__c= 'Indian Edition Paperback',
                                           Format_Height_mm__c = 100, Format_Width_mm__c	= 200,
                                           Text_Colour__c	= 'Mono', Paper_Type__c	= 'Hadback',       
                                           UMC__c	= 5, Date_of_Last_UMC__c = startDate,Last_UMC_Popular_Formats__c = '5.5 X 8.5', 
                                           Last_UMC_Format_Height_mm__c = 100, Last_UMC_Format_Width_mm__c = 200,	        
                                           Last_UMC_Version_Type__c = 'Hadback',Last_UMC_Text_Colour__c = 'Mono',
                                           Last_UMC_Paper_Type__c	= '80gsm',Last_UMC_Quantity__c = 5,Last_UMC_Customer_Quote__c	= 500,isActive=true
                                          );  
        insert prodObject;
        Pricebook2 pb = new pricebook2(name='T&F India Pricebook',isactive=true);
        insert pb;
        Id Ids = Test.getStandardPricebookId();
        PricebookEntry pbest = new PricebookEntry(
                Pricebook2Id = Ids,
                Product2Id = prodObject.Id,
                UnitPrice = 1020,
                IsActive = true
            );
        Insert pbest;
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = pb.Id,
                Product2Id = prodObject.Id,
                UnitPrice = 1020,
                IsActive = true
            );
        Insert pbe;
		
		return prodObject;       
    }
    
    private static Product2 createProductTestData() {
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products');        
        Product2 newProduct = new Product2();
        Date startDate = system.today();   
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
        //String priceBookName = 'T&F India Pricebook';         
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();        
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, 
                                                     Pricebook2Id = standardPricebookId, Product2Id = productId, UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 customPB = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert customPB;        
        List<PricebookEntry> customPBEList = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR', IsActive = True, 
                                                     Pricebook2Id = customPB.Id, Product2Id = productId, UnitPrice = 100.00);    
        
        customPBEList.add(priceBE2);                              
        insert customPBEList;
            
        return customPBEList;
    }

    private static List<OpportunityLineItem> createOpportunityLineItemTestData(String oppId, String priceBE2) {
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