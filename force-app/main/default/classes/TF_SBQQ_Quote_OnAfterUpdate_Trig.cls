/*
* CAB Ticket #: CHG0037688
* Changes: lines 5 - 31, related to CHG0037688
*/
public with sharing class TF_SBQQ_Quote_OnAfterUpdate_Trig implements TriggerInterface_SBQQ_Quote.Runnable {
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if(trig.isUpdate && trig.isAfter) {
            Set<Id> quoteIdSet = new Set<Id>();
            Set<Id> accountIdSet = new Set<Id>();
            Map<Id,Id> oldAccountMap = new Map<Id,Id>();
            for(SBQQ__Quote__c quoteObj : trig.newList) {
                if(quoteObj.Payer_Account__c != null) {
                    quoteIdSet.add(quoteObj.id);
                    accountIdSet.add(quoteObj.Payer_Account__c);
                    //If the account is changed, then delete the prepay account transaction associated with old account
                    if((quoteObj.Payer_Account__c != trig.oldMap.get(quoteObj.id).Payer_Account__c)) {
                        oldAccountMap.put( quoteObj.id,trig.oldMap.get(quoteObj.id).Payer_Account__c);
                    }
                }
              
                
            }
            if(!oldAccountMap.isEmpty()) {
                TF_SBQQ_Quote_Utils.deleteoldAccountPrepayTransaction(oldAccountMap);
            }
            if(!quoteIdSet.isEmpty()) {
                TF_SBQQ_Quote_Utils.createPrepayTransaction(quoteIdSet,accountIdSet);
            }
        }
    }
}