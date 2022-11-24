/*
* CAB Ticket #: CHG0037688
*/
public with sharing class TF_SBQQ_Quote_UpdateStatus_Trig  implements TriggerInterface_SBQQ_Quote.Runnable {
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {
            Map<Id, SBQQ__Quote__c> quotesExtended = new Map<Id, SBQQ__Quote__c>([SELECT Payer_Account__r.Prepay_Account_Count__c,Payer_Account__r.Manual_Check__c FROM SBQQ__Quote__c WHERE Id IN :trig.newMap.keySet()]);

            for (SBQQ__Quote__c quoreRec : trig.newList) {
                SBQQ__Quote__c quoteExtended = quotesExtended.get(quoreRec.Id);

                Boolean prepayApprovalConditions = ((quoreRec.Payer_Account__c != null && quoteExtended.Payer_Account__r.Prepay_Account_Count__c > 0 && quoteExtended.Payer_Account__r.Manual_Check__c  == true) || quoreRec.Payer_Contact__c != null) && quoreRec.Use_Prepay_Budget__c == true && quoreRec.Author_Status__c == 'Accepted' && quoreRec.SBQQ__ExpirationDate__c > Date.today() && quoreRec.No_Prepay_Process__c == false;
                Boolean societyApprovalConditions = quoreRec.Society_Manual_Check__c == true && quoreRec.Author_Status__c == 'Accepted' && quoreRec.SBQQ__ExpirationDate__c > Date.today() && quoreRec.No_Society_Process__c == false;
                Boolean mpdlApprovalConditions =((quoreRec.Payer_Account__c !=null && quoreRec.Total_Discounted_Amount__c >1 && quoteExtended.Payer_Account__r.Manual_Check__c  == true) || quoreRec.Payer_Contact__c != null)  && quoreRec.Author_Status__c == 'Accepted' && quoreRec.SBQQ__ExpirationDate__c > Date.today() && quoreRec.No_MPDL_Process__c == false;
                
                if ((quoreRec.Author_Status__c == 'Accepted' && (quoreRec.Use_Prepay_Budget__c== false) && (String.isBlank(quoreRec.CSD_Approval_Status__c) 
                            || (quoreRec.Total_Discounted_Amount__c == 0 && quoreRec.Total_Discount_Percent__c == 0))
                        && prepayApprovalConditions == false && societyApprovalConditions == false && mpdlApprovalConditions == false && quoreRec.Manual_Check__c == false)) {
                    quoreRec.CSD_Approval_Status__c = 'Automatic Approval';
                    quoreRec.Approved_Rejected_Date__c = system.today();
                }else if(quoreRec.Author_Status__c == 'Accepted' && quoteExtended.Payer_Account__r.Manual_Check__c  == false && quoreRec.Manual_Check__c == false){
                    quoreRec.CSD_Approval_Status__c = 'Automatic Approval';
                    quoreRec.Approved_Rejected_Date__c = system.today();
                }
            }
        }
    }

}