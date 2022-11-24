/**
* Tests:
*	Contact_UpdateCaseContact_Trig.cls			96%
*	Contact_UpdateCaseContactBatchApex.cls		93%
**/

@isTest
private class zTEST_Contact_UpdateCaseContact {

    static testMethod void test_Contact_UpdateCaseContact_And_BatchApex() {
		Id cseRtId = [SELECT Id FROM Recordtype WHERE SobjectType = 'Case' LIMIT 1].Id;
		Id cRtId = [SELECT Id FROM Recordtype WHERE SobjectType = 'Contact' LIMIT 1].Id;
		//Insert 1 contact for non-batch test
		Case cse = new Case();
		cse.RecordTypeId = cseRtId;
        cse.SuppliedEmail = 'test@example.com';
		insert cse;
		//Insert 2 more contacts for batch apex test
		Case cse1 = new Case();
		cse1.RecordTypeId = cseRtId;
        cse1.SuppliedEmail = 'test2@example.com';
		insert cse1;
		Case cse2 = new Case();
		cse2.RecordTypeId = cseRtId;
        cse2.SuppliedEmail = 'test2@example.com';
		insert cse2;

		User u = zTEST_Shared.insertUser();
		Account a = zTEST_Shared.insertAccount(u.Id);
		
		Setting__c setting = new Setting__c();
		setting.Name = 'RtId Map for Contact_UpdateCaseContact';
		insert setting;
		Setting_Item__c settingItem = new Setting_Item__c();
		settingItem.Setting__c = setting.Id;
		settingItem.Text_2__c = cRtId;
		settingItem.Text_4__c = cseRtId;
		insert settingItem;		 
		
		//zTEST_Shared.runTriggersForRecordtypes.put('Contact_UpdateCaseContact', new Set<Id>{cRtId});
        TriggerInterfaceHelper.runTrigger('Contact_UpdateCaseContact_Trig', 'Contact', 99, 'ai,au', cRtId, null);

		//Contact_UpdateCaseContact.trigger
		Contact c = zTEST_Shared.noinsertContact(u.Id, a.Id);
		c.RecordTypeId = cRtId;
		c.Email = 'test@example.com';
		insert c;

		//Contact_UpdateCaseContactBatchApex.cls
		Contact c2 = zTEST_Shared.noinsertContact(u.Id, a.Id);
		c2.RecordTypeId = cRtId;
		c2.Email = 'test2@example.com';
		insert c2;
		
    }
}