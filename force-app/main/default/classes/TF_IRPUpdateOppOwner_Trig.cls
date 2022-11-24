/*
*  This trigger class updates India reprint opportunity owner 
*  When setup in Trigger_Recordtype__c, it should be configured to only run for India Reprint
*  Created by Amit Kumar - 2020.05.07
*  Tested class: zTEST_TF_IRPUpdateOppOwner_Trig.cls 
*/
public with sharing class TF_IRPUpdateOppOwner_Trig implements TriggerInterface_Account.Runnable {
    
    public void run(TriggerInterface_Account.Trig trig) {
        if (trig.isAfter && trig.IsUpdate) {
			List<Id> newSalesContactPersonIds = new List<Id>();
            Set<Id> oldSalesContactPersonIds = new Set<Id>();
            for(Account acc: trig.newList){
                system.debug('SalesContactPerson::' + acc.Sales_Contact_Person__c+ ' and OldSalesContactPerson::'+trig.oldMap.get(acc.Id).Sales_Contact_Person__c);
                if(acc.Sales_Contact_Person__c != trig.oldMap.get(acc.Id).Sales_Contact_Person__c){
                    newSalesContactPersonIds.add(acc.Sales_Contact_Person__c);
                    oldSalesContactPersonIds.add(trig.oldMap.get(acc.Id).Sales_Contact_Person__c);
                }
            }
			Id oppRT = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
            list<Opportunity> opps = new list<Opportunity>([SELECT Id FROM Opportunity WHERE OwnerId in :oldSalesContactPersonIds AND RecordTypeId =:oppRT and StageName != 'Closed Won']);
            List<Opportunity> oppToUpdate = new List<Opportunity>();
            if(opps.size() > 0) { 
                for(Opportunity opp: opps){
                    Opportunity oppObj = new Opportunity();
                    oppObj.Id = opp.Id;
                    oppObj.OwnerId = newSalesContactPersonIds[0];
                    oppToUpdate.add(oppObj);
                }
            }
            try {
                if(oppToUpdate.size() > 0){
                	system.debug('Opportunities To Update Owner::' + oppToUpdate);
                	update oppToUpdate;                    
                }
            } catch (Exception ex){
                system.debug('TF_IRPUpdateOppOwner_Trig Exception');
            }
        }
    }
    
}