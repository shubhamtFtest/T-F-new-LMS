public without sharing class TriggerInterface_Billing {
	public interface Runnable {
		void run(TriggerInterface_Billing.Trig trig);
	}	
	public class Trig {
		public List<Billing__c> oldList;
		public List<Billing__c> newList;
		public Map<Id,Billing__c> oldMap;
		public Map<Id,Billing__c> newMap;
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