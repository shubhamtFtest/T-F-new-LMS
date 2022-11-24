//Tested by zTEST_Contact_UpdateEmailPreference_Trig    100%
//
//Created by Jeff Lup - 2017.09.22 - To keep the Contact's HasOptedOutOfEmail in sync with Email_Preference__c
//Updated by Jeff Lup - 2017.11.14 - CHG0039473 - replace ' with | (per Marketing Cloud issue)
//Updated by Jeff Lup - 2017.11.21 - CHG0039673

public without sharing class Contact_UpdateEmailPreference_Trig implements TriggerInterface_Contact.Runnable {
	
    public void run(TriggerInterface_Contact.Trig trig) {
        System.debug('In IN TF_UpdateContactSourceDetails_Trig');
        system.debug('jeff: 1');
        if (!PublicVariables.EmailPreferenceUpdated) { //check to see if EmailPreference_UpdateLeadContact_Trig just fired
            system.debug('jeff: 2');
            if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
                Set<String> emails = new Set<String>();
                System.debug('trig.triggerSize '+trig.triggerSize);
                for (Integer i=0; i < trig.triggerSize; i++) {
                    //if not just opted back in
                    if ((trig.IsInsert || trig.oldList[i].Email != trig.newList[i].Email || (trig.oldList[i].HasOptedOutOfEmail && !trig.newList[i].HasOptedOutOfEmail)) && trig.newList[i].optin_optout_status__c != 'Explicit Opt-In') {
                        if (trig.newList[i].Email != null && trig.newList[i].Email != 'need.email@address.com') {
                          emails.add(trig.newList[i].Email);
                            if (trig.newList[i].Email.contains('\''))
                                emails.add(trig.newList[i].Email.replace('\'','|')); //CHG0039473
                        }
                    }
                }
                system.debug('jeff: emails = ' + emails);
                //Check for Email_Preference__c records
                if (emails.size() > 0) {
                    List<Email_Preference__c> emailPreferences = [SELECT Email__c, Status__c
                                                                  FROM Email_Preference__c
                                                                  WHERE Email__c IN :emails];
                    if (emailPreferences.size() > 0) {
                        Map<String, Boolean> mapOptOuts = new Map<String, Boolean>();
                        for (Email_Preference__c ep : emailPreferences) {
                            mapOptOuts.put(ep.Email__c.toLowerCase(), (ep.Status__c == 'Unsubscribed' ? true : false));
                        }
                        system.debug('jeff: mapOptOuts = ' + mapOptOuts);
                        for (Integer i=0; i < trig.triggerSize; i++) {
                            if (trig.newList[i].Email != null && mapOptOuts.containsKey(trig.newList[i].Email.toLowerCase())) //CHG0039673
                              trig.newList[i].HasOptedOutOfEmail = mapOptOuts.get(trig.newList[i].Email.toLowerCase());
                        }
                    }
                }
            }            
            else if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
                //Check for changes to HasOptedOutOfEmail or optin_optout_status__c
                System.debug('After trigger of Contact_UpdateEmailPreference_Trig');
                Set<String> emailOptOuts = new Set<String>();
                Set<String> emailOptIns = new Set<String>();
                Map<String, Contact> mapContacts = new Map<String, Contact>();
                for (Integer i=0; i < trig.triggerSize; i++) {
                    if (trig.newList[i].Email != null && trig.newList[i].Email != 'need.email@address.com') {
                        //inserted and opted out
                        if (trig.IsInsert && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapContacts.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                        //inserted and opted in
                        else if (trig.IsInsert && trig.newList[i].optin_optout_status__c == 'Explicit Opt-In') {
                            emailOptIns.add(trig.newList[i].Email.toLowerCase());
                            mapContacts.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                        //updated, email not changed, and just opted out
                        else if (trig.IsUpdate && trig.oldList[i].Email == trig.newList[i].Email && ((!trig.oldList[i].HasOptedOutOfEmail && trig.newList[i].HasOptedOutOfEmail) || (trig.newList[i].optin_optout_status__c == 'Explicit Opt-Out' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c))) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapContacts.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                        //updated, email not changed, and just opted in (Explicit only)
                        else if (trig.IsUpdate && trig.newList[i].optin_optout_status__c == 'Explicit Opt-In' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c && trig.oldList[i].Email == trig.newList[i].Email ) {
                            emailOptIns.add(trig.newList[i].Email.toLowerCase());
                            mapContacts.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                        //updated, email changed, and just opted out
                        else if (trig.IsUpdate && trig.oldList[i].Email != trig.newList[i].Email && (trig.newList[i].HasOptedOutOfEmail || (trig.newList[i].optin_optout_status__c == 'Explicit Opt-Out' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c))) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapContacts.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                        if (trig.newList[i].Email != null && trig.newList[i].Email.contains('\'')) { //CHG0039473
                            //inserted and opted out
                            if (trig.IsInsert && trig.newList[i].HasOptedOutOfEmail) {
                                emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                                mapContacts.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                            }
                            //inserted and opted in
                            else if (trig.IsInsert && trig.newList[i].optin_optout_status__c == 'Explicit Opt-In') {
                                emailOptIns.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                                mapContacts.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                            }
                            //updated, email not changed, and just opted out
                            else if (trig.IsUpdate && trig.oldList[i].Email == trig.newList[i].Email && ((!trig.oldList[i].HasOptedOutOfEmail && trig.newList[i].HasOptedOutOfEmail) || (trig.newList[i].optin_optout_status__c == 'Explicit Opt-Out' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c))) {
                                emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                                mapContacts.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                            }
                            //updated, email not changed, and just opted in (Explicit only)
                            else if (trig.IsUpdate && trig.newList[i].optin_optout_status__c == 'Explicit Opt-In' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c && trig.oldList[i].Email == trig.newList[i].Email ) {
                                emailOptIns.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                                mapContacts.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                            }
                            //updated, email changed, and just opted out
                            else if (trig.IsUpdate && trig.oldList[i].Email != trig.newList[i].Email && (trig.newList[i].HasOptedOutOfEmail || (trig.newList[i].optin_optout_status__c == 'Explicit Opt-Out' && trig.oldList[i].optin_optout_status__c != trig.newList[i].optin_optout_status__c))) {
                                emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                                mapContacts.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                            }
                        }
                    }
                }
                if (emailOptOuts.size() > 0 || emailOptIns.size() > 0) {
                    //Check for existing Email_Preference__c records
                    system.debug('jeff: emailOptOuts = ' + emailOptOuts);
                    system.debug('jeff: emailOptIns = ' + emailOptIns);
                    List<Email_Preference__c> emailPreferences = [SELECT Id, Email__c, Status__c, Status_Date__c, Source__c, Salesforce_User__c
                                                                  FROM Email_Preference__c
                                                                  WHERE Email__c IN :emailOptOuts
                                                                   OR Email__c IN :emailOptIns];
                    System.debug('emailPreferences : '+ emailPreferences);
                    Set<String> existingEmails = new Set<String>();
                    Map<String, Contact> contactEmailContactMap = new Map<String, Contact>();// Fix for marketing cloud issue Map of Contacts Email and Contact by Renil. .
                    //Update existing Email_Preference__c records
                    if (emailPreferences != null && emailPreferences.size() > 0) {                        
                        for (Email_Preference__c ep : emailPreferences) {
                            ep.Status__c = (emailOptIns.contains(ep.Email__c.toLowerCase()) ? 'Re-subscribed' : 'Unsubscribed');
                            ep.Status_Date__c = mapContacts.get(ep.Email__c.toLowerCase()).LastModifiedDate;
                            ep.Source__c = 'Import';
                            ep.Salesforce_User__c = mapContacts.get(ep.Email__c.toLowerCase()).LastModifiedById;
                            ep.Reason__c = mapContacts.get(ep.Email__c.toLowerCase()).optin_optout_source__c;
                            existingEmails.add(ep.Email__c.toLowerCase());
                        }
                       Database.SaveResult [] updateResult = Database.update(emailPreferences, false); 
                    }
                    //Insert new Email_Preference__c records
                    System.debug('Contacts entering for email pref '+mapContacts.values());
                    List<Email_Preference__c> emailPreferencesToInsert = new List<Email_Preference__c>();
                    for (Contact c : mapContacts.values()) 
                    {
                        if(!contactEmailContactMap.containsKey(c.Email))
                        {
							System.debug('Each Contact entering '+c);
                            //if (!existingEmails.contains(c.Email.toLowerCase())) { //CHG0039473
                            if (!existingEmails.contains(c.Email.toLowerCase()) && !existingEmails.contains(c.Email.toLowerCase().replace('\'','|'))) 
                            { //CHG0039473
                                Email_Preference__c ep = new Email_Preference__c();
                                ep.Email__c = c.Email.replace('\'','|'); //CHG0039473
                                ep.Status__c = (emailOptIns.contains(ep.Email__c.toLowerCase()) ? 'Re-subscribed' : 'Unsubscribed');
                                ep.Status_Date__c = c.LastModifiedDate;
                                ep.Source__c = 'Import';
                                ep.Salesforce_User__c = c.LastModifiedById;
                                ep.Reason__c = mapContacts.get(ep.Email__c.toLowerCase()).optin_optout_source__c;
                                emailPreferencesToInsert.add(ep);
                            }
                         	contactEmailContactMap.put(c.Email,c);
                        }   
                    }
                    if (emailPreferencesToInsert.size() > 0)
                        insert emailPreferencesToInsert;
                }            
            } 
        }
    }
}