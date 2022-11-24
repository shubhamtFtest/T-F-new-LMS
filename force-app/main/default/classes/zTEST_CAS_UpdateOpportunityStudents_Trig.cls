/*
* Tests: CAS_UpdateOpportunityStudents_Trig    100%
*/
@isTest
private class zTEST_CAS_UpdateOpportunityStudents_Trig {

    static testMethod void test_CAS_UpdateOpportunityStudents_Trig() {
        User u = zTEST_Shared.insertUser();
        Id rtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Opportunity opp = zTEST_Shared.insertOpportunity(rtId, u.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(opp.Id);
        oli.Quantity = 1;
        insert oli;

        TriggerInterfaceHelper.runTrigger('CAS_UpdateOpportunityStudents_Trig', 'Opportunity', 99, 'au', rtId, null);

        opp.Number_of_Students__c = (opp.Number_of_Students__c == null ? 1 : opp.Number_of_Students__c + 1);
        update opp;
    }
}