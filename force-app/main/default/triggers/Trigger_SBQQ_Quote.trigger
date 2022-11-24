trigger Trigger_SBQQ_Quote on SBQQ__Quote__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Boolean hasBypassCustomPermission = FeatureManagement.checkPermission('Skip_process_builder');
    if (!hasBypassCustomPermission) {
    TriggerInterface_SBQQ_Quote.Trig trig = new TriggerInterface_SBQQ_Quote.Trig();
    trig.isBefore = trigger.isBefore;
    trig.isAfter = trigger.isAfter;
    trig.isInsert = trigger.isInsert;
    trig.isUpdate = trigger.isUpdate;
    trig.isDelete = trigger.isDelete;
    trig.isUnDelete = trigger.isUnDelete;

    TriggerInterfaceHelper.initTriggerMapAndList();
    List<Trigger__c> listTriggers = TriggerInterfaceHelper.listTriggers;
    Map<String,Map<Id,Map<String,String>>> mapTriggerRecordtypes = TriggerInterfaceHelper.mapTriggerRecordtypes;
    
    system.debug('JEFF: mapTriggerRecordtypes = ' + mapTriggerRecordtypes);
    system.debug('JEFF: listTriggers.size() = ' + listTriggers.size());
    
    for (Trigger__c t : listTriggers) {
        Boolean runTrigger = false;
        system.debug('JEFF: t.Object__c = ' + t.Object__c);
        system.debug('JEFF: t.After_Update__c = ' + t.After_Update__c);
        system.debug('JEFF: Trigger.size = ' + Trigger.size);
        
        if (t.Object__c == 'SBQQ__Quote__c') {
            if ((trigger.isBefore && trigger.isInsert && t.Before_Insert__c)
                    || (trigger.isBefore && trigger.isUpdate && t.Before_Update__c)
                    || (trigger.isBefore && trigger.isDelete && t.Before_Delete__c)
                    || (trigger.isAfter && trigger.isInsert && t.After_Insert__c)
                    || (trigger.isAfter && trigger.isUpdate && t.After_Update__c)
                    || (trigger.isAfter && trigger.isDelete && t.After_Delete__c)
                    || (trigger.isAfter && trigger.isUnDelete && t.After_UnDelete__c)) {
                trig.oldList = new List<SBQQ__Quote__c>();
                trig.newList = new List<SBQQ__Quote__c>();
                trig.oldMap = new Map<Id,SBQQ__Quote__c>();
                trig.newMap = new Map<Id,SBQQ__Quote__c>();
                trig.triggerSize = 0;
                for (Integer i=0; i<Trigger.size; i++) {
                
                    system.debug('JEFF: t.Run_for_Recordypes__c = ' + t.Run_for_Recordypes__c);
                    system.debug('JEFF: t.Name = ' + t.Name);
                    system.debug('JEFF: ' + mapTriggerRecordtypes.containsKey(t.Name));
                    system.debug('JEFF: ' + (trigger.isDelete ? trigger.old : trigger.new)[i].RecordtypeId);
                    system.debug('JEFF: ' + mapTriggerRecordtypes.get(t.Name).containsKey((trigger.isDelete ? trigger.old : trigger.new)[i].RecordtypeId));
                    
                
                    if (t.Run_for_Recordypes__c == 'All' || (mapTriggerRecordtypes.containsKey(t.Name) && mapTriggerRecordtypes.get(t.Name).containsKey((trigger.isDelete ? trigger.old : trigger.new)[i].RecordtypeId))) {
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
                        TriggerInterface_SBQQ_Quote.Runnable runnableClass;
                        try {
                            runnableClass = (TriggerInterface_SBQQ_Quote.Runnable) runnableType.newInstance();
                        } catch(Exception e) {
                            system.debug('********** Trigger Class ' + t.Name + ' has an incorrect interface **********');
                        }
                        if (runnableClass != null) {
                            String executionType = (trigger.isBefore ? 'Before ' : 'After ') + (trigger.isInsert ? 'Insert' : '') + (trigger.isUpdate ? 'Update' : '') + (trigger.isDelete ? 'Delete' : '') + (trigger.isUnDelete ? 'UnDelete' : '');
                            if (!TriggerInterfaceHelper.triggerAlreadyRan.contains(t.Name + ':' + executionType)) {
                                if (!Test.isRunningTest() && (t.Recursive_Execution_Allowed__c == null || !t.Recursive_Execution_Allowed__c))
                                    TriggerInterfaceHelper.triggerAlreadyRan.add(t.Name + ':' + executionType);
                                system.debug('********** Trigger_SBQQ_Quote (' + executionType + ') Start: ' + t.Name + ' **********');
                                Datetime startTime = Datetime.now();
                                runnableClass.run(trig);
                                DateTime endTime = Datetime.now();
                                Long seconds = (endTime.getTime() - startTime.getTime())/1000;
                                system.debug('********** Trigger_SBQQ_Quote (' + executionType + ') Finished in ' + seconds + ' seconds: ' + t.Name + ' **********');
                                if (seconds > 10)
                                    system.debug('********** Long running trigger **********');
                            }
                        }
                    } else {
                        system.debug('********** Trigger Class ' + t.Name + ' not found **********');
                    }
                }
            }
        }
    }
    }
}