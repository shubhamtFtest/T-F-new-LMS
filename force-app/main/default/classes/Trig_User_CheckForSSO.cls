/*
    Created by Jeff Lup - 2015.02.02 - CHG0062414
        Helps enforce SSO or prompts for reason
    Modified by Jeff Lup - 2015.06.29 - CHG0067072 - exclude Chatter External Users
    
    Tested by: zTEST_Trig_User_CheckForSSO.cls  100%
*/
public with sharing class Trig_User_CheckForSSO implements TriggerInterface_User.Runnable {
    public void run(TriggerInterface_User.Trig trig) {
        //Check if user has no SSO Profile and no Reason
        if (trig.isBefore && (trig.isInsert || trig.IsUpdate)) {
            Set<Id> profileIds = new Set<Id>();
            for (Integer i=0; i<trig.triggerSize; i++) {
                if (trig.newList[i].ProfileId != '00e600000015kBcAAI') { //Don't perform for Chatter External Users - CHG0067072
                    if (trig.newList[i].Reason_Not_SSO_Enabled__c == null && trig.newList[i].isActive)
                        profileIds.add(trig.newList[i].ProfileId);
                }
            }
            if (profileIds.size() > 0) {
                Map<Id,Profile> mapProfiles = new Map<Id, Profile>([SELECT Id, IsSsoEnabled FROM Profile WHERE Id IN :profileIds]);
                for (Integer i=0; i<trig.triggerSize; i++) {
                    if (trig.newList[i].ProfileId != '00e600000015kBcAAI') { //Don't perform for Chatter External Users - CHG0067072
                        if (trig.newList[i].Reason_Not_SSO_Enabled__c == null && trig.newList[i].isActive && !mapProfiles.get(trig.newList[i].ProfileId).IsSsoEnabled)
                            trig.newList[i].addError('Please select a Profile with SSO enabled, or specify a reason why SSO is not enabled.');
                    }
                }
            }
        }
        //Check if Reason is 'SSO Enabled by Permission Set', then add the correct Permission Set (if necessary)
        if (trig.isAfter && (trig.isInsert || trig.IsUpdate)) {
            Set<Id> userIds = new Set<Id>();
            for (Integer i=0; i<trig.triggerSize; i++) {
                if (trig.newList[i].ProfileId != '00e600000015kBcAAI') { //Don't perform for Chatter External Users - CHG0067072
                    if (trig.newList[i].Reason_Not_SSO_Enabled__c == 'SSO Enabled by Permission Set' && trig.newList[i].isActive)
                        userIds.add(trig.newList[i].Id);
                }
            }
            if (userIds.size() > 0) {
                List<PermissionSetAssignment> psasToInsert = new List<PermissionSetAssignment>();
                List<PermissionSetAssignment> psas = [SELECT Id, AssigneeId, PermissionSetId, PermissionSet.PermissionsIsSsoEnabled FROM PermissionSetAssignment WHERE AssigneeId IN :userIds];
                for (Integer i=0; i<trig.triggerSize; i++) {
                    if (trig.newList[i].ProfileId != '00e600000015kBcAAI') { //Don't perform for Chatter External Users - CHG0067072
                        if (trig.newList[i].Reason_Not_SSO_Enabled__c == 'SSO Enabled by Permission Set' && trig.newList[i].isActive) {
                            Boolean foundSSO = false;
                            for (PermissionSetAssignment psa : psas) {
                                if (psa.AssigneeId == trig.newList[i].Id) {
                                    if (psa.PermissionSet.PermissionsIsSsoEnabled) {
                                        foundSSO = true;
                                        break;
                                    }
                                }
                            }
                            if (!foundSSO) {
                                PermissionSetAssignment psa = new PermissionSetAssignment();
                                psa.AssigneeId = trig.newList[i].Id;
                                psa.PermissionSetId = '0PS600000000GcT'; //System - SSO Enabled
                                psasToInsert.add(psa);
                            }
                        }
                    }
                }
                if (psasToInsert.size() > 0)
                    insert psasToInsert;
            }
        }
    }
}