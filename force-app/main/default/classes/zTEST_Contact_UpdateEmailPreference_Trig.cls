/*
* Tests:  Contact_UpdateEmailPreference_Trig        100%
*/
@isTest
private class zTEST_Contact_UpdateEmailPreference_Trig {
    static testMethod void test_Contact_UpdateEmailPreference_Trig() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TF_CONTACTS_RT = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('Contact_UpdateEmailPreference_Trig', 'Contact', 99, 'bi,bu,ai,au', TF_CONTACTS_RT, null);
        
        //OptOuts

        Email_Preference__c ep = new Email_Preference__c();
        ep.Email__c = 'test@example.com';
        ep.Status__c = 'Unsubscribed';
        insert ep;
        
        Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
        c.RecordTypeId = TF_CONTACTS_RT;
        c.Email = 'test@example.com';
        insert c;
        
        c.HasOptedOutOfEmail = false;
        update c;
        
        c.HasOptedOutOfEmail = true;
        update c;
        
        c.Email = 'test2@example.com';
        update c;
        
        //OptIns
        
        c.optin_optout_status__c = 'Explicit Opt-In';
        c.optin_optout_source__c = 'CATS';
        c.HasOptedOutOfEmail = false;
        update c;
        
        Contact c2 = zTEST_Shared.noinsertContact(u.Id, a.Id);
        c2.RecordTypeId = TF_CONTACTS_RT;
        c2.Email = 'test@example.com';
        c2.optin_optout_status__c = 'Explicit Opt-In';
        c2.optin_optout_source__c = 'CATS';
        insert c2;
    }
}