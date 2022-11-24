/* Tests: EmailPreferenceController		100%
*/

@isTest
private class zTEST_EmailPreferenceController {
    static testMethod void EmailPreferenceController_testLeadNoEP() {
        User u = zTEST_Shared.insertUser();
        Id TF_LEAD_RT = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.RecordtypeId = TF_LEAD_RT;
        l.Email = 'test@example.com';
        insert l;
		
        //Setup a reference to the page the controller is expecting with the parameters
        PageReference pRef = Page.EmailPreference;
        pRef.getParameters().put('lId', l.id);
        pRef.getParameters().put('email', l.email);
        Test.setCurrentPage(pRef);
        
        //Construct the controller class 
        EmailPreferenceController con = new EmailPreferenceController();
        con.emailPreference.Status__c = 'Unsubscribed';
        con.updatePreference();
    }

    static testMethod void EmailPreferenceController_testLeadAndExistingEP() {
        Email_Preference__c ep = new Email_Preference__c();
        ep.Email__c = 'test@example.com';
        ep.Status__c = 'Unsubscribed';
        ep.Reason__c = 'test';
        insert ep;
        
        User u = zTEST_Shared.insertUser();
        Id TF_LEAD_RT = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.RecordtypeId = TF_LEAD_RT;
        l.Email = 'test@example.com';
        insert l;
		
        //Setup a reference to the page the controller is expecting with the parameters
        PageReference pRef = Page.EmailPreference;
        pRef.getParameters().put('lId', l.id);
        pRef.getParameters().put('email', l.email);
        Test.setCurrentPage(pRef);        
        //Construct the controller class 
        EmailPreferenceController con = new EmailPreferenceController();
        con.emailPreference.Status__c = 'Unsubscribed';
        con.updatePreference();
    }
    
    static testMethod void EmailPreferenceController_testContact() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id TF_CONTACT_RT = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
        c.RecordTypeId = TF_CONTACT_RT;
        c.Email = 'test@example.com';
        insert c;
		
        //Setup a reference to the page the controller is expecting with the parameters
        PageReference pRef = Page.EmailPreference;
        pRef.getParameters().put('cId', c.id);
        pRef.getParameters().put('email', c.email);
        Test.setCurrentPage(pRef);
        //Construct the controller class 
        EmailPreferenceController con = new EmailPreferenceController();
        con.emailPreference.Status__c = 'Unsubscribed';
        con.updatePreference();
    }
    
    static testMethod void EmailPreferenceController_testNoEmail() {
        //Setup a reference to the page the controller is expecting with the parameters
        PageReference pRef = Page.EmailPreference;
        Test.setCurrentPage(pRef);
        //Construct the controller class 
        EmailPreferenceController con = new EmailPreferenceController();
        con.cancelUpdate();
    }
}