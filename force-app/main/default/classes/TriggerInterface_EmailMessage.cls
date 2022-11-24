public class TriggerInterface_EmailMessage {
    public interface Runnable {
        void run(TriggerInterface_EmailMessage.Trig trig);
    }  
    public class Trig {
        public List<EmailMessage> oldList;
        public List<EmailMessage> newList;
        public Map<Id,EmailMessage> oldMap;
        public Map<Id,EmailMessage> newMap;
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