/****************************************************************************************************************************
* Class Name : AccountContactRoleTriggerHandler
* Project : WS6 JCM Pardot Phase 2
* Purpose : Methods for updating contact record on update or insert of Account Contact Role records to update ACR last
*          interaction date field on corresponding Contact record.
* Author : Divya Rao (Appirio)
* Date : 09/08/2016
* JIRA numbers : WCE - 594
*****************************************************************************************************************************/

public class AccountContactRoleTriggerHandler 
{
    public void updateContactLastACRInteractionDate(list<AccountContactRole__c> listAccContactRolesToUpdate)
    {
        Set<Id> setContactsRelatedToAccContactRole = new Set<Id>();
        for (AccountContactRole__c acr: listAccContactRolesToUpdate)
        {
            setContactsRelatedToAccContactRole.add(acr.ContactID__c);
        }
         //Retrieve all contact sources related to that contact
        List<AccountContactRole__c> listRelatedAccContactRoles = new List<AccountContactRole__c>([SELECT ContactID__c,
                                                                                        Id,Last_Interaction_Date__c
                                                                                        FROM AccountContactRole__c
                                                                                        WHERE ContactID__c IN: setContactsRelatedToAccContactRole]);
        Map<Id,Contact> mapIdToContactsToBeUpdated = new Map<Id,Contact>([SELECT Id,ACR_Last_Interaction__c
                                                                FROM Contact
                                                                WHERE ID IN: setContactsRelatedToAccContactRole AND (RecordTypeId=:label.TandF_Contact_Record_Type_Id OR RecordTypeId=:label.TandF_Contact_Record_Type_Id_18)]);
        for(AccountContactRole__c acr:listRelatedAccContactRoles)
        {
            if(mapIdToContactsToBeUpdated.get(acr.ContactID__c).ACR_Last_Interaction__c==null || acr.Last_Interaction_Date__c >= mapIdToContactsToBeUpdated.get(acr.ContactID__c).ACR_Last_Interaction__c)
            {
                mapIdToContactsToBeUpdated.get(acr.ContactID__c).ACR_Last_Interaction__c = acr.Last_Interaction_Date__c;
            }

        }
        //System.debug('Contacts to update:::::'+mapIdToContactsToBeUpdated.values());
        update mapIdToContactsToBeUpdated.values();

        return;
    }
    
}