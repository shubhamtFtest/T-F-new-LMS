trigger TFOAC_OACJournalTrigger on TFOAC_Journal__c (after insert,before insert,before update,after update, after delete) {

    if(Trigger.isBefore){

        if(Trigger.isInsert){
            TFOAC_OCAJournalTriggerClass.updateHostAreaText(Trigger.New);
        }else if(Trigger.isUpdate){
            TFOAC_OCAJournalTriggerClass.updateHostAreaText(Trigger.New);
        }

    }
    if(Trigger.isAfter){

        if(Trigger.isInsert){
            TFOAC_OpportunityTriggerClass.checkPublishOfficeProductValidation(Trigger.New);
            TFOAC_OCAJournalTriggerClass.calculateOpportunityAmounts(Trigger.newMap,null);
            
        } else if(Trigger.isUpdate){
            system.debug('trigger was executed');
            TFOAC_OpportunityTriggerClass.checkPublishOfficeProductValidation(Trigger.New);
            TFOAC_OCAJournalTriggerClass.calculateOpportunityAmounts(Trigger.newMap,Trigger.oldMap);
            TFOAC_OpportunityTriggerClass.updateHostAreaForRelationships(Trigger.newMap, Trigger.oldMap);
            
        }else if(Trigger.isDelete){
            system.debug('trigger was executed');
            TFOAC_OCAJournalTriggerClass.calculateOpportunityAmounts(Trigger.oldMap,null);
        }    
    }
	
}