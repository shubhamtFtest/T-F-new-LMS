//Trigger for updating opportunity line item distributor name when new opportunity is created or updated.
public with sharing class TF_IRPUpdateOppOLIDistributorOne_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            System.debug('@@@ start updating India Reprint opportunity line item Distributor field with opportunity account field value.');
            String newAccountId; 
            Set<Id> opportunityIds = new Set<Id>();
            Set<Id> opportunityOldAccountIds = new Set<Id>();
            Set<Id> opportunityNewAccountIds = new Set<Id>();
            for(integer i=0; i < trig.triggerSize; i++) {
                if (trig.isAfter && (trig.isInsert || (trig.isUpdate && trig.oldList[i].AccountId != trig.newList[i].AccountId))) {
                    opportunityIds.add(trig.newList[i].Id);
                    opportunityNewAccountIds.add(trig.newList[i].AccountId);
                    opportunityOldAccountIds.add(trig.oldList[i].AccountId);
                }
            } 
            //check if opportunity products does exist for this opportunity
            List<OpportunityLineItem> olisList = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN :opportunityIds];
            if(olisList.size()>0){            
                if (opportunityOldAccountIds.size() > 0) {
                    for (Id accNewId : opportunityNewAccountIds){
                        newAccountId = accNewId;
                    }
                }
                
                List<OpportunityLineItem> olis2Update = new List<OpportunityLineItem>();           
                // iterate through all of the opportunity line items
                for (OpportunityLineItem oli : [Select oli.Id, oli.Distributor__c From OpportunityLineItem oli Where oli.Opportunity.Id IN :opportunityIds AND (oli.Distributor__c IN :opportunityOldAccountIds OR oli.Distributor__c = '')]) {                
                    oli.Distributor__c = newAccountId;
                    olis2Update.add(oli);                
                }            
                System.debug('@@@ olis2Update::'+ olis2Update);
                // if any opportunity line items were found, then update them
                if (olis2Update.size() > 0){ 
                    update olis2Update;            
                }
            }
        }
    }
}