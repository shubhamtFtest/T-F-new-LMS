/*
* Tests: TF_ContactDefaultCampus_Trig	100%
*/

@isTest
private class zTEST_TF_ContactDefaultCampus_Trig {
	static testMethod void test_TF_ContactLockAccounts_Trig() {
		User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Campus__c camp = new Campus__c();
        camp.Account__c = a.Id;
        camp.Name = 'Test';
        insert camp;
        Department__c dept = new Department__c();
        dept.Account__c = a.Id;
        dept.Campus__c = camp.Id;
        dept.Name = 'Test';
        insert dept;
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        
        TriggerInterfaceHelper.runTrigger('TF_ContactDefaultCampus_Trig', 'Contact', 1, 'bi,bu', contactRecordtypeId, null);
        Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
        c.RecordTypeId = contactRecordtypeId;
        c.Department_Object__c = dept.Id;
        insert c;
	}
}