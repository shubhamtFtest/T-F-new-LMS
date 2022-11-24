public with sharing class TriggerInterface_PrintOrder {
	public interface Runnable {
		void run(TriggerInterface_PrintOrder.Trig trig);
	}	
	public class Trig {
		public List<Print_Order__c> oldList;
		public List<Print_Order__c> newList;
		public Map<Id,Print_Order__c> oldMap;
		public Map<Id,Print_Order__c> newMap;
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