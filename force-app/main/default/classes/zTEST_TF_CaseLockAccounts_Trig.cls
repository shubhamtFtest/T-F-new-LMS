/*
* Tests: TF_CaseLockAccounts_Trig   100%
*/

@isTest
private class zTEST_TF_CaseLockAccounts_Trig {
    static testMethod void test_TF_CaseLockAccounts_Trig() {
        User u = zTEST_Shared.noinsertUser();
        u.Admin_Options__c = null;
        insert u;
        
        System.runAs(u)
        {
            Account a = zTEST_Shared.insertAccount(u.Id);
            
            String createdDate = string.valueOfGmt(Date.Today());  //2011-09-10 07:00:00
            String mm_yyyy = createdDate.substring(5,7) + '-' + createdDate.substring(0,4); //09-2011
            
            CasCS__c cs = new CasCS__c();
            cs.Name = 'Locked_Records';
            cs.Value__c = mm_yyyy;
            cs.Description__c = 'test';
            insert cs;        
    
            Id caseRecordtypeId = '0120Y000000Wn9gQAC'; //T&F - CSD
            
            TriggerInterfaceHelper.runTrigger('TF_CaseLockAccounts_Trig', 'Case', 1, 'bi,bu', caseRecordtypeId, null);
            
            try {
                Case c = new Case();
                c.OwnerId = u.Id;
                c.AccountId = a.Id;
                c.RecordTypeId = caseRecordtypeId;
                insert c;
            } catch (Exception e){}    
        }
    }
}