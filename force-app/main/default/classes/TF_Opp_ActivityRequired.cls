//renamed to Trig_TF_Opp_ActivityRequired.cls
public without sharing class TF_Opp_ActivityRequired {
/*
public without sharing class TF_Opp_ActivityRequired implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isUpdate && trig.isBefore) {
            if (trig.newList[0].StageName == 'Closed Won' && trig.oldList[0].StageName != 'Closed Won' && trig.newList[0].CurrencyISOCode != 'AUD' && trig.newList[0].Parent_Opportunty__c == null){
                List<Task> taskList = [SELECT Id FROM Task WHERE WhatId IN :trig.newMap.keySet()];
                List<Event> eventList = [SELECT Id FROM Event WHERE WhatId IN :trig.newMap.keySet()];
                if (taskList.Size() < 1 && taskList.Size() < 1)
                    trig.newList[0].addError('Your Opp must have at least one Activity to be moved to Closed Won.  Activities include emails which you may record using Linkpoint, or calls and visits, which you may record manually by selecting "Log A Call" under "Activities".');
            }
        }
    }
*/
}