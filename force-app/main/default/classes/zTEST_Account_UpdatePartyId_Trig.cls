/*
* Tests:  Account_UpdatePartyId_Trig        100%
*/
@isTest
private class zTEST_Account_UpdatePartyId_Trig {
	static testMethod void test_Account_UpdatePartyId_Trig() {
        User u = zTEST_Shared.insertUser();
        Id TF_ACCOUNT_RT = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts');
        TriggerInterfaceHelper.runTrigger('Account_UpdatePartyId_Trig', 'Account', 99, 'bi', TF_ACCOUNT_RT, null);
 
        List<Account> accounts = new List<Account>();
        for (integer i = 0; i < 200; i++) {
            Account a = zTEST_Shared.noinsertAccount(u.Id);
            accounts.add(a);
        }
        insert accounts;
        
        integer nextPartyId = PartyIdIncrementer.getNextPartyId();
    }
}