/******************************************************************
* Tests: TF_IndiaRePrintCostCalculator             95%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaRePrintCostCalculator {

    static testMethod void testMethod1() {   
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
        
        //update opportunity
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opplst = [SELECT Id, AccountId FROM Opportunity WHERE Id =:opp.Id];
        for(Opportunity oppLstObj : opplst){
            oppLstObj.AccountId = demoacc.Id;
            oppToUpdate.add(oppLstObj);
        }
        update oppToUpdate;
        
        
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
        test.startTest();
        TF_IndiaRePrintCostCalculator.getLastPrintDetails(lstOLIInsert[0].Id);
        test.stopTest();
    }

    private static testmethod void testOpportunityLineItemDetails(){
        test.startTest();        
        TF_IndiaRePrintCostCalculator.OpportunityLineItemDetails OLIDetails = new  TF_IndiaRePrintCostCalculator.OpportunityLineItemDetails();
        OLIDetails.oliId = '00k1X000006IXts';
        OLIDetails.Qty = 11;
        OLIDetails.popularFormat = '';
        OLIDetails.formatHeight = 200;
        OLIDetails.formatWidth = 300;
        OLIDetails.versionType = 'Paperback';
        OLIDetails.requiredVersionType = 'Hardback';
        OLIDetails.textColour = 'Mono';
        OLIDetails.paperTypeGSM = '80gsm';
        OLIDetails.extent = 500;
        OLIDetails.printedPages = 500;
        OLIDetails.mrp = 500;
        test.stopTest();         
    }

    private static testmethod void testwrapProduct(){
        test.startTest();        
        TF_IndiaRePrintCostCalculator.wrapProduct wrapProductObj = new  TF_IndiaRePrintCostCalculator.wrapProduct();
        wrapProductObj.productId = '00k1X000006IXts';
        wrapProductObj.productCode = '123456';
        wrapProductObj.popularFormat = '';
        wrapProductObj.formatHeight = 200;
        wrapProductObj.formatWidth = 300;
        wrapProductObj.textColour = 'Mono';
        wrapProductObj.paperType = '80gsm';
        wrapProductObj.versionType = 'Hardback';
        wrapProductObj.extent = 400;
        wrapProductObj.lastUMCPopularFormat = '';
        wrapProductObj.lastUMCFormatHeight = 500;
        wrapProductObj.lastUMCFormatWidth = 200;
        wrapProductObj.lastUMCPaperType = '';
        wrapProductObj.lastUMCVersionType = 'Paperback';
        wrapProductObj.lastUMCTextColour = 'Mono';
        wrapProductObj.lastUMCQuantity = 12;
        wrapProductObj.lastUMC = 4.5;
        //wrapProductObj.lastUMCDate = '';
        wrapProductObj.lastUMCCustomerQuote = 12;
        test.stopTest();         
    }    

    
    private static testmethod void testPagedResultDetails(){
        test.startTest();        
        TF_IndiaRePrintCostCalculator.PagedResultDetails pagedResultDetails = new  TF_IndiaRePrintCostCalculator.PagedResultDetails();
        pagedResultDetails.Quantity = 100;
        pagedResultDetails.msg = 'message';
        test.stopTest();         
    }

    private static testmethod void testProductionHistoryDetails(){
        test.startTest();        
        TF_IndiaRePrintCostCalculator.ProductionHistoryDetails req = new  TF_IndiaRePrintCostCalculator.ProductionHistoryDetails();
        req.title = 'test';
        req.IndianISBN = '';
        req.binding = 'Hardback';
        req.umc = 4.3;
        req.mrp = 11;
        req.gm = 4.2;
        req.customerQuote = '2';
        req.gratis = 300;       
        req.year = '2019';
        req.Qty = 10;
        test.stopTest();         
    }
    
    private static testMethod void testPicklist() {       
        TF_IndiaRePrintCostCalculator pe = new TF_IndiaRePrintCostCalculator();
    	Test.startTest();
        //List<SelectOption> options = pe.getSizeInInches();
        Test.stopTest();       
        //system.assertEquals(options.get(0).getValue(), 'None');
    }
    
    private static testmethod void test_getCoversionRate(){
        test.startTest(); 
        createCustomSettingSampleData();
        Decimal coversionRate = TF_IndiaRePrintCostCalculator.getCoversionRate();
		System.assert(coversionRate == 90);
        test.stopTest();         
    }
    
    private static testmethod void test_getProductId(){

        test.startTest(); 
        //TF_IndiaRePrintCostCalculator.getProductId('5.5 X 8.5', '5');
        test.stopTest();         
    }    
 
    static testMethod void test_getOLIDetail() {   
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
        
        //update opportunity
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opplst = [SELECT Id, AccountId FROM Opportunity WHERE Id =:opp.Id];
        for(Opportunity oppLstObj : opplst){
            oppLstObj.AccountId = demoacc.Id;
            oppToUpdate.add(oppLstObj);
        }
        update oppToUpdate;
        
        
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
        
		TF_IndiaRePrintCostCalculator.getOLIDetail(lstOLIInsert[0].Id);
        TF_IndiaRePrintCostCalculator.getProductId(lstOLIInsert[0].Id);
    }
        

    private static testmethod void test_updateUMC(){
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
        
        String oliId= lstOLIInsert[0].Id; 
        String umc = '4.5';
        String qty = '5';
        String extent = '500';
        String popularFormat = ''; 
        String formatHeight = '100';
        String formatWidth = '200';
        String versionType = 'Hardback'; 
        String textColour = 'Mono';
        String paperType = '80gsm';
    
        test.startTest(); 
        String result = TF_IndiaRePrintCostCalculator.updateUMC(oliId, umc, qty, extent, popularFormat, formatHeight, formatWidth, versionType, textColour, paperType);
        //RECORD_UPDATED
        test.stopTest();         
    }
 
    private static testmethod void test_getPopularFormats(){
        Print_Cost_Calculator_Setting__c pccs = createPrintCostCalculatorSettingSampleData();
        test.startTest(); 
        TF_IndiaRePrintCostCalculator.getPopularFormats('5.5 X 8.5', '5');
        test.stopTest();         
    }

    static testMethod void test_getProductionHistory() {   
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
        
        //update opportunity
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> opplst = [SELECT Id, AccountId FROM Opportunity WHERE Id =:opp.Id];
        for(Opportunity oppLstObj : opplst){
            oppLstObj.AccountId = demoacc.Id;
            oppToUpdate.add(oppLstObj);
        }
        update oppToUpdate;
        
        
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
		
        /* test */
        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        
        order orderObj = new order();
        orderObj.OpportunityId = opp.Id;
        orderObj.EffectiveDate = Date.today();
        orderObj.Status = 'Draft';
        orderObj.isWithoutInvoice__c = true;
        orderObj.Pricebook2Id = pb.Id;
        orderObj.AccountId = testacc.id;
        insert orderObj;        

        Print_Order__c  printorderobj=new Print_Order__c();
        printorderobj.Status__c = 'Print Order Created';
        printorderobj.Invoice_Number__c = '1234';
        printorderobj.Reference_Number__c = '1234';
        printorderobj.Payment_Terms__c = '69days';
        printorderobj.Delivery_Date__c = system.today();
        printorderobj.Special_Instructions__c = 'test';
        printorderobj.Packing_Instructions__c = 'test';
        printorderobj.Customer__c = testacc.id;
        printorderobj.Printer__c = testacc.id;
        printorderobj.isPoUploaded__c = true;
        printorderobj.order__c = orderObj.id;        
        insert printorderobj;
        
        Print_Order_Item__c poi = createPrintOrderItemTestData(prdObj.Id, printorderobj.Id);
  
        test.startTest(); 
        TF_IndiaRePrintCostCalculator.getProductionHistory(lstOLIInsert[0].Id);
        test.stopTest();         
        
    } 
    
    /**************************************************************************************/
    //sample data
    private static void createCustomSettingSampleData() {
        IndiaReprintSettings__c setting = new IndiaReprintSettings__c();
        setting.Client_Secret__c = 'us-west-2';
        setting.Customer_Quote_Conversion_Rate__c = 90;
        setting.DomainId__c = 2;
        setting.Password__c = 'AKIAIGGCPKCJXTHQEPUQ ';
        setting.MRP_Conversion_Rate__c = 95;
        setting.Production_Team_Email__c = 'abc@gmail.com';
        setting.Reprint_Eligibility_API_URL__c = 'http://indiareprintsfapi-test.taylorandfrancis.com/api/Proposal/SaveManualProposal';
        setting.Sales_Team_Email__c = 'sales@gmail.com';
        setting.Token_URL__c = 'http://indiareprintsfapi-test.taylorandfrancis.com/api/Login/Validate';
        setting.User_Name__c = 'username';
        insert setting;         
    }

    private static Print_Cost_Calculator_Setting__c createPrintCostCalculatorSettingSampleData() {
        Print_Cost_Calculator_Setting__c pccs = new Print_Cost_Calculator_Setting__c();
        Date startDate = date.newInstance(2020, 02, 20);        
        pccs.X70gsm__c = 0.68;
        pccs.X80gsm__c = 0.70;
        pccs.Color__c = 5.22;
        pccs.Dust_Jacket__c = 1;
        pccs.Format_Height_mm__c = 100;
        pccs.Format_Width_mm__c = 200;
        pccs.Hard_Case_PLC__c = 43;
        pccs.Is_Active__c = true;
        pccs.Quantity__c = '1 to 10';
        pccs.Sewing__c = 0.04;
        pccs.Size_in_Inches__c = '5.5 X 8.5';             
        insert pccs;
        return pccs;
    }
    
    private static OLIHistory__c createOLIHistorySampleData(String oppId, String oliId) {
        OLIHistory__c OLIHistoryObj = new OLIHistory__c();
        Date startDate = date.newInstance(2020, 02, 20);        
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
    
    private static Print_Order_Item__c createPrintOrderItemTestData(Id productId, Id printOrderId) {                     
        Print_Order_Item__c poi = new Print_Order_Item__c();
        Date startDate = date.newInstance(2020, 02, 20);
        poi.MRP__c = 1200;
        poi.Product__c = productId;
        poi.Print_Order__c = printOrderId;
        poi.UMC__c = 3.4;
       	poi.Year__c = '2019';       
        insert poi;
        return poi;
    }    
}