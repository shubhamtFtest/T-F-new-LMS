public class TriggerInterface_Error_Log_Items {
    public interface Runnable {
        void run(TriggerInterface_Error_Log_Items.Trig trig);
    }   
    public class Trig {
        public List<Error_Log_Items__c> oldList;
        public List<Error_Log_Items__c> newList;
        public Map<Id,Error_Log_Items__c> oldMap;
        public Map<Id,Error_Log_Items__c> newMap;
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