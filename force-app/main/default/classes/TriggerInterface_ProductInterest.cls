public class TriggerInterface_ProductInterest {
    
    public interface Runnable {
        void run(TriggerInterface_ProductInterest.Trig trig);
    }  
    public class Trig {
        public List<ProductInterest__c> oldList;
        public List<ProductInterest__c> newList;
        public Map<Id,ProductInterest__c> oldMap;
        public Map<Id,ProductInterest__c> newMap;
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