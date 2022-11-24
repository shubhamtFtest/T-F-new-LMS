/*
** Tested by: zTest_CsatStatusInCase @ 100%
** Story no. DF-327 on Digital Foundation project
** Updated by Tom Reed 2018-11-12: Added criteria to only included csat records where Survey_Status__c = 'Response Received'.
**This trigger will update corresponding case to the newly inserted csat and will make its CSAT received field, checked
*/
public with sharing class CsatStatusInCase_Trig implements TriggerInterface_CSAT.Runnable {
    public void run(TriggerInterface_CSAT.Trig trig) {  
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            Set<Id> caseIds=new Set<Id>();            
            for(CSAT__c obj: Trig.newList){
                //Only add the case if the csat records Survey_Status__c = 'Response Received'
                if(obj.Survey_Status__c == 'Response Received'){
                    caseIds.add(obj.Case__c);           
                }
            }
            List<Case> casesToUpdate=new List<Case>();
            for(Id i:caseIds){
                Case newCase=new Case();
                newCase.Id=i;
                newCase.csat_received__c=true;
                casesToUpdate.add(newCase);
            }
            update casesToUpdate;
            
        }
    }
}