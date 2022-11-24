public with sharing class TF_CaseUpdateQuoteTrig  implements TriggerInterface_Case.Runnable {
    public void run(TriggerInterface_Case.Trig trig) {
        
        if (trig.isAfter && trig.isInsert) { 
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD APC').getRecordTypeId();
            
            List<SBQQ__Quote__c> quoteListToUpdate = new List<SBQQ__Quote__c>();
            system.debug('@@@ ' + trig.newList);
            for(Case cs : trig.newList){
                if(String.isNotBlank(cs.RecordTypeId) && cs.RecordTypeId == caseRecordTypeId && 
                   String.isNotBlank(cs.Origin) && cs.Origin == 'APC verification' && String.isNotBlank(cs.Description) &&
                   cs.Description.indexOf(Label.Quote_Prefix) != -1){
                   system.debug(cs.Description.substring(cs.Description.indexOf(Label.Quote_Prefix),cs.Description.indexOf(Label.Quote_Prefix)+15));
                    String quoteId = cs.Description.substring(cs.Description.indexOf(Label.Quote_Prefix),cs.Description.indexOf(Label.Quote_Prefix)+15);
                    quoteListToUpdate.add(new SBQQ__Quote__c(id = quoteId, Case__c = cs.Id));   
                }
            }
            
            if(quoteListToUpdate.Size() > 0){
                UPDATE quoteListToUpdate;
            }
        }
    }
}