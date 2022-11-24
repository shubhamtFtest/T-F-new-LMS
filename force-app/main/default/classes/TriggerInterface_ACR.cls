public with sharing class TriggerInterface_ACR {
    public interface Runnable {
		void run(TriggerInterface_ACR.Trig trig);
	}	
	public class Trig {
		public List<AccountContactRole__c> oldList;
		public List<AccountContactRole__c> newList;
		public Map<Id,AccountContactRole__c> oldMap;
		public Map<Id,AccountContactRole__c> newMap;
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