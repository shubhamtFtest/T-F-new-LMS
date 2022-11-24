public without sharing class TriggerInterface_EmailPreference  {
    public interface Runnable {
        void run(TriggerInterface_EmailPreference.Trig trig);
    }   
    public class Trig {
        public List<Email_Preference__c> oldList;
        public List<Email_Preference__c> newList;
        public Map<Id,Email_Preference__c> oldMap;
        public Map<Id,Email_Preference__c> newMap;
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