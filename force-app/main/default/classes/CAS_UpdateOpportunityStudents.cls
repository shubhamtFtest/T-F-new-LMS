/**************************************************
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
* moved to a class, called by Opp_Trigger, by Jeff Lup
**************************************************/

public class CAS_UpdateOpportunityStudents {
/*
	public void CAS_UpdateOpportunityStudents(Opportunity oppNew, Opportunity oppOld) {
		if (oppOld.Number_of_Students__c != oppNew.Number_of_Students__c) {
			// update the quanity on line items that have a quantity greater than or equal to 1
            List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
			for (OpportunityLineItem oli : [Select Id, Quantity, UnitPrice
											From OpportunityLineItem
											Where OpportunityId = :oppNew.Id
												And Quantity >= 1]) {
				oli.Quantity = oppNew.Number_of_Students__c;                    
                oliToUpdate.add(oli);
            }
            if (oliToUpdate.size() > 0)
            	update oliToUpdate;
        }   
	}
*/
}