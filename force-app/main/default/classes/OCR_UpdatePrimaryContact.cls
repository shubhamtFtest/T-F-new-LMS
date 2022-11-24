/***************************************************************
* Created by Jeff Lup, 2013-04-08, CHG0049011
*   Called by Opp_RunOcrClasses.page
*   When an OpportunityContactRole is added to an opportunity,
*   update the Opp.Primary_Contact__c with the OCR's primary contact.
****************************************************************/

public with sharing class OCR_UpdatePrimaryContact {
    public static void execute(List<OpportunityContactRole> ocrs) {
        for (OpportunityContactRole ocr : ocrs) {
        	if (ocr.IsPrimary) {
        		Opportunity opp = [SELECT Id, Primary_Contact__c FROM Opportunity WHERE Id = :ocr.OpportunityId];
        		opp.Primary_Contact__c = ocr.ContactId;
        		update opp;
        		return;
        	}
        }
    }
}