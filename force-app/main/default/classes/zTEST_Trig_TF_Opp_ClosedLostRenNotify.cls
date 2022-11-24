/**
*   Tests: Trig_TF_Opp_ClosedLostRenewalNotify.cls  97%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
 */
@isTest
private class zTEST_Trig_TF_Opp_ClosedLostRenNotify {

    static testMethod void test_Trig_TF_Opp_ClosedLostRenewalNotify() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        //Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Journals Customer Opportunity (Direct)');
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0031794
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.ProductCode = 'SUBS';
        insert p;
        Pricebook2 pb = zTEST_Shared.insertPricebook2_2();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(pb.Id, p.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 1;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 1;
        insert oli;        
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ClosedLostRenewalNotify', 'Opportunity', 99, 'au',  recordtypeId, null);
        opp.Type = 'Renewal'; 
        opp.StageName = 'Closed Lost';        
        update opp;
    }
}