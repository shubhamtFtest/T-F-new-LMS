/******************************************************************
* Tests: TF_IRPCloseWonValidation_Trig             100%
*******************************************************************/

@isTest
private class zTEST_TF_IRPCloseWonValidation_Trig {
	static testMethod void testCloseWonValidation() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        TriggerInterfaceHelper.runTrigger('TF_IRPCloseWonValidation_Trig', 'Opportunity', 99, 'bu', oppRecordtypeId, null);

        try {
        	OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        	oli.Recipient__c = c.Id;
        	insert oli;
            //Update opportunity
            opp.StageName = 'Closed Won';
            Update opp; 
            
           //Update opportunity
            opp.StageName = 'Prospect';
            Update opp;            
        }
        catch(exception e) {
        }
	}
}