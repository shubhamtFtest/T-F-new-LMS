/*
* Test Class:
* Description :
* Created by Siddhant Tyagi
*/
public class reActivateQuoteTriggerHelper implements TriggerInterface_SBQQ_Quote.Runnable{
    
    private static boolean run = true;
    
    public static boolean runOnce1(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public void run(TriggerInterface_SBQQ_Quote.Trig trig){
        if(runOnce1()){
           // Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Automated eBook Direct Sales Orders').getRecordTypeId();
            List<SBQQ__Quote__c> quoteToUpdateIds = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds1 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds2 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds3 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds4 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds5 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds6 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds7 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds8 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds9 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds10 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds61 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds73 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds84 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds95 = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> quoteToUpdateIds103 = new List<SBQQ__Quote__c>();
            for(SBQQ__Quote__c quoteInst : trig.newMap.values()){
                if(trig.oldMap.containskey(quoteInst.Id)){
                    system.debug('quoteInst.SBQQ__Status__c--->'+ quoteInst.SBQQ__Status__c);
                    system.debug('trig.oldMap.get(quoteInst.Id).SBQQ__Status__c--->'+ trig.oldMap.get(quoteInst.Id).SBQQ__Status__c);
                    system.debug('quoteInst.Previous_Record_Type__c--->'+ quoteInst.Previous_Record_Type__c);
                    if(quoteInst.SBQQ__Status__c != 'Expired' && trig.oldMap.get(quoteInst.Id).SBQQ__Status__c == 'Expired' && quoteInst.Previous_Record_Type__c != null){
                        quoteToUpdateIds.add(quoteInst);
                    }
                }
            }
            if(quoteToUpdateIds.size()>0){
                List<SBQQ__Quote__c> quoteToUpdateList = new List<SBQQ__Quote__c>();
                for(SBQQ__Quote__c quoteRec : quoteToUpdateIds){
                    SBQQ__Quote__c quoteInstTemp = new SBQQ__Quote__c();
                    quoteInstTemp.Id = quoteRec.Id;
                    quoteInstTemp.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get(quoteRec.Previous_Record_Type__c).getRecordTypeId();
                    quoteToUpdateList.add(quoteInstTemp);
                }
                update  quoteToUpdateList;
            }
        }  
    }
}