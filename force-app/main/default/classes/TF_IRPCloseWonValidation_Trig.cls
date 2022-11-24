/*
*  Tested by: zTEST_TF_IRPCloseWonValidation_Trig.cls
*/
public with sharing class TF_IRPCloseWonValidation_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {
            for(Opportunity OppObj : trig.newList){
                if(OppObj.StageName != 'Closed Won' && trig.oldMap.get(OppObj.Id).StageName == 'Closed Won'){
                    trig.newList[0].addError('Your Opportunity has already been Closed Won.');
                }
            }            
        }
    }
}