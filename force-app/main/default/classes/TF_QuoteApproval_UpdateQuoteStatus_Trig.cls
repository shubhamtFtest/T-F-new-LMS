public with sharing class TF_QuoteApproval_UpdateQuoteStatus_Trig implements TriggerInterface_QuoteApproval.Runnable {
	public void run(TriggerInterface_QuoteApproval.Trig trig) {
        if(trig.isUpdate && trig.isAfter) {
            Set<Id> quoteSet = new Set<Id>();
            for(Quote_Approval__c quoteApp : trig.newList){
               quoteSet.add(quoteApp.Quote__c);
			}
    
           	if(!quoteSet.isEmpty()) {
				List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
		        Integer pendingFlag = 0;
		        Integer rejectFlag = 0;
		        
		        quoteList = [SELECT Id, CSD_Approval_Status__c,
                                (SELECT Id, Name, Approval_Type__c, Approved_Rejected_Date__c, Quote__c, Quote_Approval_Status__c
                                    FROM QuoteApprovals__r)
                            FROM SBQQ__Quote__c WHERE Id IN :quoteSet];
		        
		        for(SBQQ__Quote__c quoreRec : quoteList){
		            pendingFlag = 0;
		            rejectFlag = 0;
		            
		            for(Quote_Approval__c qutApp :quoreRec.QuoteApprovals__r){
		                if(qutApp.Quote_Approval_Status__c == 'Rejected'){
		                    rejectFlag = 1;
		                    break;
		                }
		                
		                if(qutApp.Quote_Approval_Status__c == 'Pending'){
		                    pendingFlag = 1;
		                }
		            }
		            
		            if(rejectFlag == 1){
		               quoreRec.CSD_Approval_Status__c = 'Rejected';
		               quoreRec.Approved_Rejected_Date__c = system.today();
		            } else {
		                 if (pendingFlag == 1) {
		                    quoreRec.CSD_Approval_Status__c = 'Approval Required';
		                    quoreRec.Approved_Rejected_Date__c = null;
		                 }
		                
		                 if (pendingFlag == 0 && rejectFlag == 0) {
		                     quoreRec.CSD_Approval_Status__c = 'Approved';
		                     quoreRec.Approved_Rejected_Date__c = system.today();
		                 }
		            }
		        
		        }  
		        update quoteList;
			}
        }
    }
}