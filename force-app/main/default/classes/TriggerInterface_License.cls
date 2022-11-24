public with sharing class TriggerInterface_License 
{
    public interface Runnable 
    {
        void run(TriggerInterface_License.Trig trig);
    }   
    public class Trig 
    {
        public List<License__c> oldList;
        public List<License__c> newList;
        public Map<Id,License__c> oldMap;
        public Map<Id,License__c> newMap;
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