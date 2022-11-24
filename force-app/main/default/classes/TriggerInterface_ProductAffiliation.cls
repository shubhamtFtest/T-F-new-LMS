public with sharing class TriggerInterface_ProductAffiliation {
    public interface Runnable {
        void run(TriggerInterface_ProductAffiliation.Trig trig);
    }
    public class Trig {
        public List<Product_Affiliation__c> oldList;
        public List<Product_Affiliation__c> newList;
        public Map<Id,Product_Affiliation__c> oldMap;
        public Map<Id,Product_Affiliation__c> newMap;
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