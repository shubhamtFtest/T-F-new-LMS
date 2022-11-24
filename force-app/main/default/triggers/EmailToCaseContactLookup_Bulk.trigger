/**************************************************
* Created by Jeff Lup
* jeff.lup@informausa.com
* 2012.07.24
* EmailToCase searches all contacts in the database
*   when looking for an email address match.  We need
*   it to only find matches from the correct business.
* This is the same as EmailToCaseContactLookup, but modified
*   to work for bulk inserts.
* Modified by Hailey Niemand 2013.06.20 - INC0971468: email origin not completed on all received email-to-case
* Modified by Jeff Lup - 2013.08.30 - CTASK0036214 - for IBI
* Mofified by Jeff Lup - 2013.09.12 - CHG0053186 - fixed so must have SuppliedEmail
* Modified by Michael Brookes - 2013.09.30 - Added record types for ITM
* Modified by Hailey Niemand - 2013.12.06 - CHG0055093 - IBI
* Modified by Hailey Niemand - 2014.01.30 - CHG0055934 - T&F CSD
* Modified by Hailey Niemand - Use trigger record type object to enable trigger and manage which version to run - 2014.02.19
* Modified by Hailey Niemand - 2014.06.24 - CHG0059509 - mutiple case origins used by T&F
* Modified by Jeff Lup - 2015.04.10 - CHG0065268 - BI Renewal Enhancement Project
* Modified by Hailey Niemand - 2015.10.29 - CHG0069249
* Modified by Jeff Lup - 2015.12.03 - CHG0069814
* Modified by Jeff Lup - 2016.01.19 - CHG0070847
* Modified by Jeff Lup - 2017.10.31 - Updated to only work for T&F, so don't deploy this to the Main Org.
**************************************************/

trigger EmailToCaseContactLookup_Bulk on Case (after insert) { 
    
    Map<Id,Map<String,String>> mapRtsToRun = MiscFunctions.triggerEnabledRecordtypesWithParams('EmailToCaseContactLookup_Bulk'); 
    
    List<Case> cases = new List<Case>();
    for (Integer i = 0; i < trigger.size; i++) {
        if (mapRtsToRun.containsKey(trigger.new[i].recordtypeid) && Trigger.new[i].Status == 'New' && Trigger.new[i].SuppliedEmail != '' && Trigger.new[i].SuppliedEmail != NULL) { //We're only looking for cases created by EmailToCase
            String business = mapRtsToRun.get(trigger.new[i].recordtypeid).get('Business'); //CHG0059509
            if (business == 'T&F') //T&F CSD Cases //CHG0059509
                cases.add(Trigger.new[i]);
            else if (Trigger.new[i].Origin == 'Email')
                cases.add(Trigger.new[i]);
        }
    }

    if (cases.size() > 0) {
        Set<Id> contactRecordTypeIds = new Set<Id>();
        Map<Id, Set<Id>> mapCaseIdToContactRTs = new Map<Id, Set<Id>>();
        Map<Id, String> mapCaseIdToContactEmail = new Map<Id, String>();
    
        for (Case cse : cases) {
            Set<Id> contactRTsForCase = new Set<Id>();
            String contactRecordtypeId = mapRtsToRun.get(cse.recordtypeid).get('ContactRecordtypeId');
            contactRTsForCase.add(contactRecordtypeId);
            contactRecordTypeIds.add(contactRecordtypeId);
            mapCaseIdToContactRTs.put(cse.Id, contactRTsForCase);
            mapCaseIdToContactEmail.put(cse.Id, cse.SuppliedEmail);
        }
    
        List<Contact> contacts = [SELECT Id, Email, RecordTypeId, AccountId
                                    FROM Contact WHERE Email IN :mapCaseIdToContactEmail.values() AND RecordTypeId IN :contactRecordTypeIds];
        
        list<Case> casesToUpdate = new list<Case>();
        Id contactId;
        Id accountId;
        for (Case cse : cases) {
            Integer contactsFound = 0;
            for (Contact c : contacts) {
                if (c.Email == mapCaseIdToContactEmail.get(cse.Id) && mapCaseIdToContactRTs.get(cse.Id).contains(c.RecordTypeId)) {
                    String business = mapRtsToRun.get(cse.recordtypeid).get('Business');
                    contactsFound++;
                    contactId = c.Id;
                    accountId = c.AccountId;
                }
            }
            if (contactsFound == 1) {
                System.debug('One contact found from the correct recordtype.  Case will be updated with this contact.');
                Case caseToUpdate = new Case(Id=cse.Id);
                caseToUpdate.ContactId = contactId;
                caseToUpdate.Accountid = accountId;
                casesToUpdate.add(caseToUpdate);
            } else {
                System.debug('No contact (or more than one contact) was found from the correct recordtype.  Contact will be removed from the case so the user may select the correct one.');
                Case caseToUpdate = new Case(Id=cse.Id);
                caseToUpdate.ContactId = null;
                caseToUpdate.Accountid = null;
                casesToUpdate.add(caseToUpdate);
                //cse.ContactId = null;
            }
        }
        if (casesToUpdate.size() > 0)
            update casesToUpdate;
    }
}