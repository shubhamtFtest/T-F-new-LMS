/*
* Tested by zTEST_CAS_UpdateOpportunityStudents_Trig    100%
*
* Created by Jeff Douglas
* Modified by Jeff Lup - 2015.04.22 - Moved into this TrigClass
*/
public without sharing class CAS_UpdateOpportunityStudents_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.oldList[0].Number_of_Students__c != trig.newList[0].Number_of_Students__c) {
                    // update the quanity on line items that have a quantity greater than or equal to 1
                    List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
                    for (OpportunityLineItem oli : [Select Id, Quantity, UnitPrice
                                                    From OpportunityLineItem
                                                    Where OpportunityId = :trig.newList[0].Id
                                                        And Quantity >= 1]) {
                        oli.Quantity = trig.newList[0].Number_of_Students__c;                    
                        oliToUpdate.add(oli);
                    }
                    if (oliToUpdate.size() > 0)
                        update oliToUpdate;
                } 
            }
        }
    }
}