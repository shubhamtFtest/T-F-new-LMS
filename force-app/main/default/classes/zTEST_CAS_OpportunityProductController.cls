/*
* Tests: CAS_OpportunityProductController.cls  81%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
* Modified by Shefali Arora - 2019.06.25 - Case no : 01248205 
*/
@isTest
private class zTEST_CAS_OpportunityProductController {
    static testMethod void test_CAS_OpportunityProductController_US() {
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        
        User u = zTEST_Shared.noinsertUser();
        u.CurrencyIsoCode = 'USD';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);

        Product2 p = zTEST_Shared.insertProduct2();
        p.ProductCode = 'iotest135246';
        p.US_Inventory_Status__c = 'Available';
        p.IsActive = true;
        update p;
        
        Pricebook2 standardPb = zTEST_Shared.insertPricebook2_2();
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'T&F - Pricebook';
        pb.IsActive = true;
        insert pb;
        
        PricebookEntry standardPbe = new PricebookEntry(Pricebook2Id=standardPb.Id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
        insert standardPbe;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p.id, UnitPrice=1.00, IsActive=true, UseStandardPrice=false, CurrencyIsoCode='USD');
        insert pbe;
        
        Id pbId = [SELECT Pricebook2Id FROM PricebookEntry WHERE Id = :pbe.Id].Pricebook2Id;
        
        //Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'CAS - Course Opportunities');
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0031794
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.CurrencyIsoCode = 'USD';
        opp.Pricebook2Id = pbId;
        opp.LeadSource = 'Direct';
        opp.Lead_Source_Detail__c = 'Webinar';
        insert opp; 
        
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
        TriggerInterfaceHelper.runTrigger('OLI_DefaultContact_Trig', 'OpportunityLineItem', 1, 'bi', oppRecordtypeId, null); 
        
        Account acct = new Account();
        acct.Name = 'test';
        acct.Type = 'Agent';
        acct.Classification__c = 'Client';
        insert acct;
        
        Contact cont = new Contact();
        cont.AccountId = acct.id;
        cont.FirstName = 'test';
        cont.LastName = 'test_con';
        cont.MailingCountry = 'United States';
        cont.MailingStreet = '1234 Main St\nSuite100\nAttn:John Doe';
        cont.OtherStreet = '1234 Main St\nSuite100\nAttn:John Doe';
        insert cont;
        
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.Recipient__c = cont.id;
        insert oli;
        
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli2.Recipient__c = cont.id;
        insert oli2;
        
        OpportunityLineItem oli3 = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli3.Recipient__c = cont.id;
        insert oli3;

        pageReference pageOLI = Page.CAS_OpportunityProduct;
        pageOLI.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pageOLI);
        CAS_OpportunityProductController con = new CAS_OpportunityProductController(new ApexPages.StandardController(opp));
        
        con.searchString = 'iotest135246';
        con.updateAvailableList(); 
        con.selectedPbeId = pbe.Id;
        con.addToSelectedProducts();
        con.selectedTempOliId = 1;
        con.removeFromSelectedProducts();
        con.save();
        con.cancel();        

        CAS_OpportunityProductController.ProductWrapper pw = new CAS_OpportunityProductController.ProductWrapper();
        pw.oli = oli;
    }
}