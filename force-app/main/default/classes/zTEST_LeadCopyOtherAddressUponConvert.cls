/**
*   Tests: LeadCopyOtherAddressUponConvert_Trig.cls     100%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
**/
@isTest
private class zTEST_LeadCopyOtherAddressUponConvert {
    public static testmethod void testLeadCopyOtherAddressUponConvert() {
        //Id rtId = MiscFunctions.getRecordtypeId('Lead', 'CAS - Leads');
        Id rtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0031794
        
        TriggerInterfaceHelper.runTrigger('LeadCopyOtherAddressUponConvert_Trig', 'Lead', 99, 'au', rtId, null);
        User u = zTEST_Shared.insertUser();
        Lead lead = zTEST_Shared.insertLead(u.Id, rtId);
        lead.Other_City__c = 'test';
        update lead;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }
}