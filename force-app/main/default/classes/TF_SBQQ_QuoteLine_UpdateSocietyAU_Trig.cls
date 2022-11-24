public with sharing class TF_SBQQ_QuoteLine_UpdateSocietyAU_Trig implements TriggerInterface_SBQQ_QuoteLine.Runnable {

    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig) {
        if(trig.isUpdate && trig.isAfter) {
            Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            if (!trig.newList.isEmpty()) {
                for (SBQQ__QuoteLine__c quoteLineObj : trig.newList) {
                    //System.debug('*********quoteLineObj.Best_Discount_Rule__c'+quoteLineObj.Best_Discount_Rule__c);
                    if (quoteLineObj.Best_Discount_Rule__c == 'Society') {
                        quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                        quoteObj.Society_Manual_Check__c = true;
                        
                        //System.debug('*********quoteList'+quoteList);
                    } else {
                        quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                        quoteObj.Society_Manual_Check__c = false;
                        
                    }
                    quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj);
                }
            }
			 quoteList = quoteMap.values();
            if (!quoteList.isEmpty()) {
                update quoteList;
            }
        }
    }
}