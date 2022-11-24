public with sharing class TriggerInterface_QuoteApproval {
    public interface Runnable {
        void run(TriggerInterface_QuoteApproval.Trig trig);
    }
    public class Trig {
        public List<Quote_Approval__c > oldList;
        public List<Quote_Approval__c > newList;
        public Map<Id,Quote_Approval__c > oldMap;
        public Map<Id,Quote_Approval__c > newMap;
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