/*Created By: Piyush Jain
 *Description: Used to send SNS message on Quote Updation in SF as part of FSD Project
 *Test Class: SNSServiceFSDTest
**/
public class SNSServiceQuote_Trigger implements TriggerInterface_SBQQ_Quote.Runnable{
    private static boolean run1 = true;
    public static boolean runOnce1(){
        System.debug('@runonce@'+ run1);
        if(run1){
            run1=false;
            return true;
        }
        else{
            return run1;
        }
    }
    
    public void run(TriggerInterface_SBQQ_Quote.Trig trig){
        System.debug('@@@@@Trigger SNSServiceQuote_Trigger start');
        Set<Id> quoteIdSet = new Set<Id>();
        List<SBQQ__Quote__c> oldQuoteList = new List<SBQQ__Quote__c>();
        oldQuoteList = trig.oldList;
        System.debug('@@@Status old'+trig.oldMap);
        System.debug('@@@Status New'+trig.newMap);
        System.debug('@@@Status old'+trig.oldList);
        System.debug('@@@Status New'+trig.newList);
        
        Map<Id,SNSServiceQuote_Handler.RequestBody> messageBodyMap = new Map<Id,SNSServiceQuote_Handler.RequestBody>();
        for (SBQQ__Quote__c q : trig.newList){
            quoteIdSet.add(q.Id);
            System.debug('q.id =====>' + q.id);
        }
        
            
    	if(runOnce1()){
            if(trig.isAfter && trig.isupdate && !system.isFuture() && !System.isQueueable()){
                System.debug('@@@Status oldfsd'+trig.oldMap);
                System.debug('@@@Status Newfsd'+trig.newMap);
                System.debug('@@@@@Inside Trigger');
                SNSServiceQuote_Handler.processRequest(quoteIdSet,trig.oldMap,trig.newMap);
            }
            
        }
    
    }
}