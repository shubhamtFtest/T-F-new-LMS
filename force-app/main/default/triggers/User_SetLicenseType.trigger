trigger User_SetLicenseType on User (before insert, before update) {
    //Get map of profiles
    Set<Id> profileIds = new Set<Id>();
    for (Integer i = 0; i < trigger.size; i++) {
        profileIds.add(trigger.new[i].ProfileId);
    }
    Map<Id, Profile> mapProfiles = new Map<Id, Profile>([SELECT Id, UserLicense.Name FROM Profile WHERE Id IN :profileIds]);
    //Update license type
    for (Integer i = 0; i < trigger.size; i++) {
        if (mapProfiles.containsKey(trigger.new[i].ProfileId) && mapProfiles.get(trigger.new[i].ProfileId).UserLicense != null)
            trigger.new[i].License_Type__c = mapProfiles.get(trigger.new[i].ProfileId).UserLicense.Name;
    }
}