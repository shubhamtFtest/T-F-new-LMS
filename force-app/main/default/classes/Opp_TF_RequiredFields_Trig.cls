/*
* Tested by: zTEST_Opp_TF_RequiredFields    100%
*
* Modified by Jeff Lup - 2015.04.21 - moved into this TrigClass
*/
public without sharing class Opp_TF_RequiredFields_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.newList[0].IsWon && !trig.oldList[0].IsWon) { //moving to Closed Won
                    if (trig.newList[0].Fees_Amount_GBP__c != 0) { //There is a fees amount
                        List<OpportunityLineItem> olis = [SELECT UnitPrice, Invoice_Number__c, Invoice_Date__c
                                                          FROM OpportunityLineItem
                                                          WHERE OpportunityId = :trig.newList[0].Id
                                                            AND PricebookEntry.Product2.Service_Description__c != 'Subscription'
                                                            AND UnitPrice > 0
                                                            AND Invoice_Number__c != null
                                                            AND Invoice_Date__c != null
                                                            AND Net_Price__c > 0];
                        if (olis.size() == 0)
                            trig.newList[0].addError('Sales Price, Invoice Number, Invoice Date, and Net Price are required on at least one of your Fees products.');                       
                    }
                }
            }
        }
    }
}