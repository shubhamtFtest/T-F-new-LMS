public with sharing class TriggerInterface_Campus {
	public interface Runnable {
		void run(TriggerInterface_Campus.Trig trig);
	}	
	public class Trig {
		public List<Campus__c> oldList;
		public List<Campus__c> newList;
		public Map<Id,Campus__c> oldMap;
		public Map<Id,Campus__c> newMap;
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