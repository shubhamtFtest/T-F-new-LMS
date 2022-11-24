/********************************************************************
  This test class is used for TF_AccountMergeTrigger trigger.
********************************************************************/
@isTest
public class zTEST_TF_AccountMergeUpdateTrigHandler {
    /*******************************************************************
    This method is used to test TF_AccountMergeTrigger trigger.
    ********************************************************************/
    static testMethod void test_AccountMergeUpdateTriggerHandler() {
        User u = zTEST_Shared.insertUser();
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        TriggerInterfaceHelper.runTrigger('TF_AccountMergeUpdateTriggerHandler', 'Account', 99, 'ad', TFAccountsRecordTypeId, null);
        //insert Accounts
        List<Account> accounts = new List<Account>();
        Account a1 = zTEST_Shared.noinsertAccount(u.Id);
        a1.RecordtypeId = TFAccountsRecordTypeId;
        accounts.add(a1);
        Account a2 = zTEST_Shared.noinsertAccount(u.Id);
        a2.RecordtypeId = TFAccountsRecordTypeId;
        accounts.add(a2);
        insert accounts;
        test.startTest();
        //merge Accounts
        Database.merge(a1,a2);
        test.stopTest();
    }
}