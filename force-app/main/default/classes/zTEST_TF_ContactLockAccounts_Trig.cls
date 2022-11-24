/*
* Tests: TF_ContactLockAccounts_Trig    100%
*/

@isTest
private class zTEST_TF_ContactLockAccounts_Trig {
    static testMethod void test_TF_ContactLockAccounts_Trig() {
        User u = zTEST_Shared.noinsertUser();
        u.Admin_Options__c = null;
        insert u;
        
        System.runAs(u)
        {
            Account a = zTEST_Shared.insertAccount(u.Id);
            Id contactRecordtypeId = '0120Y000000Wn68QAC'; //T&F - Contacts
            
            String createdDate = string.valueOfGmt(Date.Today());  //2011-09-10 07:00:00
            String mm_yyyy = createdDate.substring(5,7) + '-' + createdDate.substring(0,4); //09-2011
            
            CasCS__c cs = new CasCS__c();
            cs.Name = 'Locked_Records';
            cs.Value__c = mm_yyyy;
            cs.Description__c = 'test';
            insert cs;        
            
            TriggerInterfaceHelper.runTrigger('TF_ContactLockAccounts_Trig', 'Contact', 1, 'bi,bu', contactRecordtypeId, null);
        
            try {
                Contact c = zTEST_Shared.insertContact(u.Id, a.Id, contactRecordtypeId);
            } catch (Exception e){}    
        }
    }
}