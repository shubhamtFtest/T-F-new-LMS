/*
* Tests:  Department_UpdatePartyId_Trig        100%
*/
@isTest
private class zTEST_Department_UpdatePartyId_Trig {
	static testMethod void test_Department_UpdatePartyId_Trig() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        TriggerInterfaceHelper.runTrigger('Department_UpdatePartyId_Trig', 'Department__c', 99, 'bi', null, null);
        Department__c dept = new Department__c();
        dept.Account__c = a.Id;
        dept.Name = 'test';
        insert dept;
        integer nextPartyId = PartyIdIncrementer.getNextPartyId();        
    }
}