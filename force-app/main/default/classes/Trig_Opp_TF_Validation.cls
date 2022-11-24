//Trigger Class: Trig_Opp_TF_Validation.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.12.11 - T&F ERN Project

public with sharing class Trig_Opp_TF_Validation implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            //check if validation is needed
            Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
            for (Integer i=0; i<trig.triggerSize; i++) {
                if (trig.newList[i].StageName == 'Closed Won' && (trig.isInsert || trig.newList[i].StageName != trig.oldList[i].StageName)) {
                    mapOpps.put(trig.newList[i].Id, trig.newList[i]);
                }
                if (trig.isUpdate && trig.newList[i].Product_Family__c != trig.oldList[i].Product_Family__c) {
                    mapOpps.put(trig.newList[i].Id, trig.newList[i]);
                }
            }
            if (mapOpps.size() > 0) {
                //create map of OLIs
                List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, Invoice_Number__c, TotalPrice_USD__c, Product2.Family
                                                  FROM OpportunityLineItem
                                                  WHERE OpportunityId IN :mapOpps.keySet()];
                Map<Id, List<OpportunityLineItem>> mapOppIdToOlis = new Map<Id, List<OpportunityLineItem>>();
                for (OpportunityLineItem oli : olis) {
                    List<OpportunityLineItem> oliList;
                    if (mapOppIdToOlis.containsKey(oli.OpportunityId))
                        oliList = mapOppIdToOlis.get(oli.OpportunityId);
                    else
                        oliList = new List<OpportunityLineItem>();
                    oliList.add(oli);
                    mapOppIdToOlis.put(oli.OpportunityId, oliList);
                }
                //perform validation
                for (Integer i=0; i<trig.triggerSize; i++) {
                    if (trig.newList[i].StageName == 'Closed Won' && (trig.isInsert || trig.newList[i].StageName != trig.oldList[i].StageName)) {
                        if (mapOppIdToOlis.containsKey(trig.newList[i].Id)) {
                            for (OpportunityLineItem oli : mapOppIdToOlis.get(trig.newList[i].Id)) {
                                if (oli.TotalPrice_USD__c <> 0 && (oli.Invoice_Number__c == null || oli.Invoice_Number__c == ''))
                                    trig.newList[i].addError('You may not mark this opportunity Closed Won because it contains non-zero products without an Invoice Number.');  
                            }
                        }                       
                    }
                    if (trig.isUpdate && trig.newList[i].Product_Family__c != trig.oldList[i].Product_Family__c) {
                        if (mapOppIdToOlis.containsKey(trig.newList[i].Id)) {
                            List<OpportunityLineItem> olis2 = mapOppIdToOlis.get(trig.newList[i].Id);
                            for (OpportunityLineItem oli : olis2) {
                                if (oli.Product2.Family != trig.newList[i].Product_Family__c)
                                    trig.newList[i].addError('You may not change the Product Family because this opportunity contains products that belong to a family other than "' + trig.newList[i].Product_Family__c + '".');                      
                            }
                        }
                    }
                }
            }
        }
    }
}