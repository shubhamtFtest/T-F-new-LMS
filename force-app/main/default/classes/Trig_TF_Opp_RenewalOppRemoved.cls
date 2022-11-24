/*
*    Test Method: zTEST_Trig_TF_Opp_RenewalOppRemoved.class 100%
*/
public class Trig_TF_Opp_RenewalOppRemoved implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && trig.isDelete) {
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            List<Opportunity> prevOpps = [SELECT Id, Previous_Renewal__c, Next_Renewal__c FROM Opportunity WHERE Next_Renewal__c IN :trig.oldMap.keySet()];
            for (Opportunity opp : prevOpps) {
                opp.Reason_No_Renewal__c = 'Renewal Opportunity deleted sometime after clone';
                oppsToUpdate.add(opp);
            }
            if (oppsToUpdate.size() > 0)
                update oppsToUpdate;
        }
    }
}