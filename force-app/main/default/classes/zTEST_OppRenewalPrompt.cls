/**
* Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Tests:
*    OppRenewalPromptController.cls     83%
*    OppRenewalPromptLbController.cls   100%
**/
@isTest
private class zTEST_OppRenewalPrompt {

    static testMethod void test_OppRenewalPrompt() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id); //T&F eBooks Consortium Opportunity (Direct) - CHG0048108
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.Family = 'netBase';
        insert p;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 60;
        insert oli;
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id);
        
        PageReference pRef = Page.Opp_RenewalPrompt;
        pRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pRef);

        OppRenewalPromptController con = new OppRenewalPromptController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Start_Date__c = date.today();
        opp.End_Date__c = date.today();
        opp.Renewal_Method__c = 'test';
        update opp;
        
        con = new OppRenewalPromptController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        
        OppRenewalPromptLbController con2 = new OppRenewalPromptLbController();
        con2.yesRenewal();
        con2.noRenewal();
    }
}