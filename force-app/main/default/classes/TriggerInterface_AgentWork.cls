public with sharing class TriggerInterface_AgentWork {
	public interface Runnable {
		void run(TriggerInterface_AgentWork.Trig trig);
	}	
	public class Trig {
		public List<AgentWork> oldList;
		public List<AgentWork> newList;
		public Map<Id,AgentWork> oldMap;
		public Map<Id,AgentWork> newMap;
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