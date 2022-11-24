public with sharing class TriggerInterface_Opp {
	public interface Runnable {
		void run(TriggerInterface_Opp.Trig trig);
	}	
	public class Trig {
		public List<Opportunity> oldList;
		public List<Opportunity> newList;
		public Map<Id,Opportunity> oldMap;
		public Map<Id,Opportunity> newMap;
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