public with sharing class Contact_UpdateCaseContact_Trig implements TriggerInterface_Contact.Runnable {
    public void run(TriggerInterface_Contact.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            if (trig.TriggerSize == 1 && trig.newList[0].Email != null) {
                if (trig.isInsert || trig.newList[0].Email != trig.oldList[0].Email) {
                    //Get set of valid Case Recordtype Ids
                    List<Setting_Item__c> settingItems = [SELECT Text_4__c 
                                                          FROM Setting_Item__c
                                                          WHERE Setting__r.Name = 'RtId Map for Contact_UpdateCaseContact'
                                                          AND Text_2__c = :trig.newList[0].recordtypeid];
                    Set<Id> setCaseRtIds = new Set<Id>();
                    for (Setting_Item__c settingItem : settingItems) {
                        setCaseRtIds.add(settingItem.Text_4__c);
                    }
                    
                    //Get Cases
                    List<Case> cases = [SELECT Id
                                        FROM Case
                                        WHERE SuppliedEmail = :trig.newList[0].Email
                                        AND ContactId = null
                                        AND RecordtypeId IN :setCaseRtIds];
                    if (cases.size() > 10000 || (test.isRunningTest() && cases.size() > 1)) {
                        system.debug('Found ' + cases.size() + ' cases.  Over limit.  Will update with Batch Apex.');
                        Contact_UpdateCaseContactBatchApex apexJob = new Contact_UpdateCaseContactBatchApex();
                        apexJob.SOQL = 'SELECT Id'
                            + ' FROM Case'
                            + ' WHERE SuppliedEmail = \'' + trig.newList[0].Email + '\''
                            + '   AND ContactId = null'
                            + '   AND RecordtypeId IN (' + MiscFunctions.convertIdSetToString(setCaseRtIds) + ')';
                        apexJob.contactId = trig.newList[0].Id;
                        //Start Batch Apex
                        ID batchprocessid = Database.ExecuteBatch(apexJob);
                        
                    } else if (cases.size() > 0) {
                        //Update Cases
                        for (Case c : cases) {
                            c.ContactId = trig.newList[0].Id;
                        }
                        system.debug('Found ' + cases.size() + ' cases.');
                        try {
                            Database.DMLOptions dlo = new Database.DMLOptions();
                            dlo.optAllOrNone = false;
                            database.update(cases,dlo);
                        } catch (Exception e) {
                        }
                    }
                }
            }
        }
    }
}