/*
** Tested by: zTest_CAS.cls
**
** Automate adding SubjectCodes to CAS Contacts when Opportunity Product is added or created
** Created by Shay Spoonmore (shay.spoonmore@informausa.com)
** Modified by 20140731 Shay Spoonmore (shay.spoonmore@informausa.com)
** Modified by Jeff Lup - 2015.02.27 - Moved Trigger into this TrigClass
*/

public without sharing class CAS_OppLineItemContactSubCode_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            System.debug('##### System.isFuture(): ' + System.isFuture());
            if (!System.isFuture() && !System.isBatch()) {
                //Process CAS OppProducts that have a Recipient to add Subject Codes
                System.debug('##### limits.getFutureCalls(): ' + limits.getFutureCalls());
                System.debug('##### limits.getLimitFutureCalls(): ' + limits.getLimitFutureCalls());
                if (limits.getFutureCalls() < (limits.getLimitFutureCalls()-5))
                    CAS_OppLineItemContactSubCode.AddContactSubjectCodes(trig.newMap.keySet());
            }
        }
    }
}