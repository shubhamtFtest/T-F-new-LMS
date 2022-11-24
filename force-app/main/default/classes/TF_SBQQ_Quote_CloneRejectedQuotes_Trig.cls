public with sharing class TF_SBQQ_Quote_CloneRejectedQuotes_Trig implements TriggerInterface_SBQQ_Quote.Runnable {
	public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if(trig.isUpdate && trig.isAfter) {
        	List<Id> rejectedQuoteId = new List<Id>();
        	for(SBQQ__Quote__c qutObj : trig.newList){
                 if((qutObj.CSD_Approval_Status__c == 'Rejected') && (qutObj.Author_Status__c == 'Accepted')){
                    rejectedQuoteId.add(qutObj.Id);
                 }
             }
        
            if(!rejectedQuoteId.isEmpty()){
               TF_QuoteCloneController.clone(rejectedQuoteId, true);
            }  
        }
    }
}