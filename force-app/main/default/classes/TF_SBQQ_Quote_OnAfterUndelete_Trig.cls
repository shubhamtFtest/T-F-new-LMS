public with sharing class TF_SBQQ_Quote_OnAfterUndelete_Trig implements TriggerInterface_SBQQ_Quote.Runnable {
	public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if(trig.isUnDelete && trig.isAfter) {
            Set<Id> quoteIdSet = new Set<Id>();
	        Set<Id> accountIdSet = new Set<Id>();
	        for(SBQQ__Quote__c quoteObj : trig.newList) {
	            if(quoteObj.sbqq__account__c != null) {
	                quoteIdSet.add(quoteObj.id);
	                accountIdSet.add(quoteObj.SBQQ__Account__c);
	            }
	        }
	        if(!quoteIdSet.isEmpty()) {
	            TF_SBQQ_Quote_Utils.createPrepayTransaction(quoteIdSet,accountIdSet);
	        }
        }
    }
}