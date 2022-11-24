public with sharing class Trig_Opp_PreventInsert implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            if (trig.triggerSize == 1) {
                if (trig.newList[0].Primary_Contact__c == null && !PublicVariables.BillingRenewalInProgress && (!Test.isRunningTest() || PublicVariables.TestingButRunAnyway)) {
                    trig.newList[0].addError('You may only create a new opportunity from a contact');
                }
            }
        }
    }
}