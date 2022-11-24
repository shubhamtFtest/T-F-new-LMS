public with sharing class TF_OLIDeleteOrderedCheckBoxTrue implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if(trig.isDelete && trig.isAfter){
            Set<Opportunity> oppSet = new Set<Opportunity>();//Shalini- because if we are deleting multiple line item from opportuunity we are getting duplicate Id error
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            Set<Id> oppIds = new Set<Id>();
            for(opportunitylineitem oli : trig.oldList){
                if(oli.OpportunityId != null){
                    oppIds.add(oli.OpportunityId);
                    Opportunity opp = new Opportunity();
                    opp.Id = oli.OpportunityId;
                    opp.SBQQ__Ordered__c = true;
                    oppSet.add(opp);
                }
            }
            if(oppIds.size()>0){
                List<opportunitylineitem> oliRecs = new List<opportunitylineitem>();
                oliRecs = [Select id from opportunitylineitem where OpportunityId IN : oppIds];
                if(oliRecs.size()>0){
                    oppListToUpdate.addAll(oppSet);
                    update oppListToUpdate;
                }
               
            }
        }
    }
}