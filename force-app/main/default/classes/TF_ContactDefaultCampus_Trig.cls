/* Created by Jeff Lup - 2017.04.06
*  Runs: Before Insert, Before Update
*  Defaults the Campus field, when only the Department was selected
*
*  Tested by: zTEST_TF_ContactDefaultCampus_Trig		100%
*
*  Modified by Jeff Lup - 2017.05.10 - CHG0034443
*/
public with sharing class TF_ContactDefaultCampus_Trig implements TriggerInterface_Contact.Runnable {
    public void run(TriggerInterface_Contact.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            Set<Id> deptIds = new Set<Id>();
            for (Integer i = 0; i < trig.triggerSize; i++) {
                //if (trig.newList[i].Department_Object__c != null) {
                //	if (trig.isInsert || trig.oldList[i].Campus__c != trig.newList[i].Campus__c || trig.oldList[i].Department_Object__c != trig.newList[i].Department_Object__c)
                //		deptIds.add(trig.newList[i].Department_Object__c);
                //}
                //CHG0034443
                if (trig.newList[i].Department_Object__c != null && trig.newList[i].Campus__c == null)
	                deptIds.add(trig.newList[i].Department_Object__c);
            }
            if (deptIds.size() > 0) {
                Map<Id, Department__c> mapDepts = new Map<Id, Department__c>([SELECT Id, Campus__c FROM Department__c WHERE Id IN :deptIds]);
                for (Integer i = 0; i < trig.triggerSize; i++) {
                    //if (trig.newList[i].Department_Object__c != null && mapDepts.containsKey(trig.newList[i].Department_Object__c) && mapDepts.get(trig.newList[i].Department_Object__c).Campus__c != null) {
                    //	if (trig.isInsert || trig.oldList[i].Campus__c != trig.newList[i].Campus__c || trig.oldList[i].Department_Object__c != trig.newList[i].Department_Object__c)
	                //    	trig.newList[i].Campus__c = mapDepts.get(trig.newList[i].Department_Object__c).Campus__c;
                	//}
                	//CHG0034443
	                if (trig.newList[i].Department_Object__c != null && trig.newList[i].Campus__c == null && mapDepts.containsKey(trig.newList[i].Department_Object__c) && mapDepts.get(trig.newList[i].Department_Object__c).Campus__c != null)
	                    trig.newList[i].Campus__c = mapDepts.get(trig.newList[i].Department_Object__c).Campus__c;
                }
            }
        }
    }
}