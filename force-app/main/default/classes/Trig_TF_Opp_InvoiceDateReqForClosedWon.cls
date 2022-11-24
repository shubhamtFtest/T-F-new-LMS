public with sharing class Trig_TF_Opp_InvoiceDateReqForClosedWon implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {
        Boolean isBooks;
        Set<Id> EBOOK_RECORDTYPES = new Set<Id>{'0120Y000000Wn9Y','0120Y000000Wn9Z','0120Y000000Wn8Y'}; 
            isBooks = (EBOOK_RECORDTYPES.contains(trig.newList[0].recordTypeID)) ? true : false;
 

            if (trig.newList[0].StageName == 'Closed Won' && trig.oldList[0].StageName != 'Closed Won' && isBooks == true){
                List<OpportunityLineItem> OppLineItemList = [SELECT Id,ProductName__c,Product_Name__c,Invoice_Date__c,Invoice_Number__c From OpportunityLineItem where (Invoice_Date__c = null or Invoice_Number__c =null) and OpportunityId = :trig.newList[0].Id];
                if (OppLineItemList.Size() > 0)
                    trig.newList[0].addError('Your Opportunity contains products with blank Invoice date / Invoice number,Invoice date / Invoice number are mandatory for opportunity to be closed won');
            }
        }
    }
}