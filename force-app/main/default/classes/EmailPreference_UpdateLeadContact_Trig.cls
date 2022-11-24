//Tested by zTEST_EmailPreference_UpdateLeadContact     100%
//
//Created by Jeff Lup - 2017.09.22 - To keep the Lead's and Contact's HasOptedOutOfEmail in sync with Email_Preference__c
//Updated by Jeff Lup - 2017.11.14 - CHG0039473 - replace ' with | (per Marketing Cloud issue)

public without sharing class EmailPreference_UpdateLeadContact_Trig implements TriggerInterface_EmailPreference.Runnable {
    
    public void run(TriggerInterface_EmailPreference.Trig trig) {
        
        system.debug('JEFF');
        
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            Map<String, Boolean> mapOptOuts = new Map<String, Boolean>();
            Map<String, String> mapReasons = new Map<String, String>();
            for (Integer i=0; i < trig.triggerSize; i++) {
                system.debug('JEFF: 1 = ' + trig.newList[i].Email__c);
                if (trig.newList[i].Email__c != null && trig.newList[i].Email__c != 'need.email@address.com') {
                    //mapOptOuts.put(trig.newList[i].Email__c.toLowerCase(), (trig.newList[i].Status__c == 'Unsubscribed' ? true : false));
                    //mapReasons.put(trig.newList[i].Email__c.toLowerCase(), trig.newList[i].Reason__c);
                    //CHG0039473
                    system.debug('JEFF: 2 = ' + trig.newList[i].Email__c.toLowerCase().replace('|','\''));
                    mapOptOuts.put(trig.newList[i].Email__c.toLowerCase().replace('|','\''), (trig.newList[i].Status__c == 'Unsubscribed' ? true : false));
                    mapReasons.put(trig.newList[i].Email__c.toLowerCase().replace('|','\''), trig.newList[i].Reason__c);
                }
            }
            if (mapOptOuts.size() > 0) {
                
                Id leatRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
                Id contactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
                Id oaccontactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - OAC Contacts'); //CHG0038379
                Set<Id> contactRtIds = new Set<Id>();
                contactRtIds.add(contactRtId);
                contactRtIds.add(oaccontactRtId);
                
                List<Lead> leads = [SELECT Id, Email, HasOptedOutOfEmail
                                    FROM Lead
                                    WHERE Email IN :mapOptOuts.keyset()
                                        AND RecordtypeId = :leatRtId 
                                        AND isconverted = FALSE
                                    LIMIT 100];
                                    
                for (Lead l : leads) {
                    l.HasOptedOutOfEmail = mapOptOuts.get(l.Email.toLowerCase());
                }
                List<Contact> contacts = [SELECT Id, Email, HasOptedOutOfEmail
                                          FROM Contact
                                          WHERE Email IN :mapOptOuts.keyset()
                                            AND RecordtypeId IN :contactRtIds
                                          LIMIT 100];
                Set<String> sourcesSet = MiscFunctions.getSetFromPicklist(Contact.optin_optout_source__c);
                for (Contact c : contacts) {
                    Boolean optOut = mapOptOuts.get(c.Email.toLowerCase());
                    c.HasOptedOutOfEmail = optOut;
                    c.Last_Modified_Opt_Out_Status_Date__c = datetime.now();
                    String reason = mapReasons.get(c.Email.toLowerCase());
                    if (!sourcesSet.contains(reason))
                        reason = 'Salesforce';
                    if (optOut) {
                        c.optin_optout_status__c = 'Explicit Opt-Out';
                        c.optin_optout_source__c = reason;
                    } else {
                        c.optin_optout_status__c = 'Explicit Opt-In';
                        c.optin_optout_source__c = reason;
                    }
                }
                PublicVariables.EmailPreferenceUpdated = true;
                system.debug('--->'+leads.size());
                if(leads.size()>0)
                    update leads;
                if(contacts.size()>0)
                    update contacts;
                PublicVariables.EmailPreferenceUpdated = false;
            }
        }
    }
}