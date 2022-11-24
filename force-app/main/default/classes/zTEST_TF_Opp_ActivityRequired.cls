/*
*    Tests: Trig_TF_Opp_ActivityRequired.class 100%
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*/
@isTest
private class zTEST_TF_Opp_ActivityRequired {
    static testMethod void test_TF_Opp_ActivityRequired() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        //Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F eBooks Customer Opportunity (Direct)');
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); //CHG0031794
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ActivityRequired', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
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
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        insert oli;
        opp.Volume_Year__c = '2014';
        update opp;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
    }
}