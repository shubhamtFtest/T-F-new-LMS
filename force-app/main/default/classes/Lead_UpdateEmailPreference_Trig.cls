//Tested by zTEST_Lead_UpdateEmailPreference_Trig   100%
//
//Created by Jeff Lup - 2017.09.22 - To keep the Lead's HasOptedOutOfEmail in sync with Email_Preference__c
//Updated by Jeff Lup - 2017.11.14 - CHG0039473 - replace ' with | (per Marketing Cloud issue)
//Updated by Jeff Lup - 2017.11.14 - CHG0039473 - replace ' with | (per Marketing Cloud issue)

public without sharing class Lead_UpdateEmailPreference_Trig implements TriggerInterface_Lead.Runnable {

    public void run(TriggerInterface_Lead.Trig trig) {
        if (!PublicVariables.EmailPreferenceUpdated) { //check to see if EmailPreference_UpdateLeadContact_Trig just fired
            if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
                Set<String> emails = new Set<String>();
                for (Integer i=0; i < trig.triggerSize; i++) {
                    if (trig.IsInsert || trig.oldList[i].Email != trig.newList[i].Email || (trig.oldList[i].HasOptedOutOfEmail && !trig.newList[i].HasOptedOutOfEmail)) {
                        if (trig.newList[i].Email != null && trig.newList[i].Email != 'need.email@address.com') {
                          emails.add(trig.newList[i].Email);
                            if (trig.newList[i].Email.contains('\''))
                                emails.add(trig.newList[i].Email.replace('\'','|')); //CHG0039473
                        }
                    }
                }
                //Check for Email_Preference__c records
                List<Email_Preference__c> emailPreferences = [SELECT Email__c, Status__c FROM Email_Preference__c WHERE Email__c IN :emails];
                if (emailPreferences.size() > 0) {
                    Map<String, Boolean> mapOptOuts = new Map<String, Boolean>();
                    for (Email_Preference__c ep : emailPreferences) {
                        mapOptOuts.put(ep.Email__c.toLowerCase(), (ep.Status__c == 'Unsubscribed' ? true : false));
                    }
                    for (Integer i=0; i < trig.triggerSize; i++) {
                        if (trig.newList[i].Email != null && mapOptOuts.containsKey(trig.newList[i].Email.toLowerCase())) //CHG0039673
                          trig.newList[i].HasOptedOutOfEmail = mapOptOuts.get(trig.newList[i].Email.toLowerCase());
                    }
                }
            }            
            else if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
                //Check for changes to HasOptedOutOfEmail
                //Only Opt-outs will be processed this way, assuming they came from an Import
                //Any other updates come through either the Email Preference page in Salesforce or from MC
                Set<String> emailOptOuts = new Set<String>();
                Map<String, Lead> mapLeads = new Map<String, Lead>();
                for (Integer i=0; i < trig.triggerSize; i++) {
                    if (trig.newList[i].Email != null && trig.newList[i].Email != 'need.email@address.com') {
                        if (trig.IsInsert && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapLeads.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        } else if (trig.IsUpdate && trig.oldList[i].Email == trig.newList[i].Email && !trig.oldList[i].HasOptedOutOfEmail && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapLeads.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        } else if (trig.IsUpdate && trig.oldList[i].Email != trig.newList[i].Email && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase());
                            mapLeads.put(trig.newList[i].Email.toLowerCase(), trig.newList[i]);
                        }
                    }
                    if (trig.newList[i].Email != null && trig.newList[i].Email.contains('\'')) { //CHG0039473
                        if (trig.IsInsert && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                            mapLeads.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                        } else if (trig.IsUpdate && trig.oldList[i].Email == trig.newList[i].Email && !trig.oldList[i].HasOptedOutOfEmail && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                            mapLeads.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                        } else if (trig.IsUpdate && trig.oldList[i].Email != trig.newList[i].Email && trig.newList[i].HasOptedOutOfEmail) {
                            emailOptOuts.add(trig.newList[i].Email.toLowerCase().replace('\'','|'));
                            mapLeads.put(trig.newList[i].Email.toLowerCase().replace('\'','|'), trig.newList[i]);
                        }
                    }
                }
                if (emailOptOuts.size() > 0) {
                    //Check for existing Email_Preference__c records
                    List<Email_Preference__c> emailPreferences = [SELECT Id, Email__c, Status__c, Status_Date__c, Source__c, Salesforce_User__c
                                                                  FROM Email_Preference__c
                                                                  WHERE Email__c IN :emailOptOuts];
                    Set<String> existingEmails = new Set<String>();
                    //Update existing Email_Preference__c records
                    if (emailPreferences.size() > 0) {                        
                        for (Email_Preference__c ep : emailPreferences) {
                            ep.Status__c = 'Unsubscribed';
                            ep.Status_Date__c = mapLeads.get(ep.Email__c.toLowerCase()).LastModifiedDate;
                            ep.Source__c = 'Import';
                            ep.Salesforce_User__c = mapLeads.get(ep.Email__c.toLowerCase()).LastModifiedById;
                            ep.Reason__c = '';
                            existingEmails.add(ep.Email__c.toLowerCase());
                        }
                        update emailPreferences;
                    }
                    //Insert new Email_Preference__c records
                    List<Email_Preference__c> emailPreferencesToInsert = new List<Email_Preference__c>();
                    for (Lead l : mapLeads.values()) {
                        //if (!existingEmails.contains(l.Email.toLowerCase())) { //CHG0039473
                        if (!existingEmails.contains(l.Email.toLowerCase()) && !existingEmails.contains(l.Email.toLowerCase().replace('\'','|'))) { //CHG0039473
                            Email_Preference__c ep = new Email_Preference__c();
                            ep.Email__c = l.Email.replace('\'','|'); //CHG0039473
                            ep.Status__c = 'Unsubscribed';
                            ep.Status_Date__c = l.LastModifiedDate;
                            ep.Source__c = 'Import';
                            ep.Salesforce_User__c = l.LastModifiedById;
                            ep.Reason__c = '';
                            emailPreferencesToInsert.add(ep);
                        }
                    }
                    if (emailPreferencesToInsert.size() > 0)
                        insert emailPreferencesToInsert;
                }            
            } 
        }
    }
}