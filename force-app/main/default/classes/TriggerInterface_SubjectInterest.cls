public class TriggerInterface_SubjectInterest {
    
    public interface Runnable {
        void run(TriggerInterface_SubjectInterest.Trig trig);
    }  
    public class Trig {
        public List<SubjectInterest__c> oldList;
        public List<SubjectInterest__c> newList;
        public Map<Id,SubjectInterest__c> oldMap;
        public Map<Id,SubjectInterest__c> newMap;
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