//Trigger Class: Trig_Opp_TF_StageValidation.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Shefali Arora - 2018.09.17 ,line no: 10,11,14(changed stage name)
//Modified by Jeff Lup - 2018.10.04, changed percentage from 40 to 80
//Modified by Sammy Lewis - 2019.10.15 - 01346544 changed percentage from 80 to 50

public without sharing class Trig_Opp_TF_StageValidation implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            for (Integer i=0; i < trig.triggerSize; i++) {
                if (trig.newList[i].StageName == 'Evaluating' && trig.newList[i].Type == 'Renewal' && (trig.newList[i].Amount_USD__c == null || trig.newList[i].Amount_USD__c == 0)) {
                    trig.newList[i].addError('A renewal opportunity must have products with amounts before being allowed to move to the stage of "Evaluating".');
                } 
                //if (trig.newList[i].Probability > 40 && trig.newList[i].Previous_Renewal__c != null && (trig.isInsert || trig.oldList[i].Probability < 40)) {
                //Quotation was replaced with Evaluating, and Evaluating has a percentage of 80 for eBooks
                //if (trig.newList[i].Probability > 80 && trig.newList[i].Previous_Renewal__c != null && (trig.isInsert || trig.oldList[i].Probability < 80)) {
                if (trig.newList[i].Probability > 50 && trig.newList[i].Previous_Renewal__c != null && (trig.isInsert || trig.oldList[i].Probability < 50)) {
                    trig.newList[i].addError('A renewal opportunity must be at the stage of "Evaluating" before being allowed to move past this stage.');
                } 
                if (trig.newList[i].Order_Type__c == 'Trial' && trig.newList[i].IsClosed && trig.newList[i].IsWon) {
                    trig.newList[i].addError('A "Trial" Opportunity cannot be moved to "Closed Won".  Please change this opportunity\'s Order Type before proceeding.');
                }
            }
        }
    }
}