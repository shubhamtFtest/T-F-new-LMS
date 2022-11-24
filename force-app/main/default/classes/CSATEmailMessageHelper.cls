/**************************************************
* Created by: Tom Reed: 2018-11-05
* Tested by: zTest_CSATSurveyAutomation @ 100%
**************************************************/
global class CSATEmailMessageHelper implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug(email.toAddresses);
        
        String settingRecordId = [SELECT Id FROM Setting__c WHERE Name = 'CSATSurveyRules' LIMIT 1].Id;
        
        Map<String, Setting_Item__c> existingValueToRecordMap = new Map<String, Setting_Item__c>();
        for(Setting_Item__c s: [SELECT Id, Setting__c, Text_1__c, Text_2__c
                                FROM Setting_Item__c WHERE Setting__r.Name = 'CSATSurveyRules'
                                AND Text_1__c = 'Email' AND Text_4__c = 'External Survey']){
                                    existingValueToRecordMap.put(s.Text_2__c, s); 
                                }
        
        List<Setting_Item__c> settingItemsToUpsert = new List<Setting_Item__c>();
        for(String s: email.toAddresses){
            if(existingValueToRecordMap.containskey(s)){
            Setting_Item__c settingItemToUpdate = existingValueToRecordMap.get(s);
            settingItemToUpdate.Text_3__c = String.ValueOf(system.today());
            settingItemsToUpsert.add(settingItemToUpdate);
            } else {
            Setting_Item__c newSettingItem = new Setting_Item__c();
            newSettingItem.Setting__c = settingRecordId;
            newSettingItem.Text_1__c = 'Email';
            newSettingItem.Text_2__c = s;
            newSettingItem.Text_3__c = String.ValueOf(system.today());
            newSettingItem.Text_4__c = 'External Survey';
            newSettingItem.Text_5__c = 'Exact Match';
            settingItemsToUpsert.add(newSettingItem);    
            }
        }
        
        if(settingItemsToUpsert.size()>0){
            upsert settingItemsToUpsert;  
        }
        return result;
    }
    
}