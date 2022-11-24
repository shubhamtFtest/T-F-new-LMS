/*
* Tests: OLI_CalculateDiscount_Trig.cls     100%
*/
@isTest
private class zTEST_OLI_CalculateDiscount_Trig {
    static testMethod void test_OLI_CalculateDiscount_Trig() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        //Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'IGM New Opportunity');
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Opportunity');
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        TriggerInterfaceHelper.runTrigger('OLI_CalculateDiscount_Trig', 'OpportunityLineItem', 50, 'bi,bu', oppRecordtypeId, null);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.UnitPrice = 100;
        oli.PricebookEntryId = pbe.Id;
        oli.OpportunityId = opp.Id;
        oli.Misc_Discount__c = 10;
        insert oli;
        
        oli.Client_Discount_Percentage__c = 10;
        update oli;
    }
}