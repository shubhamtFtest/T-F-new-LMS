public class TriggerInterface_Department {
	public interface Runnable {
		void run(TriggerInterface_Department.Trig trig);
	}	
	public class Trig {
		public List<Department__c> oldList;
		public List<Department__c> newList;
		public Map<Id,Department__c> oldMap;
		public Map<Id,Department__c> newMap;
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