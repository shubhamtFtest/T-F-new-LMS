/*
** Tested by: zTEST_OLI_CalculateDiscount_Trig.cls      100%
**
** Modified by Jeff Lup - 2015.03.02 - Moved Trigger to this Class
*/

public without sharing class OLI_CalculateDiscount_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            for (OpportunityLineItem oli : trig.newList) {    
                oli.Discount = 0;
                if (oli.Client_Discount_Percentage__c != null)
                    oli.Discount = oli.Client_Discount_Percentage__c;
                else if (oli.Misc_Discount__c != null)
                    oli.Discount = ((oli.Misc_Discount__c / oli.UnitPrice) * 100);
            }
        }
    }
}