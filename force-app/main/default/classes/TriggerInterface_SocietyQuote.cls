public with sharing class TriggerInterface_SocietyQuote {
    public interface Runnable {
        void run(TriggerInterface_SocietyQuote.Trig trig);
    }
    public class Trig {
        public List<Society_Quote__c> oldList;
        public List<Society_Quote__c> newList;
        public Map<Id,Society_Quote__c> oldMap;
        public Map<Id,Society_Quote__c> newMap;
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