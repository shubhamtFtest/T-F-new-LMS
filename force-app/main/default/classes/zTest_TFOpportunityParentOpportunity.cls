/**************************************************
* TESTS:
*   TFOpportunityParentOpportunityController 100%
**************************************************/
@isTest
private class zTest_TFOpportunityParentOpportunity {

    static testMethod void Test_TFOpportunityParentOpportunityController() { //positive test adding and changing parent opp value
        User u = zTest_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp2 = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id);
        opp2.Volume_Year__c = '2014';
        insert opp2;
        Opportunity opp3 = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id);
        opp3.Volume_Year__c = '2014';
        insert opp3;
        Opportunity opp4 = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id);
        opp.Volume_Year__c = '2014';
        opp.Parent_Opportunty__c = opp2.Id;
        insert opp;
        PageReference pref = Page.TF_Opportunity_Parent_Opportunity;
        pref.getParameters().put('id',opp.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(opp);  
        TFOpportunityParentOpportunityController ext = new TFOpportunityParentOpportunityController(con);
        List<SelectOption> gettfParentOppOptions = ext.gettfParentOppOptions();
        ext.volYear = null;
        ext.tfParentOpp = null;
        String sTest = ext.tfParentOppName;
        ext.tfParentOppName = null;
        sTest = ext.tfParentOppName;
        List<SelectOption> gettfParentOppOptions2 = ext.gettfParentOppOptions();        
        ext.tfParentOppName = opp3.Name;
        ext.tfParentOpp = opp3.Id;
        ext.isEditMode = null;
        Boolean bTest = ext.isEditMode;
        ext.isDisplayMode = null;
        bTest = ext.isDisplayMode;
        ext.changeParentOpportunity();
        ext.updateParentOpp();
        ext.cancel();
    }  
    
        static testMethod void Test_TFOpportunityParentOpportunityController2() { //negative test - no parent opp value
        User u = zTest_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp4 = zTEST_Shared.insertOpportunity(oppRtId, u.Id);
        PageReference pref = Page.TF_Opportunity_Parent_Opportunity;
        pref.getParameters().put('id',opp4.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(opp4);  
        TFOpportunityParentOpportunityController ext = new TFOpportunityParentOpportunityController(con);
        List<SelectOption> gettfParentOppOptions = ext.gettfParentOppOptions();
        ext.volYear = null;
        ext.tfParentOpp = null;
        String sTest = ext.tfParentOppName;
        ext.tfParentOppName = null;
        sTest = ext.tfParentOppName;
        ext.isEditMode = null;
        Boolean bTest = ext.isEditMode;
        ext.isDisplayMode = null;
        bTest = ext.isDisplayMode;
        ext.changeParentOpportunity();
        ext.updateParentOpp();
        ext.cancel();
    }  
}