/*
*    Tests: Trig_Opp_PreventInsert.cls    100%
*/
@isTest
private class zTEST_Trig_Opp_PreventInsert {
    static testMethod void test_Trig_Opp_PreventInsert() {
        User u = zTEST_Shared.insertUser();
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id);
        opp.Primary_Contact__c = null;
        TriggerInterfaceHelper.runTrigger('Trig_Opp_PreventInsert', 'Opportunity', 1, 'bi', oppRecordtypeId, null);
        PublicVariables.TestingButRunAnyway = true;
        try{
            insert opp;
        } catch(Exception e) {
        }
        PublicVariables.TestingButRunAnyway = false;
    }
}