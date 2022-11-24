/*
* This class changes create OLI history when umc,pric and customer quote will changed
* When setup in Trigger_Recordtype__c, it should be configured to only run for CAS
* 
* Created by Amit Kumar - 2020.02.20
** Tested by: zTEST_TF_UpdateOppOliDistributorTwo_Trig.cls      100%
*/
public without sharing class TF_IRPUpdateOppOliDistributorTwo_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            System.debug('@@@ start updating India Reprint opportunity line item Distributor field with opportunity account field value.');
            // create a set of all of the unique opportunity ids passed to the trigger
            Set<ID> opportunities = new Set<ID>();
            for (OpportunityLineItem oli : trig.newList) {
                opportunities.add(oli.opportunityId);
            }
            List<Opportunity> oppList = [SELECT Id,AccountId FROM Opportunity WHERE Id IN :opportunities];
            Opportunity oliObj = oppList[0];
            String oppAccountId = oliObj.AccountId;            
            
            //update oli distributor
            List<OpportunityLineItem> olisList = [SELECT Id, Distributor__c FROM OpportunityLineItem WHERE OpportunityId IN :opportunities];
            if(olisList.size() > 0){                
                olisList[0].Distributor__c = oppAccountId;               
                update olisList;
            }           
        }
    }
}