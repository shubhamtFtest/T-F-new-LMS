public with sharing class TriggerInterface_User {
	public interface Runnable {
		void run(TriggerInterface_User.Trig trig);
	}	
	public class Trig {
		public List<User> oldList;
		public List<User> newList;
		public Map<Id,User> oldMap;
		public Map<Id,User> newMap;
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