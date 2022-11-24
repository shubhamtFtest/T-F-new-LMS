/*
* Tests:  Campus_UpdatePartyId_Trig        100%
*/
@isTest
private class zTEST_Campus_UpdatePartyId_Trig {
	static testMethod void test_Campus_UpdatePartyId_Trig() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        TriggerInterfaceHelper.runTrigger('Campus_UpdatePartyId_Trig', 'Campus__c', 99, 'bi', null, null);
        Campus__c camp = new Campus__c();
        camp.Account__c = a.Id;
        camp.Name = 'test';
        insert camp;
        integer nextPartyId = PartyIdIncrementer.getNextPartyId();        
    }
}