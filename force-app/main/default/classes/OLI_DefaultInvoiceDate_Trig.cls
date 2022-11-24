/* Tested by: zTEST_DefaultOliInvoiceDate   100%
*
* Modified by Jeff Lup - 2015.03.03 - Moved Trigger into this Class
*/

public without sharing class OLI_DefaultInvoiceDate_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            Boolean needsUpdate = false;
            for (Integer i=0; i<trig.triggerSize; i++) {
                if (trig.newList[i].Invoice_Date__c == null) //Pick & Mix will have a value, because it is required on the page layout
                    needsUpdate = true;
            }
            if (needsUpdate) {
                Opportunity opp = [SELECT CloseDate, StageName FROM Opportunity WHERE Id = :trig.newList[0].OpportunityId];
                if (opp.StageName == 'Closed Won') {
                    for (Integer i=0; i<trig.triggerSize; i++) {
                        if (trig.newList[i].Invoice_Date__c == null) 
                            trig.newList[i].Invoice_Date__c = opp.CloseDate;
                    }
                }
            }
        }
    }
}