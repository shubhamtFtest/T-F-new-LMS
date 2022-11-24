public with sharing class TriggerInterface_CSAT {
    public interface Runnable {
        void run(TriggerInterface_CSAT.Trig trig);
    }   
    public class Trig {
        public List<CSAT__c> oldList;
        public List<CSAT__c> newList;
        public Map<Id,CSAT__c> oldMap;
        public Map<Id,CSAT__c> newMap;
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