/*
  Tests: TF_UpdateOpportunityPercentage
 
*/

@isTest
private class zTEST_TF_UpdateOpportunityPercentage {

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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Prospect';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
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
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CIS Opportunities');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
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
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CIS Opportunities');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Closed Lost';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
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
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CIS Opportunities');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Acceptance';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
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
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test6() {
        
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
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test7() {
        
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
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test8() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test9() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Price Agreement)');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }


    static testMethod void test10() {
        
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
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test11() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - One-Off Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test12() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Price Agreement)');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test13() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test14() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test15() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Direct)');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test16() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Direct)');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test17() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test18() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Investigating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test19() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test20() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CIS Opportunities');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test21() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Direct)');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test22() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Negotiation';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test23() {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        acc.Classification__c = 'Other';
        acc.Mailing_Country_List__c = 'United Kingdom';
        acc.Locale__c = 'EMEA';
        acc.Sales_Region__c = 'Africa';
        acc.Shipping_Country_List__c = 'United Kingdom';
        insert acc;
        
        Id devRecordTypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CIS Opportunities');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }

    static testMethod void test24() {
        
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
        opp.RecordTypeId = devRecordTypeId;
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.LeadSource = 'Direct';
        opp.CloseDate = System.Today();
        opp.StageName = 'Evaluating';
        opp.StageHistory__c = 'Request Quote';
        opp.Course_Start_Date__c = System.Today();
        opp.Number_of_Students__c =1;
        opp.Stage_Probability_Flag__c = False;
        insert opp;
        
        Test.StartTest();
            TF_UpdateOpportunityPercentage var = new TF_UpdateOpportunityPercentage();
            Database.executeBatch(var);
        Test.StopTest();
    
    }
    
    
}