/**
* Tests:
*    OppRenewalPrompt_TFJournalsController.cls     82%
*    OppRenewalPromptLb_TFJournalsController.cls   81%
**/
@isTest
private class zTEST_OppRenewalPrompt_TFJournals {

    static testMethod void test_OppRenewalPrompt_TFJournals() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.noinsertAccount(u.Id);
        a.Type = 'Consortium';
        insert a;
        Account a2 = zTEST_Shared.noinsertAccount(u.Id);
        a2.Type = 'Consortium';
        insert a2;
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.Volume_Year__c = '2015';
        insert opp;
        Product2 p2 = zTEST_Shared.insertProduct2();
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.Target_Product__c = p2.Id;
        insert p;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p.Id);
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p2.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 60;
        insert oli;
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id);
        
        insert new Account_To_Opportunity__c(Account__c = a2.Id, Opportunity__c = opp.Id);
        
        PageReference pRef = Page.Opp_RenewalPrompt_TFJournals;
        pRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pRef);

        OppRenewalPrompt_TFJournalsController con = new OppRenewalPrompt_TFJournalsController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Multi_year_deal__c = 'Yes';
        opp.Multi_Year_Deal_Start_Year__c = '2019';
        opp.Multi_Year_Deal_End_Year__c = '2020';
        opp.Opportunity_for_Renewal__c = 'No';
        opp.Reason_No_Renewal__c = 'Test Reason';
        update opp;
        
        con = new OppRenewalPrompt_TFJournalsController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        con.IsDigitalProduct(opp.Id);
        con.IsNonRenewalProduct(opp.Id);
        
        OppRenewalPromptLb_TFJournalsController con2 = new OppRenewalPromptLb_TFJournalsController(new ApexPages.StandardController(opp));
        con2.yesRenewal();
        con2.reasonForNoRenewal = 'test';
        con2.noRenewal();
        con2.oldStage = 'Acceptance';
        con2.cancelClosedWon();
        
    }
    static testMethod void test_OppRenewalPrompt_TFJournals2(){
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.noinsertAccount(u.Id);
        a.Type = 'Consortium';
        insert a;
        Account a2 = zTEST_Shared.noinsertAccount(u.Id);
        a2.Type = 'Consortium';
        insert a2;
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Direct)'); //CHG0038379
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.Volume_Year__c = '2015';
        insert opp;
        Product2 p2 = zTEST_Shared.insertProduct2();
        Product2 p = zTEST_Shared.noinsertProduct2();
        p.Target_Product__c = p2.Id;
        insert p;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p.Id);
        PricebookEntry pbe2 = zTEST_Shared.insertPricebookEntry(Test.getStandardPricebookId(), p2.Id);
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 60;
        insert oli;
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)');
        Opportunity prevOpp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        Opportunity opp1 = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp1.StageName = 'Prospect';
        opp1.Probability = 10;
        opp1.Previous_Renewal__c = prevOpp.Id;
        opp1.Order_Type__c = 'Subscription';
        opp1.Product_Family__c = 'Family 1';
        insert opp1;
        
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id);
        
        insert new Account_To_Opportunity__c(Account__c = a2.Id, Opportunity__c = opp.Id);
        
        PageReference pRef = Page.Opp_RenewalPrompt_TFJournals;
        pRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pRef);

        OppRenewalPrompt_TFJournalsController con = new OppRenewalPrompt_TFJournalsController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        
        opp.StageName = 'Investigating';
        opp.Probability = 100;
        opp.Multi_year_deal__c = 'Yes';
        opp.Multi_Year_Deal_Start_Year__c = '2019';
        opp.Multi_Year_Deal_End_Year__c = '2020';
        opp.Opportunity_for_Renewal__c = 'No';
        opp.Reason_No_Renewal__c = 'Test Reason';
        update opp;
        
        con = new OppRenewalPrompt_TFJournalsController(new ApexPages.StandardController(opp));
        con.getShowPrompt();
        con.IsDigitalProduct(opp.Id);
        
        OppRenewalPromptLb_TFJournalsController con2 = new OppRenewalPromptLb_TFJournalsController(new ApexPages.StandardController(opp));
        con2.yesRenewal();
        con2.reasonForNoRenewal = 'test';
        con2.noRenewal();
        con2.oldStage = 'Acceptance';
        con2.cancelClosedWon();
        
    }
}