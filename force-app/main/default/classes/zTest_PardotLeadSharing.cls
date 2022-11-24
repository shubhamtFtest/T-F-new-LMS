/*
 * 
 * Test class for Process Builder - Pardot Lead Sharing
 * Created by: Matthew Smith 2020.08.10
 * 
 */ 
@isTest
public class zTest_PardotLeadSharing {
    
    @isTest
    private static void leadCreation(){
        RecordType recordTypeNameLead = [SELECT Name FROM recordtype WHERE sObjectType = 'Lead' and Name = 'T&F - Leads'];
		boolean pardotSharingChecked = false;
        
        Lead leadsForensicLead = new Lead();
        leadsForensicLead.RecordTypeId = recordTypeNameLead.Id;
        leadsForensicLead.FirstName = 'Test';
        leadsForensicLead.LastName = 'Lead';
        leadsForensicLead.Company = 'Test Company';
        leadsForensicLead.Department__c = 'Test Department';
        leadsForensicLead.Email = 'test@test.com';
        leadsForensicLead.Status = 'Open';
        leadsForensicLead.LeadSource = 'Organic';
        leadsForensicLead.Country_List__c = 'United Kingdom';
        leadsForensicLead.Locale__c = 'EMEA';
        leadsForensicLead.Sales_Region__c = 'UK';
        leadsForensicLead.Business__c = 'CAS';
        leadsForensicLead.Course_Start_Date__c = system.today();
        
        insert leadsForensicLead;
        
        Lead loadLeadsForensicNoSharing = [SELECT Shared_with_Pardot__c, Override_Pardot_Sharing__c, RecordTypeId FROM Lead WHERE Id = :leadsForensicLead.Id];
        system.assertEquals(recordTypeNameLead.Id, loadLeadsForensicNoSharing.RecordTypeId); //checking to see if the test lead is using the T&F Lead record type.
        system.assertEquals(false, loadLeadsForensicNoSharing.Shared_with_Pardot__c); //checking to see if the lead is 'Shared with Pardot'. Result should be false.
        
        leadsForensicLead.Lead_Source_Detail__c = 'Lead Forensics';
        update leadsForensicLead; //updating the lead source detail to fire the process builder to check 'Shared with Pardot'
        
        Lead loadLeadsForensicAutoSharing = [SELECT Shared_with_Pardot__c, Override_Pardot_Sharing__c, RecordTypeId FROM Lead WHERE Id = :leadsForensicLead.Id];
        system.assertEquals(true, loadLeadsForensicAutoSharing.Shared_with_Pardot__c); //lead should be shared with pardot.
        
        leadsForensicLead.Lead_Source_Detail__c = '';
        leadsForensicLead.Override_Pardot_Sharing__c = true;
        update leadsForensicLead; //updating the lead source detail to blank and updating the override sharing so it's shared with pardot.
        
		Lead loadLeadsForensicManualSharing = [SELECT Lead_Source_Detail__c, Shared_with_Pardot__c, Override_Pardot_Sharing__c, RecordTypeId FROM Lead WHERE Id = :leadsForensicLead.Id];
        system.assertEquals(true, loadLeadsForensicManualSharing.Shared_with_Pardot__c); //lead should be shared with pardot.
        system.assertEquals(null, loadLeadsForensicManualSharing.Lead_Source_Detail__c); //lead source detail should be blank.
        
    }

}