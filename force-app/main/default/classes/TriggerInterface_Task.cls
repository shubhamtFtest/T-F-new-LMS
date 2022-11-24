public with sharing class TriggerInterface_Task {
	public interface Runnable {
		void run(TriggerInterface_Task.Trig trig);
	}	
	public class Trig {
		public List<Task> oldList;
		public List<Task> newList;
		public Map<Id,Task> oldMap;
		public Map<Id,Task> newMap;
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