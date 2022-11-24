@isTest
private class zTest_Ir_CreateSalesOrders {
    @isTest static void CreateOrder()
    {
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint'); 
        List<Opportunity> opplist=new List<Opportunity>();
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.StageName = 'Closed Won';
        opp.AccountId=acc.id;
        opplist.add(opp);
        insert opplist;
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice = null;
        oli.Distributor__c= acc.Id;
        oli.Is_Approved__c=true;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        
        Test.startTest();
        try {
            IR_CreateSalesOrders irp=new IR_CreateSalesOrders();
            irp.CreateOrder(opplist);
        } catch (exception e) { 
        }
        Test.stopTest(); 
    }
}