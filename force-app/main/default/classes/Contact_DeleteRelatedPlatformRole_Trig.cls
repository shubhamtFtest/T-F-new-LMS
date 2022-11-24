public with sharing class Contact_DeleteRelatedPlatformRole_Trig implements TriggerInterface_Contact.Runnable{
    public void run(TriggerInterface_Contact.Trig trig) {
        if(trig.isDelete){
            List<Platform_Role__c> allRelatedPlatformRoles = [SELECT Id FROM Platform_Role__c WHERE Contact__c IN :trig.oldMap.keySet()];
            System.debug('allRelatedPlatformRoles : '+allRelatedPlatformRoles);
            if(allRelatedPlatformRoles != null && allRelatedPlatformRoles.size() > 0){
                delete allRelatedPlatformRoles;
            }
        }
    }
}