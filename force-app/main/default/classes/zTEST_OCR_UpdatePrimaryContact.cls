/******************************************************************
* Created by Jeff Lup, 2013.04.08
* Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Test results as of 2013.04.08...
*   OCR_UpdatePrimaryContact.cls                100%
*   OppTrialEmailController.cls                 83%
*******************************************************************/
@isTest
public with sharing class zTEST_OCR_UpdatePrimaryContact {
    static testMethod void test_OCR_UpdatePrimaryContact() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a.Id);
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
        ocr.IsPrimary = true;
        List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
        ocrs.add(ocr);
        OCR_UpdatePrimaryContact.execute(ocrs);
    } 

    static testMethod void test_OppTrialEmail() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity'); //CHG0038379
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRtId, u.Id, a.Id);
        opp.Primary_Contact__c = c.Id;
        opp.Subs_Amount_GBP__c = 10; //less than total, so fees exist
        opp.Trial_Start__c = system.today().addDays(10);
        opp.CloseDate = system.today();
        opp.Volume_Year__c = '2013';
        opp.Subs_Amount_GBP__c = 1000;
        insert opp;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.UnitPrice = 100;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 100;
        insert oli;
        
        PageReference pRef = Page.OppTrialEmail;
        pRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pRef);
        OppTrialEmailController ext = new OppTrialEmailController(new ApexPages.StandardController(opp));
        ext.sendTrialEmail();
        
            
    } 


}