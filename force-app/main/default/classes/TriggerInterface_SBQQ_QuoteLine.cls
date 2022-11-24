public with sharing class TriggerInterface_SBQQ_QuoteLine {
    public interface Runnable {
        void run(TriggerInterface_SBQQ_QuoteLine.Trig trig);
    }
    public class Trig {
        public List<SBQQ__QuoteLine__c> oldList;
        public List<SBQQ__QuoteLine__c> newList;
        public Map<Id,SBQQ__QuoteLine__c> oldMap;
        public Map<Id,SBQQ__QuoteLine__c> newMap;
        public Integer triggerSize;
        public Boolean isBefore;
        public Boolean isAfter;
        public Boolean isInsert;
        public Boolean isUpdate;
        public Boolean isDelete;
        public Boolean isUnDelete;
        public Map<Id,Map<String,String>> mapRtIdsToParams;
    }
}