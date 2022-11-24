/**
*  Tests: LeadConvert_Trig.cls  100%
**/
@isTest
private class zTEST_LeadConvert_Trig {
    static testMethod void test_LeadConvert_Trig() {
       // Id rtId = MiscFunctions.getRecordtypeId('Lead', 'CAS - Leads');
         Id rtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads');
        System.debug('rtId : '+rtId);
        TriggerInterfaceHelper.runTrigger('LeadConvert_Trig', 'Lead', 99, 'au', rtId, 'Business=CAS');
        
        Id icrRtId = MiscFunctions.getRecordtypeId('Informa_Contact_Role__c', 'T&F Contact Roles'); //CHG0038379
        
        TriggerInterfaceHelper.runTrigger('Lead_CreateOpportunityContactRole_Trig', 'Lead', 98, 'au', rtId, '  ICR_RT=' + icrRtId);
        
        //LeadConvert.trigger
        User u = zTEST_Shared.insertUser();
        Lead l = zTEST_Shared.insertLead(u.Id, rtId);
        l.Course_Name__c = 'test';
        update l;
        CAS_Subject_Code__c sc = new CAS_Subject_Code__c();
        sc.GT_Cat_Code__c = 'test';
        sc.Name = 'test';
        insert sc;
        CAS_Subject_Code_Lead__c scl = new CAS_Subject_Code_Lead__c();
        scl.Lead__c = l.Id;
        scl.Subject_Code__c = sc.Id;
        insert scl;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }
}