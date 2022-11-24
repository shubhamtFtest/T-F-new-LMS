public with sharing class TriggerInterface_AccountAffiliation {
    public interface Runnable {
        void run(TriggerInterface_AccountAffiliation.Trig trig);
    }
    public class Trig {
        public List<Account_Affiliation__c> oldList;
        public List<Account_Affiliation__c> newList;
        public Map<Id,Account_Affiliation__c> oldMap;
        public Map<Id,Account_Affiliation__c> newMap;
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