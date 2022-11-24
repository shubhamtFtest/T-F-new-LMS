/******************************************************************
* Tests: OLI_PrimaryOcrRequired_Trig             100%
*******************************************************************/

@isTest
private class zTEST_OLI_PrimaryOcrRequired_Trig {
	static testMethod void testOLI_PrimaryOcrRequired() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        TriggerInterfaceHelper.runTrigger('OLI_PrimaryOcrRequired_Trig', 'OpportunityLineItem', 99, 'ai', oppRecordtypeId, null);

        try {
        	OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        	oli.Recipient__c = c.Id;
        	insert oli;
        }
        catch(exception e) {
        }
	}
}