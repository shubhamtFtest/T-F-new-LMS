/*
* Created by Jeff Lup - 2017.05.01 - CHG0034238
* Modified by Jeff Lup - 2017.06.26 - CHG0035587
* 
* Test: zTEST_Account_DeleteCampusDept_Trig      100%
*/
public without sharing class Account_DeleteCampusDept_Trig implements TriggerInterface_Account.Runnable {
    
    //declared here to pass between Before and After trigger
    public static List<Campus__c> camps;
    public static List<Department__c> depts;
        
    public void run(TriggerInterface_Account.Trig trig) {
        //*** Before Delete ***//
        if (trig.isBefore && trig.isDelete) {
            //retrieve child records in a Before Delete, because in an After the Account__c will be blank
            camps = [SELECT Id FROM Campus__c WHERE Account__c IN :trig.oldMap.keySet()];
            depts = [SELECT Id FROM Department__c WHERE Account__c IN :trig.oldMap.keySet()];
        }
        //*** After Delete ***//
        if (trig.isAfter && trig.isDelete) {
            //MasterRecordId only populated in an After Delete
            if (camps.size() > 0 || depts.size() > 0) {
                Boolean isMerge = false;
                for (Integer i = 0; i < trig.triggerSize; i++) {
                    if (trig.oldList[i].MasterRecordId != null) {
                        isMerge = true;
                        break;
                    }
                } 
                if (!isMerge) { //only delete children if not in a merge
                    if (camps.size() > 0)
                        delete camps;
                    if (depts.size() > 0)
                        delete depts;
                }
            }
        }
    }
}