/**************************************************
* TESTS:
*   TFOpportunityParentOpportunityController 100%
**************************************************/
@isTest
private class zTEST_TFOpportunityFreeTrials {

    static testMethod void Test_TFOpportunityFreeTrialsController() { //positive test updating Trial Dates and Initiating Trials
        User u = zTest_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 p = [SELECT Name FROM Product2 WHERE Id = :pbe.Product2Id];
        p.ProductCode = 'SUBS';
        update p;
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        insert oli;
        PageReference pref = Page.TFOpportunityFreeTrials;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(opp);  
        TFOpportunityFreeTrialsController ext = new TFOpportunityFreeTrialsController(con);
        ext.doEdit();
        system.assertEquals(ext.isEditMode, true);
        system.assertEquals(ext.firstTrial, true);        
        system.assertEquals(ext.secondTrial, false);
        ext.doCancel();
        ext.doEdit();
        opp.Trial_Start__c = date.today().addDays(6);
        opp.Trial_End__c = date.today().addDays(10);
        opp.Second_Trial_Start__c = date.today().addDays(16);
        opp.Second_Trial_End__c = date.today().addDays(20);
        ext.doSave();
        system.assertEquals(opp.Trial_Start__c, date.today().addDays(6));
        system.assertEquals(opp.Trial_End__c , date.today().addDays(10));
        ext.initiateFirstTrial();
        //system.assertNotEquals(opp.Trial_Id__c, null);
        system.assertEquals(opp.Second_Trial_Start__c, date.today().addDays(16));
        system.assertEquals(opp.Second_Trial_End__c, date.today().addDays(20));
        ext.initiateSecondTrial();
        system.assertNotEquals(opp.Second_Trial_Id__c, null);
        ext.refreshPage();
    }  
    
    static testMethod void Test_TFOpportunityFreeTrialsController2() { //negative test updating and initiating with invalid dates
        User u = zTest_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        opp.Trial_ID__c = '0987';
        update opp;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        Product2 p = [SELECT Name FROM Product2 WHERE Id = :pbe.Product2Id];
        p.ProductCode = 'SUBS';
        update p;
        PageReference pref = Page.TFOpportunityFreeTrials;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(opp);  
        TFOpportunityFreeTrialsController ext = new TFOpportunityFreeTrialsController(con);
        try {
            ext.initiateFirstTrial();
        } catch (exception e) {
        }
        try {
            ext.initiateSecondTrial();
        } catch (exception e) {
        }
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        insert oli;
        ext.doEdit();
        opp.Trial_Start__c = date.today().addDays(6);
        opp.Trial_End__c = date.today().addDays(4);
        try {
            ext.doSave();
        } catch (exception e) {
        }
        opp.Trial_Start__c = date.today().addDays(4);
        opp.Trial_End__c = date.today().addDays(4);
        opp.Second_Trial_Start__c = date.today().addDays(4);
        opp.Second_Trial_End__c = date.today().addDays(4);
        ext.doSave();
        try {
            ext.initiateFirstTrial();
        } catch (exception e) {
        }
        try {
            ext.initiateSecondTrial();
        } catch (exception e) {
        }
        opp.Trial_Start__c = date.today().addDays(6);
        opp.Trial_End__c = date.today().addDays(10);
        opp.Second_Trial_Start__c = date.today().addDays(6);
        opp.Second_Trial_End__c = date.today().addDays(10);
        ext.doSave();      
        ext.initiateFirstTrial();
        ext.initiateSecondTrial();
        ext.doEdit();
        opp.Trial_Start__c = date.today().addDays(3);
        try {
            ext.doSave();
        } catch (exception e) {
        }
        opp.Second_Trial_Start__c = date.today().addDays(3);
        try {
            ext.doSave();
        } catch (exception e) {
        }
    }  
}