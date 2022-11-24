/*
* Tested by: zTEST_OLI_DefaultContact   100%
*
* Created by Jeff Lup - 2012.05.07 - CHG0041746
* Modified by Jeff Lup - 2014.06.20 - CHG0058768
* Modified by Jeff Lup - 2015.03.03 - Moved Trigger into this Class
*/

public without sharing class OLI_DefaultContact_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            //Check if any contacts are missing
            Boolean needsContact = false;
            for (Integer i=0; i < trig.triggerSize; i++) {
                if (trig.newList[i].Recipient__c == null) {
                    needsContact = true;        
                    break;
                }
            }
            //Get contact (if necessary)
            if (needsContact) {
                List<OpportunityContactRole> ocrs = [SELECT ContactId, IsPrimary, Role
                                                     FROM OpportunityContactRole
                                                     WHERE OpportunityId = :trig.newList[0].OpportunityId];
                if (ocrs.size() > 0) {
                    Id contactId;
                    for (OpportunityContactRole ocr : ocrs) {
                        if (ocr.IsPrimary) {
                            contactId = ocr.ContactId;
                            break;
                        }
                    }
                    if (contactId == null) {
                        for (OpportunityContactRole ocr : ocrs) {
                            if (ocr.Role == 'Decision Maker') {
                                contactId = ocr.ContactId;
                                break;
                            }
                        }
                    }
                    if (contactId == null)
                        contactId = ocrs[0].ContactId;
        
                    for (Integer i=0; i < trig.triggerSize; i++) {
                        if (trig.newList[i].Recipient__c == null)
                            trig.newList[i].Recipient__c = contactId;
                    }       
                }
            }
            //set Default Address
            Set<Id> contactIds = new Set<Id>();
            for (Integer i=0; i < trig.triggerSize; i++) {
                contactIds.add(trig.newList[i].Recipient__c);
            }
            if (contactIds.size() > 0) {
                Map<Id, Contact> mapContacts = new Map<Id, Contact>([SELECT Id, Default_Address__c FROM Contact WHERE Id IN :contactIds]);
                for (Integer i=0; i < trig.triggerSize; i++) {
                    if (trig.newList[i].Recipient__c != null) {
                        String defaultAddress = mapContacts.get(trig.newList[i].Recipient__c).Default_Address__c;
                        if (defaultAddress != null)
                            trig.newList[i].Recipient_Address__c = defaultAddress;
                    }
                }       
            }
        }
    }
}