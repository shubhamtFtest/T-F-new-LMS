public with sharing class TriggerInterface_Lead {
	public interface Runnable {
		void run(TriggerInterface_Lead.Trig trig);
	}	
	public class Trig {
		public List<Lead> oldList;
		public List<Lead> newList;
		public Map<Id,Lead> oldMap;
		public Map<Id,Lead> newMap;
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