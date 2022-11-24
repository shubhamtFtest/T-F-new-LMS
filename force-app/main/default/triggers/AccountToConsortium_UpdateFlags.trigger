trigger AccountToConsortium_UpdateFlags on TandF_Account_to_Consortium__c (after delete, after insert, after undelete, after update) {
	Set<Id> rtsToRun = MiscFunctions.triggerEnabledRecordtypes('AccountToConsortium_UpdateFlags');
	Set<Id> setAccountIds = new Set<Id>();
	for (Integer i=0; i < Trigger.size; i++) {
		if (rtsToRun.contains((Trigger.isDelete ? trigger.old[i] : trigger.new[i]).RecordtypeId)) {
			setAccountIds.add((Trigger.isDelete ? trigger.old[i] : trigger.new[i]).ConsortiumParent__c);
			setAccountIds.add((Trigger.isDelete ? trigger.old[i] : trigger.new[i]).Consortium_Member__c);
		}
	}
	if (setAccountIds.size() > 0) {
		List<TandF_Account_to_Consortium__c> a2as = [SELECT ConsortiumParent__c, Consortium_Member__c
															 FROM TandF_Account_to_Consortium__c
															 WHERE ConsortiumParent__c IN :setAccountIds
															 	OR Consortium_Member__c IN :setAccountIds];
		Set<Id> existingA2CAccountIds = new Set<Id>();
		for (TandF_Account_to_Consortium__c a2a : a2as) {
			existingA2CAccountIds.add(a2a.ConsortiumParent__c);
			existingA2CAccountIds.add(a2a.Consortium_Member__c);
		}
		List<Account> accounts = [SELECT Id, Consortium__c FROM Account WHERE Id IN :setAccountIds];
		for (Account a : accounts) {
			if (existingA2CAccountIds.contains(a.Id))
				a.Consortium__c = true;
			else
				a.Consortium__c = false;
		}
		update accounts;
	}
}