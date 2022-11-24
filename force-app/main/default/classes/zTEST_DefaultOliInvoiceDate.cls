/**
* Modified by Hailey Niemand 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Tests:
*   OLI_DefaultInvoiceDate_Trig.cls     100%
*   Opp_DefaultOliInvoiceDate_Trig.cls  100%
**/

@isTest
private class zTEST_DefaultOliInvoiceDate {

    static testMethod void myUnitTest() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Consortium Opportunity (Direct)'); //CHG0038379
        
        Opportunity opp = zTEST_Shared.noinsertOpportunity(oppRecordtypeId, u.Id, a.Id); 
        opp.Start_Date__c = date.today();
        insert opp;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.UnitPrice = 100;
        oli.TotalPrice = null;
        oli.Quantity = 1;
        oli.TotalPrice_GBP__c = 60;
        insert oli;
                
        //zTEST_Shared.runTriggersForRecordtypes.put('Opp_DefaultOliInvoiceDate', new Set<Id>{opp.RecordtypeId});
        TriggerInterfaceHelper.runTrigger('Opp_DefaultOliInvoiceDate_Trig', 'Opportunity', 50, 'au', opp.RecordtypeId, null);
        opp.StageName = 'Closed Won';
        opp.Start_Date__c = Date.today();
        opp.End_Date__c = Date.today().addYears(1);
        opp.Renewal_Method__c = 'test';
        update opp;
        
        String opprt = [SELECT OpportunityRecordtypeId__c FROM OpportunityLineItem WHERE Id = :oli.Id].OpportunityRecordtypeId__c; //need because the RT has changed
        //zTEST_Shared.runTriggersForRecordtypes.put('OLI_DefaultInvoiceDate', new Set<Id>{opprt});
        TriggerInterfaceHelper.runTrigger('OLI_DefaultInvoiceDate_Trig', 'OpportunityLineItem', 50, 'bi', opprt, null);
        OpportunityLineItem oli2 = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli2.UnitPrice = 100;
        oli2.TotalPrice = null;
        oli2.Quantity = 1;
        oli2.TotalPrice_GBP__c = 60;
        insert oli2;
    }
}