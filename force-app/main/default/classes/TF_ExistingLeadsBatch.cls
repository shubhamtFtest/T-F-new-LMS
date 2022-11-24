// Created By : Shefali Arora on date 09.16.2019
// This Batch class is for updating existing Lead records
// Modified By : Shefali Arora on date 09.23.2019

global class TF_ExistingLeadsBatch implements Database.Batchable<sObject> {
    List<Lead> leadUpdate = new List<Lead>();
    List<String> leadEmail = new List<String>();
    List<Lead> updateLeadStatusList = new List<Lead>();
    
    // Fetching the Lead records that meet the criteria
    global Database.QueryLocator start(Database.BatchableContext BC){
        String queryyy = 'SELECT id, Country_List__c, Status, Email FROM Lead where Country_List__c = \'United States\' AND Status = \'Passed\'';
        return Database.getQueryLocator(queryyy);
        
    }
    global void execute(Database.BatchableContext BC,List<Lead> leadList) {
        if(!leadList.isEmpty()) {
            for(Lead l : leadList){
                leadEmail.add(l.Email);
            }
            // Fetching Contacts from Lead's Email
            Map<String,Contact> contactEmailMap = new Map<String,Contact>();
            for(Contact con : [SELECT id, Email from Contact where Email IN : leadEmail]) {
                contactEmailMap.put(con.Email, con);
                
            }
            for(Lead l : leadList) {
                if(contactEmailMap.containsKey(l.Email)) {
                    l.Status = 'Existing Contact';
                    updateLeadStatusList.add(l);
                }
            }
            if(!updateLeadStatusList.isEmpty())
                update updateLeadStatusList;
        }
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}