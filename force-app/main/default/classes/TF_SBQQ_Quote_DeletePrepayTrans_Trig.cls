public with sharing class TF_SBQQ_Quote_DeletePrepayTrans_Trig implements TriggerInterface_SBQQ_Quote.Runnable {
	public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if(trig.isBefore && trig.isDelete) {
        	    /*****************************************************************
				This method is used to delete Prepay Account Transactions records.
				*****************************************************************/
				List<Prepay_Account_Transactions__c> prepayAccTranst = new List<Prepay_Account_Transactions__c>();
				prepayAccTranst = [select id,Quote_ID__c from Prepay_Account_Transactions__c where Quote_ID__c in :trig.oldList];
				if(!prepayAccTranst.isEmpty()) {
					// Database.delete(prepayAccTranst,false);
					delete prepayAccTranst;
				}
        }
    }
}