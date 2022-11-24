/*
* This class changes Opportunity Stages based on the action
* When setup in Trigger_Recordtype__c, it should be configured to only run for "T&F - India Reprint"
* 
* Created by Amit Kumar- 2020.03.12
** Tested by: zTEST_TF_IRP_UpdateOppStage_Trig.cls      100%
*/

public without sharing class TF_IRP_UpdateOppStage_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        Set<Id> oppIds = new Set<Id>();
        for(integer i=0; i < trig.triggerSize; i++) {
            if (trig.isAfter && (trig.isInsert || (trig.isUpdate))) {
                oppIds.add(trig.newList[i].Id);
            }
        }
        system.debug('oppIds::'+oppIds);
        if (oppIds.size() > 0) {          
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            List<Opportunity> opps = [SELECT Id, StageName, Is_Reprint_Eligibility_Request_Sent__c, Is_Reprint_Eligibility_Checked__c, 
                                      Is_Pricing_Request_Sent__c, Is_UMC_Request_Sent__c, Is_MRP_Request_Sent__c, 
                                      Is_Pricing_Entered__c, Is_Approved__c, Course_Start_Date__c FROM Opportunity WHERE Id IN :oppIds];
            for (Opportunity opp : opps) {
                    if ((opp.StageName != 'Closed Lost') && (opp.Is_Reprint_Eligibility_Request_Sent__c == true && opp.Is_UMC_Request_Sent__c == false 
                        && opp.Is_MRP_Request_Sent__c == false && opp.Is_Pricing_Entered__c == false && opp.Is_Approved__c == false)) {
                            system.debug('StageLog::Investigating');
                        opp.StageName = 'Investigating';
                    } else if((opp.StageName != 'Closed Lost') && (opp.Is_Reprint_Eligibility_Request_Sent__c == true && opp.Is_Reprint_Eligibility_Checked__c == true
                       && opp.Is_UMC_Request_Sent__c == true && opp.Is_MRP_Request_Sent__c == false && opp.Is_Pricing_Entered__c == false
                       && opp.Is_Approved__c == false)) {
                           system.debug('StageLog::Evaluating');
                        opp.StageName = 'Evaluating';                                        
                    } else if((opp.StageName != 'Closed Lost') && (opp.Is_Reprint_Eligibility_Request_Sent__c == true && opp.Is_Reprint_Eligibility_Checked__c == true
                       && opp.Is_UMC_Request_Sent__c == true && opp.Is_MRP_Request_Sent__c == true && opp.Is_Pricing_Entered__c == false
                       && opp.Is_Approved__c == false)) {
                           system.debug('StageLog::Negotiation');
                        opp.StageName = 'Negotiation';                                        
                    } else if((opp.StageName != 'Closed Lost') && (opp.Is_Reprint_Eligibility_Request_Sent__c == true && opp.Is_Reprint_Eligibility_Checked__c == true
                       && opp.Is_UMC_Request_Sent__c == true && opp.Is_MRP_Request_Sent__c == true && opp.Is_Pricing_Entered__c == true
                       && opp.Is_Approved__c == false)) {
                           system.debug('StageLog::Acceptance');
                        opp.StageName = 'Acceptance';                                        
                       }
                oppsToUpdate.add(opp);
            }
            system.debug('oppsToUpdate::'+oppsToUpdate);
            //update opportunity
            if (oppsToUpdate.size() > 0) {
                update oppsToUpdate;
            }
        }
    }
}