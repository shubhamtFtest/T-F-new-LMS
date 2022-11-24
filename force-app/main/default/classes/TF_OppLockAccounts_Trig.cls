/* Created by Jeff Lup - 2017.02.17
*  Runs: Before Insert
*  Locks Accounts created on a certain date - For Migration period only
*
*  Tested by: zTEST_TF_OppLockAccounts_Trig		100%
*/
public without sharing class TF_OppLockAccounts_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            String adminOptions = [Select Admin_Options__c From User Where Id = :UserInfo.getUserId()][0].Admin_Options__c;
            if (adminOptions == null || !adminOptions.contains('No Validation')) {
                String lockedRecords = CasCS__c.getValues('Locked_Records').Value__c;
                if (lockedRecords != null && lockedRecords != '') {
                    Set<String> setLockedRecords = new Set<String>();
                    setLockedRecords.addAll(lockedRecords.split(','));
                    Set<Id> accountIds = new Set<Id>();
                    for (Opportunity opp : trig.newList) {
                        accountIds.add(opp.AccountId);
                    }
                    Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, CreatedDate FROM Account WHERE Id IN :accountIds]);
                    if (mapAccounts.size() > 0) {
                        for (Opportunity opp : trig.newList) {
                            if (opp.AccountId != null) {
                                String createdDate = string.valueOfGmt(mapAccounts.get(opp.AccountId).CreatedDate);  //2011-09-10 07:00:00
                                String mm_yyyy = createdDate.substring(5,7) + '-' + createdDate.substring(0,4); //09-2011
                                if (setLockedRecords.contains(mm_yyyy)) 
                                    opp.addError('You may not work with this Account, because it is being migrated today.  Please wait until tomorrow.');
                            }
                        }
                    }
                }
            }
        }
    }
}