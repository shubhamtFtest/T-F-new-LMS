/*
Created for WCE-4817 : Integrating SurveyGizmo results into Salesforce
Created by Mindtree.com
Created on 22nd August 2017
Handler class which will perform below activities:
1. Associate correct Case with CSAT based on Case Number
2. If no matching case record found then delete the CSAT record
*/
public class TF_CSATHandler{
	
	public static void updateCaseOnCSAT(List<CSAT__c> csatList, Set<String> caseNumbers){
		
		Map<String,Id> caseNumberMap = new Map<String,Id>();
		Schema.DescribeSObjectResult caseSchema = Schema.SObjectType.Case; 
		Map<String,Schema.RecordTypeInfo> caseRecordTypeInfo = caseSchema.getRecordTypeInfosByName();
		Set<Id> tfRecordTypeIds = new Set<Id>();
		for(String key : caseRecordTypeInfo.keySet())
		{
			if(caseRecordTypeInfo.get(key).getName().contains('T&F')){
				tfRecordTypeIds.add(caseRecordTypeInfo.get(key).getRecordTypeId());
			}
		}
		for(Case caseRec : [Select Id,CaseNumber from Case 
							where CaseNumber IN: caseNumbers
							AND RecordTypeId IN : tfRecordTypeIds]){
			caseNumberMap.put(caseRec.CaseNumber , caseRec.Id);
		}
		
		// Associate CSAT with appropriate Case
		for(CSAT__c csatRec : csatList){
			if(caseNumberMap.size() > 0 && caseNumberMap.containsKey(csatRec.Name)){
				csatRec.Case__c = caseNumberMap.get(csatRec.Name);
				csatRec.Survey_Date__c = system.now();
			}
		}
	}
	
	@future
	public static void deleteCSATRecords(Set<Id> csatIds){
		
		List<CSAT__c> csatsToBeDeleted = new List<CSAT__c>();
		// If Case Number not found then Delete the CSAT record
		for(Id csatId : csatIds){
			CSAT__c csatRec = new CSAT__c(Id = csatId);
			csatsToBeDeleted.add(csatRec);
		}
		if(csatsToBeDeleted.size() > 0){
			try{
				delete csatsToBeDeleted;
			}
			catch(Exception ex){
				system.debug('----Exception----'+ex);
			}
		}
	}

}