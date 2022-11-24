/*
* Tested by: zTEST_DefaultOliInvoiceDate    100%
*
* Modified by Jeff Lup - 2015.04.21 - Moved into this TrigClass
*/
public without sharing class Opp_DefaultOliInvoiceDate_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.newList[0].StageName == 'Closed Won' && (trig.oldList[0].StageName != 'Closed Won' || trig.newList[0].CloseDate != trig.oldList[0].CloseDate)) {
                    List<OpportunityLineItem> olis = [SELECT Id, Invoice_Date__c
                                                      FROM OpportunityLineItem
                                                      WHERE OpportunityId = :trig.newList[0].Id
                                                        AND PricebookEntry.Product2Id <> '01t60000001q7zXAAQ' //Pick & Mix
                                                        AND Invoice_Date__c <> :trig.newList[0].CloseDate];
                    if (olis.size() > 0) {
                        for (OpportunityLineItem oli : olis) {
                            oli.Invoice_Date__c = trig.newList[0].CloseDate;
                        }
                        update olis;
                    }
                }
            }
        }
    }
}