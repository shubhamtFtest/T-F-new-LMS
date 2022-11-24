public with sharing class TriggerInterface_Order {    
    public interface Runnable {
        void run(TriggerInterface_Order.Trig trig);
    }   
    public class Trig {
        public List<Order> oldList;
        public List<Order> newList;
        public Map<Id,Order> oldMap;
        public Map<Id,Order> newMap;
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