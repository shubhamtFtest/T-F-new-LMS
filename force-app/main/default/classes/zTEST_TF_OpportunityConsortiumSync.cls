/**
*	Tests: TF_OpportunityConsortiumSync.trigger	100%
**/
@isTest
private class zTEST_TF_OpportunityConsortiumSync {
    static testMethod void test_TF_OpportunityConsortiumSync() {
    	User u = zTEST_Shared.insertUser();
    	Account a1 = zTEST_Shared.insertAccount(u.Id);
    	Account a2 = zTEST_Shared.insertAccount(u.Id);

	Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - Journals Consortium Opportunity (Price Agreement)');
    	Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId, u.Id, a1.Id);
    	
    	Account_To_Opportunity__c a2o = new Account_To_Opportunity__c();
    	a2o.Account__c = a2.Id;
    	a2o.Opportunity__c = opp.Id;
    	insert a2o;
    	
        TandF_Account_to_Consortium__c a2c = new TandF_Account_to_Consortium__c();
        a2c.ConsortiumParent__c = a1.Id;
        a2c.Consortium_Member__c = a2.Id;
        insert a2c;
        
        delete a2c;
        
        List<Account_To_Opportunity__c> listA2O = [SELECT Id FROM Account_To_Opportunity__c WHERE Id = :a2o.Id];
        //System.assertEquals(0, listA2O.size());
        
    }
}