trigger TFOAC_OACOpportunityTrigger on TFOAC_Opportunity__c (before insert, before update) {
    if(Trigger.isInsert){
        TFOAC_OpportunityTriggerClass.checkHostAreaForInsert(Trigger.new);
        TFOAC_OpportunityTriggerClass.checkPublishOfficeValidation(Trigger.new);
    } else if(Trigger.isUpdate){
        TFOAC_OpportunityTriggerClass.checkHostAreaForUpdate(Trigger.newMap, Trigger.oldMap);
        TFOAC_OpportunityTriggerClass.checkPublishOfficeValidation(Trigger.new);
    }
        
}