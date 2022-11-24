public with sharing class TriggerInterface_SAP_BP {
	public interface Runnable {
        void run(TriggerInterface_SAP_BP.Trig trig);
    }   
    public class Trig {
        public List<SAP_BP__c> oldList;
        public List<SAP_BP__c> newList;
        public Map<Id,SAP_BP__c> oldMap;
        public Map<Id,SAP_BP__c> newMap;
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