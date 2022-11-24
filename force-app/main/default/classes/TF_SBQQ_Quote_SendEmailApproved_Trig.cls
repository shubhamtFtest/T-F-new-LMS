public with sharing class TF_SBQQ_Quote_SendEmailApproved_Trig implements TriggerInterface_SBQQ_Quote.Runnable {     
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {         
        if(trig.isUpdate && trig.isAfter) {             
            Set<Id> lstId = new Set<Id>();
            List<SBQQ__Quote__c> qutObjList = new List<SBQQ__Quote__c>();           
            for(SBQQ__Quote__c qutObj : trig.newList){                  
                if(((qutObj.CSD_Approval_Status__c == 'Approved') || (qutObj.CSD_Approval_Status__c == 'Automatic Approval'))&& (qutObj.Author_Status__c == 'Accepted') && (qutObj.Sent_PDF_email__c == False) && (qutObj.SBQQ__NetAmount__c > 0) && qutObj.Entry_Point__c != 'Submission Portal'){                     
                    lstId.add(qutObj.Id);   
                    qutObjList.add(new SBQQ__Quote__c(id=qutObj.Id, Sent_PDF_email__c=True));               
                }              
            }                      
            
            if(!lstId.isEmpty()){                
                TF_SendEmailApprovedQuoteToAuthor.send(lstId);        
                UPDATE qutObjList;     
            }         
        }     
    } 
}