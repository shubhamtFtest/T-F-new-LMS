public with sharing class TriggerInterface_UserServicePresence {
	public interface Runnable {
		void run(TriggerInterface_UserServicePresence.Trig trig);
	}	
	public class Trig {
		public List<UserServicePresence> oldList;
		public List<UserServicePresence> newList;
		public Map<Id,UserServicePresence> oldMap;
		public Map<Id,UserServicePresence> newMap;
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