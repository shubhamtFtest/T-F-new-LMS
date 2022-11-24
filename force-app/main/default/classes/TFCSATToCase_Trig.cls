/*
Created for WCE-4817 : Integrating SurveyGizmo results into Salesforce
Created by Mindtree.com
Created on 22nd August 2017
*/
public class TFCSATToCase_Trig implements TriggerInterface_CSAT.Runnable {
    public void run(TriggerInterface_CSAT.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            List<CSAT__c> csatList = new List<CSAT__c>();
            Set<String> caseNumbers = new Set<String>();
            for(CSAT__c csatRec : trig.newList)
            {
            	if(csatRec.Name != null && csatRec.Name.isNumeric()){
            		csatList.add(csatRec);
                	caseNumbers.add(csatRec.Name);
            	}
            }
            if(csatList.size() > 0){
                TF_CSATHandler.updateCaseOnCSAT(csatList,caseNumbers);
            }
        }
        
        if(trig.isBefore && trig.isUpdate){
        	for(CSAT__c csatRec : trig.newList){
        		if(csatRec.Net_Promotor_Score_NPS__c != trig.oldMap.get(csatRec.Id).Net_Promotor_Score_NPS__c ||
        		csatRec.Customer_Effort_Score_CES__c != trig.oldMap.get(csatRec.Id).Customer_Effort_Score_CES__c ||
        		csatRec.Customer_Satisfaction_CSAT__c != trig.oldMap.get(csatRec.Id).Customer_Satisfaction_CSAT__c ||
        		csatRec.First_Contact_Resolution_FCR__c != trig.oldMap.get(csatRec.Id).First_Contact_Resolution_FCR__c ||
        		csatRec.Agent_Professionalism_AP__c != trig.oldMap.get(csatRec.Id).Agent_Professionalism_AP__c ||
        		csatRec.Comments__c != trig.oldMap.get(csatRec.Id).Comments__c ||
        		csatRec.Followup_Email__c != trig.oldMap.get(csatRec.Id).Followup_Email__c){
        			csatRec.Survey_Date__c = system.now();
        		}
        		
        	}
        }
        
        if(trig.isAfter && trig.isInsert){
        	Set<Id> csatsToBeDeleted = new Set<Id>();
        	for(CSAT__c csatRec : trig.newList){
	        	if(csatRec.Case__c == null){
	        		csatsToBeDeleted.add(csatRec.Id);
	        	}
        	}
        	if(csatsToBeDeleted.size() > 0){
        		TF_CSATHandler.deleteCSATRecords(csatsToBeDeleted);
        	}
        }
    }
}