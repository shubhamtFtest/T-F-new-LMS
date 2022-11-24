/******************************************************************
* Created by Jeff Lup, 2012.05.07
* Test results as of 2012.05.07...
*   OLI_DefaultContact.trigger              100%
* Modified by Jeff Lup - 2014.06.20 - CHG0058768
* Test results as of 2014.06.20...
*   OLI_DefaultContact.trigger              100%
* Test results as of 2015.03.03...
*   OLI_DefaultContact_Trig.cls             100%
*******************************************************************/

@isTest
private class zTEST_OLI_DefaultContact {
    static testMethod void testOLI_DefaultContact() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        c.Default_Address__c = 'Other'; //CHG0058768
        update c; //CHG0058768
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id); //CHG0058768
        //Test (pick first)
        OpportunityContactRole ocr = zTEST_Shared.insertOpportunityContactRole(opp.Id, c.Id, 'Test');
        ocr.IsPrimary = false;
        update ocr;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        
        //zTEST_Shared.runTrigger('OLI_DefaultContact', oppRecordtypeId); //CHG0058768
        TriggerInterfaceHelper.runTrigger('OLI_DefaultContact_Trig', 'OpportunityLineItem', 99, 'bi', oppRecordtypeId, null);
        
        OpportunityLineItem oli1 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        //Test (pick 'Decision Maker')
        ocr.Role = 'Decision Maker';
        update ocr;
        OpportunityLineItem oli2 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
        //Test (pick primary)
        ocr.IsPrimary = true;
        update ocr;
        OpportunityLineItem oli3 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id);
    }
}