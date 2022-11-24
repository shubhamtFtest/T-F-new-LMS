/*
* Tests: TF_EventLockAccounts_Trig  100%
*/

@isTest
private class zTEST_TF_EventLockAccounts_Trig {
    static testMethod void test_TF_EventLockAccounts_Trig() {
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
    
            Id taskRecordtypeId = '0120Y000000WnAWQA0'; //T&F - Events
            
            TriggerInterfaceHelper.runTrigger('TF_EventLockAccounts_Trig', 'Event', 1, 'bi,bu', taskRecordtypeId, null);
            
            try {
                Event ev = new Event();
                ev.OwnerId = u.Id;
                ev.WhatId = a.Id;
                ev.RecordTypeId = taskRecordtypeId;
                insert ev;
            } catch (Exception e){}    
        }
    }
}