/*
* This class changes Opportunity Stages based on the action
* When setup in Trigger_Recordtype__c, it should be configured to only run for "T&F - India Reprint"
* 
* Created by Amit Kumar
** Tested by: zTEST_TF_IRP_CloneOppItem_Trig.cls      100%
*/

public without sharing class TF_IRP_CloneOppItem_Trig implements TriggerInterface_Opp.Runnable {
    public class wrapdatadup {      
        public String ISBN { get;set; }        
        public String Quantity { get;set; } 
        public String Binding { get;set; } 
    }    
    public void run(TriggerInterface_Opp.Trig trig) {
        Set<Id> newOppIds = new Set<Id>();
        Set<Id> oldOppIds = new Set<Id>();
        for(integer i=0; i < trig.triggerSize; i++) {
            if (trig.isAfter && trig.isInsert) {
                if(trig.newList[i].Cloned__c == true){
                    newOppIds.add(trig.newList[i].Id);
                    oldOppIds.add(trig.newList[i].ClonedOppId__c);
                }
            }
        }
        if (newOppIds.size() > 0) {          
            system.debug('clonedOpp');
            List<wrapdatadup> returnlist=new List<wrapdatadup>();
            List<OpportunityLineItem> lstOfOLIs = [Select Id, ProductCode,PricebookEntry.Name, PricebookEntryId, UnitPrice, Quantity, TotalPrice, 
                                                   Required_Version_Type__c, IR_Product_Type__c, Global_ISBN__c, Indian_Isbn__c 
                                                   FROM OpportunityLineItem where OpportunityId in:oldOppIds];
            
            for (OpportunityLineItem oli: lstOfOLIs) {
                wrapdatadup wrapobj= new wrapdatadup();
                wrapobj.ISBN=oli.ProductCode;
                Decimal qty = oli.Quantity;
                Integer qtyInt = Integer.ValueOf(qty);
                wrapobj.Quantity= String.ValueOf(qtyInt);
                wrapobj.Binding=oli.Required_Version_Type__c;
                returnlist.add(wrapobj);            
            }
            
            String jsonStr = JSON.serialize(returnlist);
            for (Id sid : newOppIds) {
            	TF_IndiaRePrintAddProducts.importOpportunityLineItems(jsonStr, sid);
            }               
        }
    }
}