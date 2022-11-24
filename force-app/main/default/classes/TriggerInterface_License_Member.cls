public with sharing class TriggerInterface_License_Member
{
    public interface Runnable 
    {
        void run(TriggerInterface_License_Member.Trig trig);
    }   
    public class Trig 
    {
        public List<License_Memeber__c> oldList;
        public List<License_Memeber__c> newList;
        public Map<Id,License_Memeber__c> oldMap;
        public Map<Id,License_Memeber__c> newMap;
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