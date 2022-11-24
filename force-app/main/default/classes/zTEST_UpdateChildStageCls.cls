@isTest
private class  zTEST_UpdateChildStageCls {

    static testMethod void test_UpdateChildStageCls1() {
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.Type = 'Renewal';
        opp.LeadSource = 'Direct';
        opp.Volume_Year__c = '2018';
        opp.StageName = 'Prospect';
        opp.CloseDate = date.today();
        insert opp;
        
        Test.StartTest();
            UpdateChildStageCls obj = new UpdateChildStageCls();
            UpdateChildStageCls.getDealInformation(opp.Id);
            UpdateChildStageCls.updateStages(opp.Id);
        Test.StopTest();
    }
}