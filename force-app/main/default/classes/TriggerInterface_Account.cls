public with sharing class TriggerInterface_Account {
    public interface Runnable {
        void run(TriggerInterface_Account.Trig trig);
    }   
    public class Trig {
        public List<Account> oldList;
        public List<Account> newList;
        public Map<Id,Account> oldMap;
        public Map<Id,Account> newMap;
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