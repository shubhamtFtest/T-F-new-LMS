/*
* Tested by: zTEST_ExchangeRates.cls    100%
*
* Modified by Hailey Niemand - 2013.08.09 - CHG0048108 - Rename T&F Opportunity Record Types
* Modified by Jeff Lup - 2015.03.04 - Moved Trigger into this Class
*/
public without sharing class OLI_UpdateCurrencies_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            Set<Id> oppIds = new Set<Id>();
            for (OpportunityLineItem oli : trig.newList) {
                oppIds.add(oli.OpportunityId);
            }
            if (oppIds.size() > 0) {
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
                    
                Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([SELECT Id, Volume_Year__c, CloseDate, CurrencyIsoCode FROM Opportunity WHERE Id IN :oppIds]);
                
                for (Integer i = 0; i < trig.triggerSize; i++) {  
                    system.debug(trig.newList[i]);
                    Decimal oldAmt = trig.newList[i].UnitPrice * trig.newList[i].Quantity; //TotalPrice is not correct until after the trigger has fired
    				
                    //String oldCurrency = trig.newList[i].CurrencyIsoCode; //sometimes (and in prod only) this takes on the currency of the Owner, not the Opp, until after the save, which is too late
                    String oldCurrency = mapOpps.get(trig.newList[i].OpportunityId).CurrencyIsoCode;
    
                    Double oldRate = 0;
                    String yyyy;
                    
                    if (trig.mapRtIdsToParams.get(trig.newList[i].OpportunityRecordtypeId__c).get('year') == 'volumeyear') 
                        yyyy = mapOpps.get(trig.newList[i].OpportunityId).Volume_Year__c;
                    else
                        yyyy = String.valueOf(mapOpps.get(trig.newList[i].OpportunityId).CloseDate.Year());
                    
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
                                trig.newList[i].TotalPrice_AUD__c = oldAmt * (mapYearToRate.get(yyyy).AUD__c/oldRate);
                                trig.newList[i].TotalPrice_EUR__c = oldAmt * (mapYearToRate.get(yyyy).EUR__c/oldRate);
                                trig.newList[i].TotalPrice_GBP__c = oldAmt * (mapYearToRate.get(yyyy).GBP__c/oldRate);
                                trig.newList[i].TotalPrice_USD__c = oldAmt * (mapYearToRate.get(yyyy).USD__c/oldRate);
                            }   
                        }
                    }
                }
            }
            
            
            
        }
    }        
}