/******************************************************************
* Tests: OLI_UpdateOppStage_Trig             100%
*******************************************************************/

@isTest
private class zTEST_OLI_UpdateOppStage_Trig {
    static testMethod void testOLI_UpdateOppStage() {   
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRecordtypeId, u.Id, a.Id);
        opp.Course_Start_Date__c = date.today();
        update opp;
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();

        TriggerInterfaceHelper.runTrigger('OLI_UpdateOppStage_Trig', 'OpportunityLineItem', 99, 'ai,au,bd', oppRecordtypeId, null);
        
        system.debug('LUP: Inserting OLI 1, Opp should move to Investigating');
        OpportunityLineItem oli1 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        system.assertEquals('Investigating', opp.StageName);
        
        system.debug('LUP: Inserting OLI 2, Opp should move to Acceptance');
        OpportunityLineItem oli2 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Completed - Adopted');
        opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        system.assertEquals('Acceptance', opp.StageName);
        
        system.debug('LUP: Changing Course Start Date to more than 7 days in the past');
        opp.Course_Start_Date__c = date.today().addDays(-10);
        update opp;
        
        system.debug('LUP: Updating OLI 1, Opp should move to Closed Won');
        oli1.Adoption_Stage__c = 'Committee Review';
        update oli1;
        opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        system.assertEquals('Closed Won', opp.StageName);
        
        system.debug('LUP: Deleting OLI 2, Opp should move back to Evaluating');
        delete oli2;
        opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        system.assertEquals('Evaluating', opp.StageName);
    }
}