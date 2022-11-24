/*
*
* Test Class For: OppTerrAssignDefaultLogicFilter
* Created By: Matthew Smith - 11/04/2021 - 01863633
*
*/

@isTest
public class zTest_OppTerrAssignDefaultLogicFilter {
    
    @isTest
    private static void oppTerritoryAssignment() {
        
        //creating test account
        RecordType recordTypeNameAccount = [SELECT Name FROM recordtype WHERE sObjectType = 'Account' AND Name = 'T&F - Accounts'];
        
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeNameAccount.Id;
        testAccount.Name = 'Test Account';
        testAccount.Mailing_Country_List__c = 'New Zealand';
        insert testAccount;
        
        Set<Id> accountListIds = new Set<Id>();
        accountListIds.add(testAccount.Id);
        
        //creating test opportunity
        RecordType recordTypeNameOpportunity = [SELECT Name FROM recordtype WHERE sObjectType = 'Opportunity' AND Name = 'T&F - CAS Opportunity'];
        
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.RecordTypeId = recordTypeNameOpportunity.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.Currency__c = 'USD';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.StageName = 'Prospect';
        testOpportunity.CloseDate = system.Date.today();
        insert testOpportunity;
        
        Opportunity testOpportunity2 = new Opportunity();
        testOpportunity2.RecordTypeId = recordTypeNameOpportunity.Id;
        testOpportunity2.Name = 'Test Opportunity 2';
        testOpportunity2.Currency__c = 'USD';
        testOpportunity2.AccountId = testAccount.Id;
        testOpportunity2.StageName = 'Prospect';
        testOpportunity2.CloseDate = system.Date.today();
        insert testOpportunity2;
        
        Set<Id> opportunityListIds = new Set<Id>();
        opportunityListIds.add(testOpportunity.Id);
        
        Id opportunityId = [Select Id From Opportunity WHERE Name = 'Test Opportunity'].Id;
        Id opportunityId2 = [Select Id From Opportunity WHERE Name = 'Test Opportunity 2'].Id;
        OppTerrAssignDefaultLogicFilter filter = new OppTerrAssignDefaultLogicFilter();


        Map<Id, Id> resultMap = filter.getOpportunityTerritory2Assignments(new List<Id> {opportunityId});
        OppTerrAssignDefaultLogicFilter.Territory2Priority tp = new OppTerrAssignDefaultLogicFilter.Territory2Priority(opportunityId, 1, false);
        OppTerrAssignDefaultLogicFilter.Territory2Priority tp2 = new OppTerrAssignDefaultLogicFilter.Territory2Priority(opportunityId2, 10, true);          
        
        System.assertEquals(1, resultMap.size());
        System.assertEquals(tp.territory2Id, opportunityId);
        System.assertEquals(1, tp.priority);
        System.assertEquals(false, tp.moreTerritoriesAtPriority);
        
    }
    
    

}