/**************************************************
* Created by Jeff Lup
* jeff.lup@informausa.com / 941-554-3475
**************************************************/

public class CAS_OpportunityUpdateICOwner {
/*
	public void CAS_OpportunityUpdateICOwner (Opportunity oppNew, Opportunity oppOld) {
		if (oppOld.OwnerId != oppNew.OwnerId) {
			// update the quanity on line items that have a quantity greater than or equal to 1
			List<CAS_Inspection_Copy__c> icToUpdate = new List<CAS_Inspection_Copy__c>();
			for (CAS_Inspection_Copy__c ic : [SELECT Id
												FROM CAS_Inspection_Copy__c
												WHERE Opportunity__c = :oppNew.Id]) {
				ic.OwnerId = oppNew.OwnerId;                    
                icToUpdate.add(ic);
			}
            if (icToUpdate.size() > 0)
            	update icToUpdate;
		}
	}
*/
}