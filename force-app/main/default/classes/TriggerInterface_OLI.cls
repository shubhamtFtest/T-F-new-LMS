public with sharing class TriggerInterface_OLI {
	public interface Runnable {
		void run(TriggerInterface_OLI.Trig trig);
	}	
	public class Trig {
		public List<OpportunityLineItem> oldList;
		public List<OpportunityLineItem> newList;
		public Map<Id,OpportunityLineItem> oldMap;
		public Map<Id,OpportunityLineItem> newMap;
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