/*
* Created by Jeff Lup - 2014.10.10
* Modififed by Hailey Niemand - 2015.07.15 - CHG0066638 - Prevent test methods from firing query repeatedly
*/

public with sharing class TriggerInterfaceHelper {
    public static List<Trigger__c> listTriggers = new List<Trigger__c>();
    public static Map<String,Map<Id,Map<String,String>>> mapTriggerRecordtypes = new Map<String,Map<Id,Map<String,String>>>();
    public static Set<String> triggerAlreadyRan = new Set<String>();
    public static boolean alreadyRan = false; //CHG0066638
    public static boolean testingInterfaceHelper = false;

    public static void initTriggerMapAndList() {
        //if (listTriggers.size() == 0) { //CHG0066638
        if (!alreadyRan && (!test.isRunningTest() || testingInterfaceHelper)) { 
        //if (!alreadyRan) { 
            alreadyRan = true;
            listTriggers = [SELECT Name, Object__c, Execution_Order__c, Before_Insert__c, Before_Update__c, Before_Delete__c,
                                After_Insert__c, After_Update__c, After_Delete__c, After_UnDelete__c, Recursive_Execution_Allowed__c,
                                Run_for_Recordypes__c,
                                (SELECT Name, Recordtype_Id__c, Excluded_Profiles__c, Excluded_Users__c, Parameters__c
                                 FROM Trigger_Recordtypes__r
                                 WHERE Enabled__c = true)
                            FROM Trigger__c t
                            WHERE Enabled__c = true
                            ORDER BY Execution_Order__c];

            String profileId = String.valueOf(UserInfo.getProfileId()).left(15);
            String userId = String.valueOf(UserInfo.getUserId()).left(15);

            for (Trigger__c t : listTriggers) {
                List<Trigger_Recordtype__c> rts = t.Trigger_Recordtypes__r;
                if (rts.size() > 0) {
                    for (Trigger_Recordtype__c rt : rts) {
                        if ((rt.Excluded_Profiles__c == null || !rt.Excluded_Profiles__c.contains(profileId)) && (rt.Excluded_Users__c == null || !rt.Excluded_Users__c.contains(userId))) {
                            Map<Id,Map<String,String>> mapRtIdsAndParams = new Map<Id,Map<String,String>>();
                            if (mapTriggerRecordtypes.containsKey(t.Name))
                                mapRtIdsAndParams = mapTriggerRecordtypes.get(t.Name);
                            else
                                mapRtIdsAndParams = new Map<Id,Map<String,String>>();
                            
                            Map<String,String> mapParams = new Map<String,String>();
                            if (rt.Parameters__c != null) {
                                List<String> split1 = rt.Parameters__c.split(';');
                                for (String param : split1) {
                                    if (param.contains('=')) {
                                        List<String> split2 = param.split('=');
                                        mapParams.put(split2[0], split2[1]);
                                    } else {
                                        mapParams.put('Parameters', param);
                                    }
                                }
                            }
                            mapRtIdsAndParams.put(rt.Recordtype_Id__c, mapParams);              
                            mapTriggerRecordtypes.put(t.Name, mapRtIdsAndParams);
                        }
                    }
                } else {
                    Map<Id,Map<String,String>> mapRtIdsAndParams = new Map<Id,Map<String,String>>();
                    mapTriggerRecordtypes.put(t.Name, mapRtIdsAndParams);
                }
            }                      
        }
    }

    public static void runTrigger(String triggerName, String objectName, Integer executionOrder, String executionType,  String recordtypeId, String params) {
        system.debug('LUP: inside runTrigger');
        Set<String> setExecutionType = new Set<String>();
        setExecutionType.addAll(executionType.split(','));
        Trigger__c t;
        system.debug('JEFF: listTriggers.size() = ' + listTriggers.size());
        system.debug('JEFF: listTriggers = ' + listTriggers);
        
        for (Trigger__c existingTrigger : listTriggers) {
            if (existingTrigger.Name == triggerName) {
                t = existingTrigger;
                break;
            }
        }
        if (t == null) {
            t = new Trigger__c();
            t.Name = triggerName;
            t.Object__c = objectName;
            t.Execution_Order__c = executionOrder;
            t.Before_Insert__c = setExecutionType.contains('bi');
            t.Before_Update__c = setExecutionType.contains('bu');
            t.Before_Delete__c = setExecutionType.contains('bd');
            t.After_Insert__c = setExecutionType.contains('ai');
            t.After_Update__c = setExecutionType.contains('au');
            t.After_Delete__c = setExecutionType.contains('ad');
            t.After_UnDelete__c = setExecutionType.contains('aud');
            listTriggers.add(t);
        }  
        system.debug('JEFF: listTriggers = ' + listTriggers);     
        if (recordtypeId != null) {
            Map<Id, Map<String,String>> mapIdToParams;
            Map<String,String> mapParams = new Map<String,String>();
            if (params != null) {
                List<String> split1 = params.split(';');
                for (String param : split1) {
                    if (param.contains('=')) {
                        List<String> split2 = param.split('=');
                        mapParams.put(split2[0], split2[1]);
                    } else {
                        mapParams.put('Parameters', param);
                    }
                }
            }
            if (mapTriggerRecordtypes.containsKey(triggerName))
                mapIdToParams = mapTriggerRecordtypes.get(triggerName);
            else
                mapIdToParams = new Map<Id, Map<String,String>>();
            mapIdToParams.put(recordtypeId, mapParams);
            mapTriggerRecordtypes.put(triggerName, mapIdToParams);
        } else {
            Map<Id, Map<String,String>> mapIdToParams = new Map<Id, Map<String,String>>();
            mapTriggerRecordtypes.put(triggerName, mapIdToParams);
        }
    }
}