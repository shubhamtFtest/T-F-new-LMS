/*
* Tested by: zTEST_TF_Opp_SubjectAreaRequired       100%
*
* Created by Hailey Niemand, 2014.03.31 - CHG0057509
* Modified by Jeff Lup - 2015.04.23 - moved into this TrigClass
*/
public without sharing class TF_Opp_SubjectAreaRequired_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isBefore && trig.isUpdate) {
            if (trig.triggerSize == 1) {
                if (trig.newList[0].StageName == 'Closed Won' && trig.oldList[0].StageName != 'Closed Won') {
                    TFSettings__c setting = TFSettings__c.getInstance();
                    List<String> products = setting.TokenProducts__c.split(',');

                    List<OpportunityLineItem> olis = [SELECT Id, Subject_Area__c, ProductName__c 
                                                        FROM OpportunityLineItem 
                                                        WHERE OpportunityId = :trig.newList[0].Id 
                                                        AND (Subject_Area__c = null 
                                                            OR Subject_Area__c = '')
                                                        AND ProductName__c IN :products];
                    if (olis.size() > 0)
                        trig.newList[0].addError('You must provide the Subject Area/s for your Article Pass Products.');
                }
            }
        }
    }
}