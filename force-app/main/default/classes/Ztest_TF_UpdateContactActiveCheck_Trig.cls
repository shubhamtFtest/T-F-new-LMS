@isTest
global class Ztest_TF_UpdateContactActiveCheck_Trig {
    
    static testMethod void test1() {
        
        
         Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        
        
        Test.StartTest();
        TriggerInterfaceHelper.runTrigger('TF_UpdateContactActiveCheck_Trig', 'Contact', 1, 'bu', contactRecordtypeId, null);
        
        Account  acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Shipping_Country_List__c = 'United States';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'APAC';
        acc.Sales_Region__c = 'Africa';
        insert acc;
        
        
        contact c = new contact();
        c.Status__c = 'Inactive - account unverified';
        c.AccountId = acc.Id;
        c.LastName = 'Test';
        c.Email = 't@g.c';
        c.Mailing_Country_List__c = 'United Kingdom';
        c.Business__c = 'CAS';
        c.LeadSource = 'Agent';
        
        insert c;
        
        c.Status__c = 'Active';
        
        update c;
        
     Test.StopTest();      
        
    }
    
    
}