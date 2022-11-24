/******************************************************
* Created by Hailey Niemand, 2015.03.16
*
* Test method for:
*   - TFLeadNotificationEmail.cls  94%
******************************************************/

@isTest

private class zTEST_TFLeadNotificationEmail {   
	static testMethod void test_TFLeadNotificationEmail() {
        Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        
        User u = zTEST_Shared.insertUser('T&F - Journals BU Administrator', 'Taylor & Francis');
        User u2 = zTEST_Shared.insertUser('T&F - Journals BU Administrator', 'Taylor & Francis');
        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.RecordTypeId = leadRtId;
        l.Country_List__c = 'United Kingdom';
        insert l;
        Lead l2 = zTEST_Shared.noinsertLead(u.Id);
        l2.RecordTypeId = leadRtId;
        l2.Country_List__c = 'United Kingdom';
        insert l2;
        Lead l3 = zTEST_Shared.noinsertLead(u2.Id);
        l3.RecordTypeId = leadRtId;
        l3.Country_List__c = 'United Kingdom';
        insert l3;
        TFLeadNotificationEmail t = new TFLeadNotificationEmail();
        t.execute(null);
    }
}