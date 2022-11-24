/************************************************************************** 
** Last Modified by Amit Kumar
** IR_OpportuntityAutoCloseSchedule
** IR_OpportuntityAutoCloseBatch
***************************************************************************/
@isTest
private class zTEST_IR_OpportuntityAutoCloseBatch {

    static testMethod void myUnitTest() {
        Database.BatchableContext BC;
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        User usr = zTEST_Shared.insertUser();
        Account acc = insertAccount(usr.Id);        
        Opportunity opp = new Opportunity(name='Test', recordtypeid = oppRecordtypeId, StageName = 'Prospect',
                                          CloseDate = date.today(), OwnerId = usr.Id, Proposal_Type__c = 'Reprint',
                                          Overall_Reprint_Eligibility__c = '',Is_Reprint_Eligibility_Request_Sent__c = false,
                                          Is_Pricing_Request_Sent__c = false, Is_UMC_Request_Sent__c = false,Is_MRP_Request_Sent__c = false,
                                          Is_Pricing_Entered__c = false, Is_Approved__c = false
                                         );
        insert opp;

        List<Opportunity> opptoinsert = new List<Opportunity>();
        for(Integer i=0; i<1; i++){
            Opportunity oppobj =new Opportunity();
            oppobj.name='Test';
            oppobj.recordtypeid = oppRecordtypeId;
            oppobj.StageName = 'Prospect';
            oppobj.Proposal_Type__c = 'Reprint';
            oppobj.OwnerId = usr.Id;
            oppobj.CloseDate = date.today();
            opptoinsert.add(oppobj);
        }        
        insert opptoinsert;        
        
        Test.StartTest();
        IR_OpportuntityAutoCloseBatch OpportuntityAutoClose = new IR_OpportuntityAutoCloseBatch();
        OpportuntityAutoClose.isTesting = true;
        ID batchprocessid = Database.executeBatch(OpportuntityAutoClose);      
        System.Assert(true);
    	
        //Create a product                 
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = '9780367001209',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pbeOriginal = new List<PricebookEntry>();
        PricebookEntry priceBE1 = new PricebookEntry(
            CurrencyIsoCode = 'INR',
            IsActive = True, 
            Pricebook2Id = standardPricebookId, 
            Product2Id = prodObject.Id,
            UnitPrice = 100.00);                                  
        pbeOriginal.add(priceBE1);                              
        insert pbeOriginal;
        
        Pricebook2 priceBook = new Pricebook2(Name = 'T&F India Pricebook', IsActive = True);
        insert priceBook;
        
        List<PricebookEntry> pbeReprint = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'INR',IsActive = True, Pricebook2Id = priceBook.Id, 
                                                     Product2Id = prodObject.Id,UnitPrice = 100.00);                                            
        pbeReprint.add(priceBE2);                              
        insert pbeReprint;        

        //Create contact     
        Contact conObject = new Contact(AccountId = acc.Id, FirstName = 'test', LastName = 'test');      
        insert conObject;
        
        //Add contact role to opportunity 
        OpportunityContactRole newContactRoleList = new OpportunityContactRole(ContactId = conObject.Id, OpportunityId = opp.Id,Role = 'Decision Maker',IsPrimary = true);
        insert newContactRoleList;

        List<OpportunityLineItem> lstOLIInsert = new List<OpportunityLineItem>();         
        OpportunityLineItem oliNew = new OpportunityLineItem(
            OpportunityId = opp.Id, 
            Quantity = 5, 
            Required_Version_Type__c = 'Paperback',
            PricebookEntryId = pbeReprint[0].Id, 
            IR_Product_Type__c = 'New'
        );
        lstOLIInsert.add(oliNew);               
        //insert lstOLIInsert;        
        
        
        List<OpportunityLineItem> oliList = [SELECT Id, OpportunityId, Opportunity.IsClosed, Opportunity.StageName 
                   FROM OpportunityLineItem WHERE (Opportunity.CloseDate < TODAY 
                                                   AND Opportunity.RecordType.Name = 'T&F - India Reprint' 
                                                   AND Opportunity.IsClosed = false) ORDER BY OpportunityId ASC];
        
        
        OpportuntityAutoClose.execute(BC, opptoinsert);
        Test.stopTest();        
    }
    
    static testMethod void OpportuntityAutoCloseSchedule()  
    {
        Test.startTest();
        // Schedule the test job
        IR_OpportuntityAutoCloseSchedule m = new IR_OpportuntityAutoCloseSchedule();
        //m.sendStatus = true;
        String sch = '20 30 8 10 2 ?';
        System.schedule('TEST_OpportuntityAutoCloseSchedule',sch, m);        
        Test.stopTest();
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
}