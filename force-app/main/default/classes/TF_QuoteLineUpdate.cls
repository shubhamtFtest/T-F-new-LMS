/*Created By: Piyush Jain
 *Description: Used in FSD discounting flow as part of FSD Project
 *Test Class: ztest_TF_QuoteLineUpdate
**/
public class TF_QuoteLineUpdate implements TriggerInterface_SBQQ_QuoteLine.Runnable{
    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig){
        if(trig.isAfter && trig.isUpdate){
            Id quoteId;
            for (SBQQ__QuoteLine__c qlineObj : trig.newList){
                if(trig.newMap.get(qlineObj.Id).SBQQ__Discount__c==0.00 && 
                   trig.newMap.get(qlineObj.Id).SBQQ__Discount__c!=trig.oldMap.get(qlineObj.Id).SBQQ__Discount__c){
                       quoteId=qlineObj.SBQQ__Quote__c;
                   }
                
            }
            if(!system.isFuture() && quoteId!=null)
                updateQuote(quoteId);
        }
    }
    
    @Future
    public static void updateQuote(String quoteId){
        SBQQ__Quote__c quoteUpdateRecord = new SBQQ__Quote__c();
        quoteUpdateRecord.isFutureHandler__c = false;
        quoteUpdateRecord.Id = quoteId;
        update quoteUpdateRecord;
    }
}