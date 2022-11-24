/*
* Tests: CAS_OpportunityUpdateICOwner_Trig      100%    
*/
@isTest
private class zTEST_CAS_OpportunityUpdateICOwner_Trig {

    static testMethod void test_CAS_OpportunityUpdateICOwner_Trig() {
        User u = zTEST_Shared.insertUser();
        User u2 = zTEST_Shared.insertUser();
        Id rtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Opportunity opp = zTEST_Shared.insertOpportunity(rtId, u.Id);
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(opp.Id);
        CAS_Inspection_Copy__c ic = Tests_CASVitalSource.setupTestInspectionCopy(oli.Id, opp.Id);

        TriggerInterfaceHelper.runTrigger('CAS_OpportunityUpdateICOwner_Trig', 'Opportunity', 99, 'au', rtId, null);

        opp.OwnerId = u2.Id;
        update opp;
    }
}