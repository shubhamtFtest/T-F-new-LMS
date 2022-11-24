/*
* Tests:  Account_DeleteCampusDept_Trig		100%
*/
@isTest
private class zTEST_Account_DeleteCampusDept_Trig {
    static testMethod void test_Account_DeleteCampusDept_Trig() {
        User u = zTEST_Shared.insertUser();
        Id ACCOUNT_RT = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('Account_DeleteCampusDept_Trig', 'Account', 99, 'bd,ad', ACCOUNT_RT, null);
        
        Account a = zTEST_Shared.insertAccount(u.Id, ACCOUNT_RT);
		
        Campus__c camp = new Campus__c();
        camp.Name = 'test';
        camp.Account__c = a.Id;
        insert camp;

        Department__c dept = new Department__c();
        dept.Name = 'test';
        dept.Account__c = a.Id;
        dept.Campus__c = camp.Id;
        insert dept;

		delete a;
        
        List<Campus__c> camps = [SELECT Id FROM Campus__c WHERE Account__c = :a.Id];
        List<Department__c> depts = [SELECT Id FROM Department__c WHERE Account__c = :a.Id];
        
		system.assertEquals(0, camps.size(), 'Campuses were not correctly deleted.');       
		system.assertEquals(0, depts.size(), 'Departments were not correctly deleted.');       
    }

    static testMethod void test2_Account_DeleteCampusDept_Trig() {
        User u = zTEST_Shared.insertUser();
        Id ACCOUNT_RT = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('Account_DeleteCampusDept_Trig', 'Account', 99, 'bd,ad', ACCOUNT_RT, null);
        
        Account a = zTEST_Shared.insertAccount(u.Id, ACCOUNT_RT);
        Account a_master = zTEST_Shared.insertAccount(u.Id, ACCOUNT_RT);
		
        Campus__c camp = new Campus__c();
        camp.Name = 'test';
        camp.Account__c = a.Id;
        insert camp;

        Department__c dept = new Department__c();
        dept.Name = 'test';
        dept.Account__c = a.Id;
        dept.Campus__c = camp.Id;
        insert dept;

		merge a_master a;
        
        List<Campus__c> camps = [SELECT Id FROM Campus__c WHERE Account__c = :a_master.Id];
        List<Department__c> depts = [SELECT Id FROM Department__c WHERE Account__c = :a_master.Id];
        
		system.assertEquals(1, camps.size(), 'Campuses should not have been deleted.');       
		system.assertEquals(1, depts.size(), 'Departments should not have been deleted.');       
    }
}