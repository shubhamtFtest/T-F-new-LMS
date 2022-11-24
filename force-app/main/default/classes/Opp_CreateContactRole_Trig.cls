/*
* Tested by: zTEST_Opp_CreateContactRole.cls    100%
*
* Modified by Jeff Lup - 2014.12.04 - IBI Contact Roles project
* Modified by Jeff Lup - 2015.04.20 - Moved into this TrigClass
*/
public without sharing class Opp_CreateContactRole_Trig implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
            List<Informa_Contact_Role__c> icrs = new List<Informa_Contact_Role__c>();
            for (Integer i=0; i < trig.triggerSize; i++) {
                if (trig.newList[i].Primary_Contact__c != null) {
                    Informa_Contact_Role__c icr = new Informa_Contact_Role__c();
                    icr.Opportunity__c = trig.newList[i].Id;
                    icr.Contact__c = trig.newList[i].Primary_Contact__c;
                    string flag=trig.mapRtIdsToParams.get(trig.newList[i].Recordtypeid).get('Flag');
                    if(String.IsNotBlank(flag) && flag=='IFI')
                    {
                        icr.Contact_Role_s__c = 'Buyer';
                    }
                    else
                    {
                        icr.Contact_Role_s__c = 'Billing;Delivery';
                    }
                    icr.Primary_Contact__c = true;
                    icr.RecordtypeId = trig.mapRtIdsToParams.get(trig.newList[i].Recordtypeid).get('ICR_RT');
                    icrs.add(icr);
                }
            }
            if (icrs.size() > 0)
                insert icrs;
        }
    }
}