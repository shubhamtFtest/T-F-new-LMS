public with sharing class TriggerInterface_Contact {
	public interface Runnable {
		void run(TriggerInterface_Contact.Trig trig);
	}	
	public class Trig {
		public List<Contact> oldList;
		public List<Contact> newList;
		public Map<Id,Contact> oldMap;
		public Map<Id,Contact> newMap;
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