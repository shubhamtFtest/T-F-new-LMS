trigger AccountToConsortium_DupeCheck on TandF_Account_to_Consortium__c (before insert, before update) {
	if (trigger.size == 1) {
		Set<Id> rtsToRun = MiscFunctions.triggerEnabledRecordtypes('AccountToConsortium_DupeCheck');
		if (rtsToRun.contains(trigger.new[0].RecordtypeId)) {
			List<TandF_Account_to_Consortium__c> a2c = [SELECT Id
														FROM TandF_Account_to_Consortium__c
														WHERE ConsortiumParent__c = :trigger.new[0].ConsortiumParent__c
															AND Consortium_Member__c = :trigger.new[0].Consortium_Member__c
															AND Id <> :trigger.new[0].Id];
			if (a2c.size() > 0)
				trigger.new[0].addError('This account is already a member of the consortium.');
		}
	}
}