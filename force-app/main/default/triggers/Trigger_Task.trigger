trigger Trigger_Task on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	TriggerInterface_Task.Trig trig = new TriggerInterface_Task.Trig();
	trig.isBefore = trigger.isBefore;
	trig.isAfter = trigger.isAfter;
	trig.isInsert = trigger.isInsert;
	trig.isUpdate = trigger.isUpdate;
	trig.isDelete = trigger.isDelete;
	trig.isUnDelete = trigger.isUnDelete;
	
	TriggerInterfaceHelper.initTriggerMapAndList();
	List<Trigger__c> listTriggers = TriggerInterfaceHelper.listTriggers;
	Map<String,Map<Id,Map<String,String>>> mapTriggerRecordtypes = TriggerInterfaceHelper.mapTriggerRecordtypes;

	for (Trigger__c t : listTriggers) {
		Boolean runTrigger = false;
		if (t.Object__c == 'Task') {
			if ((trigger.isBefore && trigger.isInsert && t.Before_Insert__c)
			 || (trigger.isBefore && trigger.isUpdate && t.Before_Update__c)
			 || (trigger.isBefore && trigger.isDelete && t.Before_Delete__c)
			 || (trigger.isAfter && trigger.isInsert && t.After_Insert__c)
			 || (trigger.isAfter && trigger.isUpdate && t.After_Update__c)
			 || (trigger.isAfter && trigger.isDelete && t.After_Delete__c)
			 || (trigger.isAfter && trigger.isUnDelete && t.After_UnDelete__c)) {
				trig.oldList = new List<Task>();
				trig.newList = new List<Task>();
				trig.oldMap = new Map<Id,Task>();
				trig.newMap = new Map<Id,Task>();
				trig.triggerSize = 0;
				for (Integer i=0; i<Trigger.size; i++) {
					if (!mapTriggerRecordtypes.containsKey(t.Name) || mapTriggerRecordtypes.get(t.Name).containsKey((trigger.isDelete ? trigger.old : trigger.new)[i].RecordtypeId)) {
						trig.triggerSize++;
						if (trigger.isUpdate || trigger.isDelete) {
							trig.oldList.add(trigger.old[i]);
							trig.oldMap.put(trigger.old[i].Id, trigger.old[i]);
						}
						if (trigger.isInsert || trigger.isUpdate || trigger.isUnDelete)
							trig.newList.add(trigger.new[i]);
						if (trigger.isUpdate || (trigger.isInsert && trigger.isAfter))
							trig.newMap.put(trigger.new[i].Id, trigger.new[i]);
					}
				}
				if (trig.triggerSize > 0) {
					trig.mapRtIdsToParams = mapTriggerRecordtypes.get(t.Name);
					Type runnableType = Type.forName(t.Name);
					if (runnableType != null) {
						TriggerInterface_Task.Runnable runnableClass;
						try {
							runnableClass = (TriggerInterface_Task.Runnable) runnableType.newInstance();
						} catch(Exception e) {
							system.debug('********** Trigger Class ' + t.Name + ' has an incorrect interface **********');
						}
						if (runnableClass != null) {
							String executionType = (trigger.isBefore ? 'Before ' : 'After ') + (trigger.isInsert ? 'Insert' : '') + (trigger.isUpdate ? 'Update' : '') + (trigger.isDelete ? 'Delete' : '') + (trigger.isUnDelete ? 'UnDelete' : '');
							system.debug('********** Trigger_Task (' + executionType + ') Start: ' + t.Name + ' **********');
							Datetime startTime = Datetime.now();
							runnableClass.run(trig);
							DateTime endTime = Datetime.now();
							Long seconds = (endTime.getTime() - startTime.getTime())/1000;
							system.debug('********** Trigger_Task (' + executionType + ') Finished in ' + seconds + ' seconds: ' + t.Name + ' **********');
							if (seconds > 10)
								system.debug('********** Long running trigger **********');
						}
					} else {
						system.debug('********** Trigger Class ' + t.Name + ' not found **********');
					}
				}
			}
		}
	}
}