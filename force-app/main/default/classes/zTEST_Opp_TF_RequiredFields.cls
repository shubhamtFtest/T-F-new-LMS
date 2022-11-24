/**
Tests: Opp_TF_RequiredFields_Trig       100%
 */
@isTest
private class zTEST_Opp_TF_RequiredFields {

    static testMethod void test_Opp_TF_RequiredFields() {
        User u = zTEST_Shared.insertUser();
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.Service_Description__c = 'NOT Subscription';
        insert p;
        
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');        
        
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p.Id); //Standard Pricebook
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 1;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 1;
        insert oli;
        
        //zTEST_Shared.runTriggersForRecordtypes.put('Opp_TF_RequiredFields', new Set<Id>{opp.RecordtypeId});
        TriggerInterfaceHelper.runTrigger('Opp_TF_RequiredFields_Trig', 'Opportunity', 2, 'bu', opp.RecordtypeId, null);
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
    }
}