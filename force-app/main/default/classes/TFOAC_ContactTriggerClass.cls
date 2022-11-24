public with sharing class TFOAC_ContactTriggerClass {
	public static void alignTFAcqusitionContactsToDefaultAccount(List<Contact> newContacts){
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'TFOACContacts' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        TF_Acqusition_Setting__c tfSetting = TF_Acqusition_Setting__c.getOrgDefaults();
        //set default account only for T&F Acqusition record type
        for(Contact c : newContacts){
            if(c.RecordTypeId == rt.get(0).Id){
                c.AccountId = tfSetting.DefaultAccount__c;
            }
        } 
    }
}