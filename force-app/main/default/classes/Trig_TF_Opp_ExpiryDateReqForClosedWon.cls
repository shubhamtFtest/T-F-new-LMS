public with sharing class Trig_TF_Opp_ExpiryDateReqForClosedWon implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {
            if (trig.newList[0].StageName == 'Closed Won' && trig.oldList[0].StageName != 'Closed Won'){
                List<OpportunityLineItem> OppLineItemList = [SELECT Id,ProductName__c,Product_Name__c,Article_Pass__c,Expiry_date__c From OpportunityLineItem where  Expiry_date__c = null and ProductName__c like 'Article Pass%' and OpportunityId = :trig.newList[0].Id];
                if (OppLineItemList.Size() > 0)
                    trig.newList[0].addError('Your Opportunity contains article pass products with blank expiry date, Expiry date is mandatory for opportunity to be closed won');
            }
        }
    }
}