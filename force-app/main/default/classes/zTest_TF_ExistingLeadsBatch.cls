// Created By : Shefali Arora on date 09.16.2019
// This is the test class of "TF_ExistingLeadsBatch"
// Code Coverage : 100%
// Modified By : Shefali Arora on date 09.23.2019

@isTest
public class zTest_TF_ExistingLeadsBatch {
    static testmethod void TF_ExistingLeadsBatch_test() {
        User u = zTEST_Shared.insertUser();
        Lead l = zTEST_Shared.noinsertLead(u.Id);
        l.Email = 'test@gmail.com';
        l.Country_List__c = 'United States';
        l.State_List__c = 'Almeria';
        l.Status = 'Passed';
        insert l;
        
        Account a = zTEST_Shared.insertAccount(u.Id);
        
        Contact c = zTEST_Shared.noinsertContact(u.Id,a.Id);
        c.Email = 'test@gmail.com';
        c.Mailing_Country_List__c = 'United Kingdom';
        c.Business__c = 'CAS';
        c.LeadSource = 'Agent';
        insert c;
        
        if(l.Country_List__c == 'United States' && l.Status == 'Passed') {
            if(l.Email == c.Email) {
                l.Status = 'Existing Contact';
            }
        }
        Test.startTest();
        TF_ExistingLeadsBatch leads_batch = new TF_ExistingLeadsBatch();
        Database.executeBatch(leads_batch);
        Test.stopTest();
    }
}