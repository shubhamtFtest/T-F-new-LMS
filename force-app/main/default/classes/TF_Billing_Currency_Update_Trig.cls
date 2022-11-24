/******************************************************************
   Created Date: 2017/10/18 By Tom Reed
   Test Class: zTest_TF_Billing_Currency_Update
******************************************************************/

public without sharing class TF_Billing_Currency_Update_Trig implements TriggerInterface_Billing.Runnable {
    public void run(TriggerInterface_Billing.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            Id billingRtId = MiscFunctions.getRecordtypeId('Billing__c', 'T&F One-Off Billing');
            Set<Id> oppIds = new Set<Id>();
            
            for (Billing__C b: trig.newList) {
                if (b.RecordTypeid == billingRtId && b.Amount__c != Null) {
                    oppIds.add(b.Opportunity__c);
                }  
            }
            Map<Id,Opportunity> oppCurrencyMap = new Map<Id,Opportunity>([Select Id,CurrencyIsoCode from Opportunity where Id IN: oppIds]);
            for (Billing__C b: trig.newList) {
            	if(oppCurrencyMap.size() > 0 && oppCurrencyMap.containsKey(b.Opportunity__c)){
            		//Set the Billing record currency based upon the Opportunity currency
            		b.CurrencyIsoCode = oppCurrencyMap.get(b.Opportunity__c).CurrencyIsoCode;
            	}
            }
        }
    }
}