/*
* Tested by zTEST_CAS_OpportunityUpdateICOwner_Trig     100%
*
* Created by Jeff Lup
* Modified by Jeff Lup - 2015.04.22 - Moved into this TrigClass
*/
public without sharing class CAS_OpportunityUpdateICOwner_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.oldList[0].OwnerId != trig.newList[0].OwnerId) {
                    // update the quanity on line items that have a quantity greater than or equal to 1
                    List<CAS_Inspection_Copy__c> icToUpdate = new List<CAS_Inspection_Copy__c>();
                    for (CAS_Inspection_Copy__c ic : [SELECT Id
                                                        FROM CAS_Inspection_Copy__c
                                                        WHERE Opportunity__c = :trig.newList[0].Id]) {
                        ic.OwnerId = trig.newList[0].OwnerId;                    
                        icToUpdate.add(ic);
                    }
                    if (icToUpdate.size() > 0)
                        update icToUpdate;
                }
            }
        }
    }
}