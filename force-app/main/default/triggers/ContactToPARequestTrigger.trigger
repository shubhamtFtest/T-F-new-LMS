trigger ContactToPARequestTrigger on ContactToPersonAccountConvertionRequest__e (after insert) {
    System.debug('In ContactToPARequestTrigger');
    for (ContactToPersonAccountConvertionRequest__e event : Trigger.New) {
        ID contactID = event.Contact_ID__c;
        ID PersonAccountID = event.New_Account_ID__c;
        System.debug('contactID'+ contactID);
        System.debug('PersonAccountID'+PersonAccountID); 
        ConvertContactToPersonAccount.convertAcc(contactID, PersonAccountID);
    }
}