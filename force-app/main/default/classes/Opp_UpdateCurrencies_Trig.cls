/*
* Tested by: zTEST_ExchangeRate     100%
*
* Modified by Hailey Niemand - 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Modified by Jeff Lup - 2015.04.23 - moved into this TrigClass
* Modified by Jeff Lup - 2015.11.12 - support for SEK
*/
public without sharing class Opp_UpdateCurrencies_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.triggerSize == 1) { //if not bulk, do it now. else use batch below
                Boolean isVolumeYear = (trig.mapRtIdsToParams.get(trig.newList[0].RecordtypeId).get('year') == 'volumeyear' ? true : false);
                
                if ((isVolumeYear && trig.newList[0].Volume_Year__c != trig.oldList[0].Volume_Year__c)
                || (!isVolumeYear && trig.newList[0].CloseDate.Year() != trig.oldList[0].CloseDate.Year())) {
        
                    List<OpportunityLineItem> olis = [SELECT Id, TotalPrice, OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :trig.newList[0].Id];
                    if (olis.size() > 0) {
        
                        List<Exchange_Rate__c> rates = [SELECT Year__c, AUD__c, EUR__c, GBP__c, USD__c, SEK__c
                                                        FROM Exchange_Rate__c];     
                                              
                        Map<String, Exchange_Rate__c> mapYearToRate = new Map<String, Exchange_Rate__c>();
                        String maxYear = '0'; String minYear = '9999';
                        for (Exchange_Rate__c rate : rates) {
                            mapYearToRate.put(rate.Year__c, rate);
                            if (rate.Year__c > maxYear)
                                maxYear = rate.Year__c;
                            if (rate.Year__c < minYear)
                                minYear = rate.Year__c;
                        }
                        
                        List<OpportunityLineItem> olisToUpdate = new List<OpportunityLineItem>();
                        for (OpportunityLineItem oli : olis) {
                            Decimal oldAmt = oli.TotalPrice;
                            String oldCurrency = trig.newList[0].CurrencyIsoCode;
                            Double oldRate = 0;
                            String yyyy;
                            if (isVolumeYear)
                                yyyy = trig.newList[0].Volume_Year__c;
                            else
                                yyyy = String.valueOf(trig.newList[0].CloseDate.Year());
        
                            if (yyyy != null && yyyy != '') {
                                if (yyyy > maxYear)
                                    yyyy = maxYear;
                                else if (yyyy < minYear)
                                    yyyy = minYear;
                                            
                                if (mapYearToRate.get(yyyy) != null) {
                                    if (oldCurrency == 'AUD')
                                        oldRate = mapYearToRate.get(yyyy).AUD__c;
                                    else if (oldCurrency == 'EUR')
                                        oldRate = mapYearToRate.get(yyyy).EUR__c;
                                    else if (oldCurrency == 'GBP')
                                        oldRate = mapYearToRate.get(yyyy).GBP__c;
                                    else if (oldCurrency == 'USD')
                                        oldRate = mapYearToRate.get(yyyy).USD__c;
                                    else if (oldCurrency == 'SEK')
                                        oldRate = mapYearToRate.get(yyyy).SEK__c;
            
                                    if (oldRate > 0) {
                                        oli.TotalPrice_AUD__c = oldAmt * (mapYearToRate.get(yyyy).AUD__c/oldRate);
                                        oli.TotalPrice_EUR__c = oldAmt * (mapYearToRate.get(yyyy).EUR__c/oldRate);
                                        oli.TotalPrice_GBP__c = oldAmt * (mapYearToRate.get(yyyy).GBP__c/oldRate);
                                        oli.TotalPrice_USD__c = oldAmt * (mapYearToRate.get(yyyy).USD__c/oldRate);
                                        olisToUpdate.add(oli);
                                    }
                                }
                            }
                        }
                        if (olisToUpdate.size() > 0)
                            update olisToUpdate;
                    }
                }
            } else { //if bulk, fire ExchangeRate_UpdateOlis.trigger, to do it with Batch Apex
                Set<String> yearsToUpdate = new Set<String>();
                for (Integer i = 0; i < trig.triggerSize; i++) {
                    if (trig.mapRtIdsToParams.get(trig.newList[i].RecordtypeId).get('year') == 'volumeyear' && trig.newList[i].Volume_Year__c != trig.oldList[i].Volume_Year__c) {
                        if (trig.oldList[i].Volume_Year__c != null && trig.oldList[i].Volume_Year__c.isNumeric())
                            yearsToUpdate.add(trig.oldList[i].Volume_Year__c);
                    }
                    if (trig.mapRtIdsToParams.get(trig.newList[0].RecordtypeId).get('year') == 'closedate' && trig.newList[i].CloseDate.Year() != trig.oldList[i].CloseDate.Year()) {
                        if (trig.oldList[i].CloseDate != null)
                            yearsToUpdate.add(String.valueOf(trig.oldList[i].CloseDate.Year()));
                    }
                }
                if (yearsToUpdate.size() > 0) {
                    List<Exchange_Rate__c> rates = [SELECT Id, AUD__c, EUR__c, GBP__c, USD__c, SEK__c, Year__c FROM Exchange_Rate__c WHERE Year__c IN :yearsToUpdate];
                    for (Exchange_Rate__c rate : rates) {
                        update rate; //fire ExchangeRate_UpdateOlis.trigger
                    }
                }
            }           
        }
    }
}