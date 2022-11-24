public with sharing class TriggerInterface_Campaign {
	public interface Runnable {
		void run(TriggerInterface_Campaign.Trig trig);
	}	
	public class Trig {
		public List<Campaign> oldList;
		public List<Campaign> newList;
		public Map<Id,Campaign> oldMap;
		public Map<Id,Campaign> newMap;
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