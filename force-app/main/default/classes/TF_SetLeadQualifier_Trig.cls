//Tested by zTEST_CLC_TF.cls		100%
//
//Created by Jeff Lup - 2015.11.19 - moved existing Trigger into this Class

public with sharing class TF_SetLeadQualifier_Trig implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            Id userId = Userinfo.getUserId();
            for (Integer i = 0; i < trig.TriggerSize; i++) {
                trig.newList[i].Lead_Qualifier__c = userId;
            }
        }
    }
}