//Tested by zTEST_TF_Account_SetRegion.cls        100%
//
//Created by Jeff Lup - 2015.12.16 - moved existing Trigger into this Class

public with sharing class TF_Account_SetRegion_Trig implements TriggerInterface_Account.Runnable {
    public void run(TriggerInterface_Account.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.IsUpdate)) {
            if (trig.triggerSize == 1) {
                if (trig.isInsert || (trig.newList[0].Shipping_Country_List__c != trig.oldList[0].Shipping_Country_List__c)) {
                    List<Setting_Item__c> si = [SELECT Text_2__c 
                                                FROM Setting_Item__c 
                                                WHERE Setting__r.Name = 'TF Country Regions' 
                                                AND Text_1__c = :trig.newList[0].Shipping_Country_List__c];
                    if (si.size() > 0)
                        trig.newList[0].Region__c = si[0].Text_2__c;
                }
            }        	
        }
    }
}