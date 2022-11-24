@isTest
private class zTEST_CASBulkSCAssignment {
    
    static testmethod void test_CASBulkSCAssignment() {
        
        List<CAS_Subject_Code__c> subjectCodes = new List<CAS_Subject_Code__c>();
        List<ID> subjectCodeIds = new List<ID>();
        List<Lead> leads = new List<Lead>();
        List<CampaignMember> leadCampaignMembers = new List<CampaignMember>();
        List<Contact> contacts = new List<Contact>();
        List<CampaignMember> contactCampaignMembers = new List<CampaignMember>();
        Integer nbrOfLeads = 10;
        Integer nbrOfContacts = 10;
        Integer nbrOfSubjectCodes = 10;
        
        // create the campaign
        Id campaignRtId = MiscFunctions.getRecordtypeId('Campaign', 'CAS - Data Import Campaign'); //CHG0038379
        Campaign c = new Campaign();
        c.RecordTypeId = campaignRtId;
        c.Name = 'Jeff Test Import Campaign'; 
        Insert c;
        
        Account a = new Account(name='Test');
        insert a;
        
        // create leads and add them to the campaign
        for (Integer i=0;i<nbrOfLeads;i++) {
            Lead lead = new Lead();
            lead.FirstName = 'Test';
            lead.LastName = 'Test '+i;
            lead.Company = 'Test Lead Company for testMe';
            leads.add(lead);
        }
        insert leads;
        
        for (Lead l : [Select Id, Name from Lead where Company = 'Test Lead Company for testMe']) {
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = c.Id; 
            cm.LeadId = l.Id;
            cm.Status = 'Sent';
            leadCampaignMembers.add(cm);
        }
        insert leadCampaignMembers;
        
        // create contacts and add them to the 
        for (Integer k=0;k<nbrOfContacts;k++) {
            Contact contact = new Contact();
            contact.AccountId = a.Id;
            contact.FirstName = 'Test';
            contact.LastName = 'Test for Bulk Assignment testMe';
            contacts.add(contact);  
        }
        insert contacts;
        
        for (Contact contact : [Select Id, Name from Contact where LastName = 'Test for Bulk Assignment testMe']) {
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = c.Id; 
            cm.ContactId = contact.Id;
            cm.Status = 'Sent';
            contactCampaignMembers.add(cm); 
        } 
        insert contactCampaignMembers;
        
        // create some subject codes
        for (Integer j=0;j<nbrOfSubjectCodes;j++) {
            
            CAS_Subject_Code__c sc = new CAS_Subject_Code__c();
            sc.Name = 'Test Code '+j;
            sc.GT_Cat_Code__c = '123'+j;
            
            // add the ids to the subject codes to pass
            subjectCodes.add(sc);
            
        }        
        
        insert subjectCodes; 
        
        for (CAS_Subject_Code__c sc : subjectCodes)
            subjectCodeIds.add(sc.Id);
            
        Test.startTest();
        
        System.debug(CASBulkSCAssignment.assignSubjectCodes(subjectCodeIds,c.Id));
        
        Test.stopTest();
        
        Integer ct = [Select count() From CampaignMember Where CampaignId = :c.Id];
        Integer sclct = [Select count() From CAS_Subject_Code_Lead__c Where Subject_Code__c IN :subjectCodes];
        Integer sccct = [Select count() From CAS_Subject_Code_Contact__c Where Subject_Code__c IN :subjectCodes];
        
        System.assertEquals(subjectCodes.size()*nbrOfContacts,sccct);
        System.assertEquals(subjectCodes.size()*nbrOfLeads,sclct);
        
        System.debug('============================== CampaignId: '+c.Id);  
        System.debug('============================== Campaign Members: '+ct);  
        System.debug('============================== Subject Codes: '+subjectCodes.size());
        System.debug('============================== Subject Codes Lead: '+sclct);
        System.debug('============================== Subject Codes Contact: '+sccct);
        System.debug('============================== Total: '+(sclct+sccct));
        
    }
}