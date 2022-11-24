/*
* Tests:  EmailPreference_UpdateLeadContact_Trig        100%
*/
@isTest
private class zTEST_EmailPreference_UpdateLeadContact {
    static testMethod void test_EmailPreference_UpdateLeadContact_Contact() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TF_CONTACTS_RT = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('EmailPreference_UpdateLeadContact_Trig', 'Email_Preference__c', 99, 'ai,au', null, null);

        Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
        c.RecordTypeId = TF_CONTACTS_RT;
        c.Email = 'test@example.com';
        insert c;
        
        Email_Preference__c ep = new Email_Preference__c();
        ep.Email__c = 'test@example.com';
        ep.Status__c = 'Unsubscribed';
        insert ep;

        ep.Status__c = 'Re-subscribed';
        update ep;
    }
    
    static testMethod void test_EmailPreference_UpdateLeadContact_Lead() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TF_LEADS_RT = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('EmailPreference_UpdateLeadContact_Trig', 'Email_Preference__c', 99, 'ai,au', null, null);

        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.RecordTypeId = TF_LEADS_RT;
        l.Email = 'test@example.com';
        insert l;
        
        Email_Preference__c ep = new Email_Preference__c();
        ep.Email__c = 'test@example.com';
        ep.Status__c = 'Unsubscribed';
        insert ep;
    }
}