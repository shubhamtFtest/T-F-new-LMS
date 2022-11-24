/***************************************************************************************
   This handler class is used for TF_QuoteApprovalTrigger trigger.
******************************************************************************************/
public class TF_QuoteApprovalHandler{

    public static void updateQuoteApprovalStatus(Set<Id> quoteSet){    
    
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        Integer pendingFlag = 0;
        Integer rejectFlag = 0;
        
        quoteList = [SELECT id,CSD_Approval_Status__c,(SELECT Id,Name,Approval_Type__c,Approved_Rejected_Date__c,Quote__c,Quote_Approval_Status__c from QuoteApprovals__r) from SBQQ__Quote__c WHERE id in: quoteSet];
        
        for(SBQQ__Quote__c quoreRec :quoteList){
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
            }
            else{
                 if(pendingFlag == 1){
                    quoreRec.CSD_Approval_Status__c = 'Approval Required';
                    quoreRec.Approved_Rejected_Date__c = null;
                 }
                
                 if(pendingFlag == 0 && rejectFlag == 0){
                     quoreRec.CSD_Approval_Status__c = 'Approved';
                     quoreRec.Approved_Rejected_Date__c = system.today();
                 }
            }
        
        }  
        update quoteList;
    }
    
}