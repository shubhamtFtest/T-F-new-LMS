/*
  Tests: TF_UpdateOpportunityPercentage
 
*/

@isTest
private class zTEST_TF_UpdateOpportunityInvoiceStatus {

    static testMethod void test1() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.RecordTypeId = devRecordTypeId;
        opp.AccountId = acc.Id;
        opp.StageHistory__c = 'Request Quote';
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = TRUE;
        opp.Stage_Date__c = System.today();
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityInvoiceStatus var = new TF_UpdateOpportunityInvoiceStatus();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
    
    
    static testMethod void test2() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.RecordTypeId = devRecordTypeId;
        opp.AccountId = acc.Id;
        opp.StageHistory__c = 'Quote in Progress';
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = TRUE;
        opp.Stage_Date__c = System.today();
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityInvoiceStatus var = new TF_UpdateOpportunityInvoiceStatus();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
    
    static testMethod void test3() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.RecordTypeId = devRecordTypeId;
        opp.AccountId = acc.Id;
        opp.StageHistory__c = 'Quotation';
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = TRUE;
        opp.Stage_Date__c = System.today();
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityInvoiceStatus var = new TF_UpdateOpportunityInvoiceStatus();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
    
    static testMethod void test4() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.RecordTypeId = devRecordTypeId;
        opp.AccountId = acc.Id;
        opp.StageHistory__c = 'Request Invoice';
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = TRUE;
        opp.Stage_Date__c = System.today();
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityInvoiceStatus var = new TF_UpdateOpportunityInvoiceStatus();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
    
    static testMethod void test5() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.RecordTypeId = devRecordTypeId;
        opp.AccountId = acc.Id;
        opp.StageHistory__c = 'Invoice in Progress';
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = TRUE;
        opp.Stage_Date__c = System.today();
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityInvoiceStatus var = new TF_UpdateOpportunityInvoiceStatus();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
}