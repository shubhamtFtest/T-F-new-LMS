public with sharing class TriggerInterface_Event {
	public interface Runnable {
		void run(TriggerInterface_Event.Trig trig);
	}	
	public class Trig {
		public List<Event> oldList;
		public List<Event> newList;
		public Map<Id,Event> oldMap;
		public Map<Id,Event> newMap;
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