trigger TFOAC_RelationshipTrigger on TFOAC_Relationship__c (before insert,before update) {
	TFOAC_RelationshipTriggerClass.setHostArea(Trigger.New);    
}