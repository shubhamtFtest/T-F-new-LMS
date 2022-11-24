/*
* Tests:  Lead_UpdateEmailPreference_Trig       100%
*/
@isTest
private class zTEST_Lead_UpdateEmailPreference_Trig {
    static testMethod void test_Lead_UpdateEmailPreference_Trig() {
        User u = zTEST_Shared.insertUser();
        Id TF_LEADS_RT = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('Lead_UpdateEmailPreference_Trig', 'Lead', 99, 'bi,bu,ai,au', TF_LEADS_RT, null);
        
        Email_Preference__c ep = new Email_Preference__c();
        ep.Email__c = 'test@example.com';
        ep.Status__c = 'Unsubscribed';
        insert ep;
        
        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.RecordTypeId = TF_LEADS_RT;
        l.Email = 'test@example.com';
        insert l;
        
        l.HasOptedOutOfEmail = false;
        update l;
        
        l.HasOptedOutOfEmail = true;
        update l;
        
        l.Email = 'test2@example.com';
        update l;
    }
}