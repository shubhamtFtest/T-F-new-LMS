public with sharing class TF_SBQQ_QuoteLine_UpdateSocietyAD_Trig implements TriggerInterface_SBQQ_QuoteLine.Runnable {

    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig) {
        if(trig.isDelete && trig.isAfter) {
            Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            if(!trig.oldList.isEmpty()){
                for(SBQQ__QuoteLine__c quoteLineObj : trig.oldList){
                    //System.debug('*********quoteLineObj.Best_Discount_Rule__c'+quoteLineObj.Best_Discount_Rule__c);
                    quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                    quoteObj.Journal__c = null;
                    if(quoteLineObj.Best_Discount_Rule__c == 'Society'){
                        //quoteObj.Id = quoteLineObj.SBQQ__Quote__c;
                        quoteObj.Society_Manual_Check__c = false;
                        //quoteList.add(quoteObj);
                        //System.debug('*********quoteList'+quoteList);
                    }
                   
                    quoteMap.put(quoteLineObj.SBQQ__Quote__c,quoteObj);
                }
            }
			quoteList = quoteMap.values();
            if(!quoteList.isEmpty()){
                update quoteList;
            }
        }
    }

}