/*
* Tests:  TriggerInterfaceHelper
          TriggerInterface_Account
*/
@isTest
private class zTEST_TriggerInterface {
    static testMethod void test_TriggerInterface_Account() {
        TriggerInterface_Account ti = new TriggerInterface_Account();
        TriggerInterface_Account.Trig trig = new TriggerInterface_Account.Trig();
        
        Boolean bTest = trig.isAfter;
        bTest = trig.isBefore;
        bTest = trig.isDelete;
        bTest = trig.isInsert;
        bTest = trig.isUnDelete;
        bTest = trig.isUpdate;
        Map<Id,Map<String,String>> mapRtIdsToParams = trig.mapRtIdsToParams;
        List<Account> oldList = trig.oldList;
        List<Account> newList = trig.newList;
        Map<Id,Account> oldMap = trig.oldMap;
        Map<Id,Account> newMap = trig.newMap;
    }
    
    static testMethod void test_TriggerInterfaceHelper() {
        TriggerInterfaceHelper.testingInterfaceHelper = true;
        Trigger__c t = new Trigger__c();
        t.Before_Delete__c = true;
        t.Name = 'Account_DeleteCampusDept_Trig';
        t.Enabled__c = true;
        t.Execution_Order__c = 99;
        t.Object__c = 'Account';
        t.Run_for_Recordypes__c = 'Selected';
        insert t;
        
        Id ACCOUNT_RT = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        
        Trigger_Recordtype__c tr = new Trigger_Recordtype__c();
        tr.Trigger__c = t.Id;
        tr.Recordtype_Id__c = ACCOUNT_RT;
        tr.Name = 'T&F - Accounts';
        tr.Enabled__c = true;
        insert tr;
        
        User u = zTEST_Shared.insertUser();
        
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
    }
}