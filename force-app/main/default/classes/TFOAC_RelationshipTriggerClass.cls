public with sharing class TFOAC_RelationshipTriggerClass {

	public static void setHostArea(List<TFOAC_Relationship__c> newRelationshipd){
        for(TFOAC_Relationship__c rel : newRelationshipd){    
            	rel.Host_Area_Text__c = TFOAC_OpportunityTriggerClass.getHostAreaTextField(rel.Host_Area__c); 
            	rel.OpportunityNDAStatus__c = rel.OpportunityNDAStatusFromula__c;
        }
    }
}