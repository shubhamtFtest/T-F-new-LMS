/*
* Tests: AccountToConsortium_DupeCheck.trigger		100%
*/
@isTest
private class zTEST_AccountToConsortium_DupeCheck {

    static testMethod void test_AccountToConsortium_DupeCheck() {
		User u = zTEST_Shared.insertUser();
		Account a1 = zTEST_Shared.insertAccount(u.Id);
		Account a2 = zTEST_Shared.insertAccount(u.Id);

		Id recordtypeId = MiscFunctions.getRecordtypeId('TandF_Account_to_Consortium__c', 'T&F - Account to Consortium');
		zTEST_Shared.runTrigger('AccountToConsortium_DupeCheck', recordtypeId);
		TandF_Account_to_Consortium__c a2c = new TandF_Account_to_Consortium__c();
		a2c.RecordTypeId = recordtypeId;
		a2c.ConsortiumParent__c = a1.Id;
		a2c.Consortium_Member__c = a2.Id;
		insert a2c;
		
		TandF_Account_to_Consortium__c a2c_dupe = new TandF_Account_to_Consortium__c();
		a2c_dupe.RecordTypeId = recordtypeId;
		a2c_dupe.ConsortiumParent__c = a1.Id;
		a2c_dupe.Consortium_Member__c = a2.Id;
		try {
			insert a2c_dupe;
		} catch (exception e) {
		}
    }
}