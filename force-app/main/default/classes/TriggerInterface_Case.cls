public with sharing class TriggerInterface_Case {
	public interface Runnable {
		void run(TriggerInterface_Case.Trig trig);
	}	
	public class Trig {
		public List<Case> oldList;
		public List<Case> newList;
		public Map<Id,Case> oldMap;
		public Map<Id,Case> newMap;
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