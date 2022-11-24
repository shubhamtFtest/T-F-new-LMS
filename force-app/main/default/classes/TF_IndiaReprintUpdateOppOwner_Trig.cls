/*
 * This class changes Opportunity Owner based on the distributor Sales Contact Person
 * When setup in Trigger_Recordtype__c, it should be configured to only run for 'T&F - India Reprint'
 * 
 * Created by Amit Kumar - 2020.01.30
 * Tested by: TF_IndiaReprintUpdateOppOwner_Trig.cls
*/
public with sharing class TF_IndiaReprintUpdateOppOwner_Trig implements TriggerInterface_Opp.Runnable {    
    public void run(TriggerInterface_Opp.Trig trig) {       
        system.debug('@@@TF_IndiaReprintUpdateOppOwner_Trig');
        List<Opportunity> opportunityUpdateLst = new List<Opportunity>();
        for(integer i=0; i < trig.triggerSize; i++) {
            if (trig.isAfter && ((trig.isInsert && trig.newList[i].Cloned__c == false) || (trig.isUpdate && trig.oldList[i].AccountId != trig.newList[i].AccountId))) {
                for(Opportunity oppObj : trig.newList) {
                    if(oppObj.AccountId != null){
                        Id salesContactPersonId = [SELECT Id, Account.Sales_Contact_Person__c FROM Opportunity WHERE Id = :oppObj.Id LIMIT 1].Account.Sales_Contact_Person__c;                    
                        opportunityUpdateLst.add(new Opportunity(OwnerId = salesContactPersonId, Id = oppObj.Id)); 
                    }
                } 
            }
        }
        
        //update opportunity
        try {
            update opportunityUpdateLst;
        }
        catch(Exception e) {
            System.debug(e);
        }                                     
    }
}