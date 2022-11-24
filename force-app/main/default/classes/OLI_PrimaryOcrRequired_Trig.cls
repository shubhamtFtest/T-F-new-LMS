/*
 * This class causes a Primary OCR record to be created before an OLI can be created
 * This class is meant for UI validation, so no bulkification is required.
 * 
 * Created by Jeff Lup - 2019.04.19
** Tested by: zTEST_OLI_PrimaryOcrRequired_Trig.cls      100%
*/

public without sharing class OLI_PrimaryOcrRequired_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
            
            Opportunity opp = [SELECT Id, CreatedDate FROM Opportunity WHERE Id = :trig.newList[0].OpportunityId];
            long diffOppOliTime = (trig.newList[0].CreatedDate.getTime() - opp.CreatedDate.getTime())/1000;
            
            system.debug('Opp created: ' + opp.CreatedDate);
            system.debug('Oli created: ' + trig.newList[0].CreatedDate);
            system.debug('Opp/Oli Time Diff: ' + diffOppOliTime);
            
            if (diffOppOliTime > 10 || test.isRunningTest()) {
                List<OpportunityContactRole> primaryOcr = [SELECT Id FROM OpportunityContactRole
                                                           WHERE OpportunityId = :trig.newList[0].OpportunityId
                                                            AND IsPrimary = true];
                if (primaryOcr.size() < 1) {
                    trig.newList[0].addError('Primary Contact Role is required before adding a product to your opportunity.');
                }
            } else {
                system.debug('likely inside a lead convert, so do not fire the validation');
            }
        } 
    }
}