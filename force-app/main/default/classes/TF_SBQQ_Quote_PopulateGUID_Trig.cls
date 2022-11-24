public with sharing class TF_SBQQ_Quote_PopulateGUID_Trig implements TriggerInterface_SBQQ_Quote.Runnable {
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {
        if((trig.isInsert && trig.isBefore)){
            for(SBQQ__Quote__c quoteObj : trig.newList){
            quoteObj.randomstring__c = TF_SBQQ_Quote_PopulateGUID.getRandomString(25);
            }
        }
    }
}