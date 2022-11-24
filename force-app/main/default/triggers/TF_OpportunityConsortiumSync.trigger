trigger TF_OpportunityConsortiumSync on TandF_Account_to_Consortium__c (after delete) {
	list<id> accountIds = new list<id>();
	for (Integer i = 0; i<trigger.size;i++){
		accountIds.add(trigger.old[i].consortium_member__c);
	}
	list<Account_To_Opportunity__c> accConsortiumToRemove =[SELECT Id FROM Account_To_Opportunity__c WHERE Account__c IN :accountIds];
	delete accConsortiumToRemove;
}