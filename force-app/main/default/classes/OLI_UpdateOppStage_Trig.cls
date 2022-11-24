/*
 * This class changes Opportunity Stages based on the OLI's Adoption Stage
 * When setup in Trigger_Recordtype__c, it should be configured to only run for CAS
 * 
 * Created by Jeff Lup - 2018.09.28
** Tested by: zTEST_OLI_UpdateOppStage_Trig.cls      100%
*/

public without sharing class OLI_UpdateOppStage_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> deletedOliIds = new Set<Id>();
        for(integer i=0; i < trig.triggerSize; i++) {
            if (trig.isBefore && trig.isDelete) {
                oppIds.add(trig.oldList[i].OpportunityId);
                deletedOliIds.add(trig.oldList[i].Id);
            }
            else if (trig.isAfter && (trig.isInsert || (trig.isUpdate && trig.oldList[i].Adoption_Stage__c != trig.newList[i].Adoption_Stage__c))) {
                oppIds.add(trig.newList[i].OpportunityId);
            }
        }
        if (oppIds.size() > 0) {
            
            Map<String, String> mapOliStageToOppStage = new Map<String, String>();
            mapOliStageToOppStage.put('Created','Investigating');
            mapOliStageToOppStage.put('In-Process','Investigating');
            mapOliStageToOppStage.put('Open - Under Consideration','Evaluating');
            mapOliStageToOppStage.put('Committee Review','Evaluating');
            mapOliStageToOppStage.put('Completed - Order Confirmed','Acceptance');
            mapOliStageToOppStage.put('Completed - Adopted','Acceptance');
            mapOliStageToOppStage.put('Completed - Purchased','Acceptance');
            mapOliStageToOppStage.put('Completed - Library Purchase and Adopted','Acceptance');
            mapOliStageToOppStage.put('Completed - Library Purchase not Adopted','Closed Lost');
            mapOliStageToOppStage.put('Completed - Not Appropriate','Closed Lost');
            mapOliStageToOppStage.put('Completed - No Response','Closed Lost');
            mapOliStageToOppStage.put('Completed - Returned','Closed Lost');
            mapOliStageToOppStage.put('Never Received Product','Closed Lost');
            
            Map<String, Integer> mapOppStageOrder = new Map<String, Integer>();
            mapOppStageOrder.put('Closed Lost',1);
            mapOppStageOrder.put('Prospect',2);
            mapOppStageOrder.put('Investigating',3);
            mapOppStageOrder.put('Evaluating',4);
            mapOppStageOrder.put('Negotiation',5);
            mapOppStageOrder.put('Acceptance',6);
            mapOppStageOrder.put('Closed Won',7);
            
            Map<Id, String> mapOppToStage = new Map<Id, String>();   
            List<OpportunityLineItem> olis;
            if (trig.isDelete)
                olis = [SELECT Id, OpportunityId, Adoption_Stage__c FROM OpportunityLineItem WHERE OpportunityId IN :oppIds AND Id NOT IN :deletedOliIds];
            else
                olis = [SELECT Id, OpportunityId, Adoption_Stage__c FROM OpportunityLineItem WHERE OpportunityId IN :oppIds];
            for (OpportunityLineItem oli : olis) {
                String oppStageTemp = mapOliStageToOppStage.get(oli.Adoption_Stage__c);
                if (!mapOppToStage.containsKey(oli.OpportunityId))
                    mapOppToStage.put(oli.OpportunityId, oppStageTemp); //Add Stage if none present yet
                else if (mapOppStageOrder.get(oppStageTemp) > mapOppStageOrder.get(mapOppToStage.get(oli.OpportunityId)))
                    mapOppToStage.put(oli.OpportunityId, oppStageTemp); //Add Stage if higher value
            }
            if (mapOppToStage.size() > 0) {
                List<Opportunity> oppsToUpdate = new List<Opportunity>();
                List<Opportunity> opps = [SELECT Id, StageName, Course_Start_Date__c FROM Opportunity WHERE Id IN :oppIds];
                for (Opportunity opp : opps) {
                    if (mapOppToStage.get(opp.Id) == 'Acceptance' && opp.Course_Start_Date__c != null && opp.Course_Start_Date__c.daysBetween(Date.today()) >= 7)
                        mapOppToStage.put(opp.Id, 'Closed Won');
                    if (opp.StageName <> mapOppToStage.get(opp.Id)) {
                        opp.StageName = mapOppToStage.get(opp.Id);
                        system.debug('LUP: Opp Stage will be changed to ' + opp.StageName);
                        oppsToUpdate.add(opp);
                    }
                }

                if (oppsToUpdate.size() > 0)
                    update oppsToUpdate;
            }
        }
    }
}