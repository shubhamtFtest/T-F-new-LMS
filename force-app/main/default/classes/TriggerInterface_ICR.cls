public with sharing class TriggerInterface_ICR {
	public interface Runnable {
		void run(TriggerInterface_ICR.Trig trig);
	}	
	public class Trig {
		public List<Informa_Contact_Role__c> oldList;
		public List<Informa_Contact_Role__c> newList;
		public Map<Id,Informa_Contact_Role__c> oldMap;
		public Map<Id,Informa_Contact_Role__c> newMap;
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