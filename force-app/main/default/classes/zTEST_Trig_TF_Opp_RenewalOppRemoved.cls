/*
*    Tests: Trig_TF_Opp_RenewalOppRemoved.class 100%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*/
@isTest
private class zTEST_Trig_TF_Opp_RenewalOppRemoved {
    static testMethod void test_Trig_TF_Opp_RenewalOppRemoved() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        //Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Journals Customer Opportunity (Direct)');
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0031794
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_RenewalOppRemoved', 'Opportunity', 1, 'bd',  recordtypeId, null);   
        Exchange_Rate__c rate = new Exchange_Rate__c();
        rate.Year__c = '2014';
        rate.AUD__c = 1.4;
        rate.EUR__c = 1.2;
        rate.GBP__c = 1;
        rate.USD__c = 1.5;
        insert rate; 
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 1;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 1;
        insert oli;
        Task t = new Task();
        t.WhatId = opp.Id;
        insert t;
        Opportunity opp2 = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        opp.Volume_Year__c = '2014';
        opp.StageName = 'Closed Won';
        opp.Next_Renewal__c = opp2.Id;
        update opp;
        delete opp2;
    }
}