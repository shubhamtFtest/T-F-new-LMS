/******************************************************************
* Tests: zTEST_TF_IndiaRePrintHistoryCtr             100%
*******************************************************************/

@isTest
private class zTEST_TF_IndiaRePrintHistoryCtr {
    
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
    
    private static testmethod void testPagedResult(){
        test.startTest();        
        TF_IndiaRePrintHistoryCtr.PagedResult pgResult = new  TF_IndiaRePrintHistoryCtr.PagedResult();
        pgResult.total=50; 
        test.stopTest();         
    }
    
    static testMethod void testCloneOpportunity() {   
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli; 
        
        TF_IndiaRePrintHistoryCtr.PagedResult contentData = new TF_IndiaRePrintHistoryCtr.PagedResult();
        OLIHistory__c OLIHistoryObj = createOLIHistorySampleData(opp.Id, oli.Id);
        
        TF_IndiaRePrintHistoryCtr.getOLIHistories(opp.Id);
		test.stopTest();
    }
    
    private static testmethod void test_updateOpportunityLineItemUMC(){
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli;
        
        OpportunityLineItem oliObj = new OpportunityLineItem();
        oliObj.Id = oli.Id;
        oliObj.UMC__c = 2;
        update oliObj;
        
        OLIHistory__c OLIHistoryObj = createOLIHistorySampleData(opp.Id, oli.Id);      
        TF_IndiaRePrintHistoryCtr.updateOpportunityLineItemUMC(OLIHistoryObj.Id);
        test.stopTest();
    }


    private static testmethod void test_changeApprovalStatus(){
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli;
        
        OpportunityLineItem oliObj = new OpportunityLineItem();
        oliObj.Id = oli.Id;
        oliObj.UMC__c = 2;
        update oliObj;
        
        OLIHistory__c OLIHistoryObj = createOLIHistorySampleData(opp.Id, oli.Id);      
        TF_IndiaRePrintHistoryCtr.changeApprovalStatus(oli.Id, OLIHistoryObj.Id);
        test.stopTest();
    } 
    
    private static testmethod void test_updateOLIUMC_valid(){
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli;
        
        OpportunityLineItem oliObj = new OpportunityLineItem();
        oliObj.Id = oli.Id;
        oliObj.UMC__c = 2;
        update oliObj;
        
        OLIHistory__c OLIHistoryObj = createOLIHistorySampleData(opp.Id, oli.Id);      
        String msg = TF_IndiaRePrintHistoryCtr.updateOLIUMC(oli.Id, 3.2);
        System.assert(msg == 'UMC_UPDATE_DONE');
        test.stopTest();
    }
    
    private static testmethod void test_updateOLIUMC_RecordNotFound(){
        test.startTest();
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        oli.Recipient__c = c.Id;
        insert oli;
        
        OpportunityLineItem oliObj = new OpportunityLineItem();
        oliObj.Id = oli.Id;
        oliObj.UMC__c = 2;
        update oliObj;
        
        OLIHistory__c OLIHistoryObj = createOLIHistorySampleData(opp.Id, oli.Id);      
        String msg = TF_IndiaRePrintHistoryCtr.updateOLIUMC(null, 3.2);
        System.assert(msg == 'RECORD_NOT_FOUND');
        test.stopTest();
    }
    
}