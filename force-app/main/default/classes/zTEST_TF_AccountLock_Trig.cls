/*
* Tests: TF_AccountLock_Trig	100%
*/

@isTest
private class zTEST_TF_AccountLock_Trig {
	static testMethod void test_TF_AccountLock_Trig() {
		User u = zTEST_Shared.noinsertUser();
        u.Admin_Options__c = null;
        insert u;
        
        System.runAs(u)
        {
            Id accountRecordtypeId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
            Account a = zTEST_Shared.insertAccount(u.Id, accountRecordtypeId);
            
            String createdDate = string.valueOfGmt(Date.Today());  //2011-09-10 07:00:00
            String mm_yyyy = createdDate.substring(5,7) + '-' + createdDate.substring(0,4); //09-2011
            
            CasCS__c cs = new CasCS__c();
            cs.Name = 'Locked_Records';
            cs.Value__c = mm_yyyy;
            cs.Description__c = 'test';
            insert cs;
            
            TriggerInterfaceHelper.runTrigger('TF_AccountLock_Trig', 'Account', 1, 'bu', accountRecordtypeId, null);
            
            try {
                a.Description = createdDate;
                update a;
            } catch (Exception e){}    
        }
	}
}