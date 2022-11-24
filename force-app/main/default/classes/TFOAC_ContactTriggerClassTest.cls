@isTest
public with sharing class TFOAC_ContactTriggerClassTest {

	public static testMethod void contactDefaultAccountSet(){
        Id contactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('T&F - OAC Contacts').getRecordTypeId();
        User u = zTEST_Shared.insertUser('T&F OAC Standard User', 'T&F OAC');
        
        
        system.runAs(u){
            Account defaultAccount = zTEST_Shared.noinsertAccount(u.id);
            defaultAccount.BillingState = 'UK';
            insert defaultAccount;
            
            TF_Acqusition_Setting__c tfSetting = new TF_Acqusition_Setting__c();
            tfSetting.DefaultAccount__c = defaultAccount.id;
            insert tfSetting;
            
            Contact testContact = new Contact();
            testContact.FirstName = 'Test';
            testContact.LastName = 'User Contact';
            testContact.RecordTypeId = contactRecordType;
            insert testContact;
            
            Contact contactAfterInsert = [Select AccountId From Contact where id =: testContact.id Limit 1];
            system.assertEquals(defaultAccount.id, contactAfterInsert.AccountId);
            //test if default account 
        }
    }
	
}