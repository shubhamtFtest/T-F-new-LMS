//Trigger Class: Trig_Opp_PrimaryOcrRequiredToCloseWon.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project

public without sharing class Trig_Opp_PrimaryOcrRequiredToCloseWon implements TriggerInterface_Opp.Runnable {
	public void run(TriggerInterface_Opp.Trig trig) {
		if (trig.isBefore && trig.isUpdate) {
			Set<Id> oppIdsToCheck = new Set<Id>();
			for (Integer i=0; i < trig.triggerSize; i++) {
				if (!trig.oldList[i].IsWon && trig.newList[i].IsWon)
					oppIdsToCheck.add(trig.newList[i].Id);
			}
			if (oppIdsToCheck.size() > 0) {
				//Check for Primary Contact in OCR
	            List<OpportunityContactRole> ocrs = [SELECT Id, OpportunityId
	                                                   FROM OpportunityContactRole
	                                                   WHERE OpportunityId IN :oppIdsToCheck
	                                                     AND IsPrimary = TRUE];
				Set<Id> oppIdsWithPrimaryContact = new Set<Id>();
				for (OpportunityContactRole ocr : ocrs) {
					oppIdsWithPrimaryContact.add(ocr.OpportunityId);
				}
				for (Integer i=0; i < trig.triggerSize; i++) {
					if (oppIdsToCheck.contains(trig.newList[i].Id) && !oppIdsWithPrimaryContact.contains(trig.newList[i].Id))
						trig.newList[i].addError('Primary Contact is required before moving your opportunity to Closed Won.');    
		        }
			}		
		}
    }
}