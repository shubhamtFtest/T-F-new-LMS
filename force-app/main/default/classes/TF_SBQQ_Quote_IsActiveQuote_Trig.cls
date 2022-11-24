public with sharing class TF_SBQQ_Quote_IsActiveQuote_Trig implements TriggerInterface_SBQQ_Quote.Runnable {     
    public void run(TriggerInterface_SBQQ_Quote.Trig trig) {         
        
        Set<String> quoteDOIs = new Set<String>();
        Map<Id, SBQQ__Quote__c> quoteMap = trig.oldMap;
        for(SBQQ__Quote__c quoteRec : trig.newList){
            if (trig.isAfter && (trig.isInsert || (trig.isUpdate && quoteMap.get(quoteRec.Id).DOI__c != quoteRec.DOI__c))) {
            //if (trig.isAfter && (trig.isInsert || (trig.isUpdate))) {
                quoteDOIs.add(quoteRec.DOI__c);
            }
        }
        
        if(!quoteDOIs.isEmpty()){              
            List<SBQQ__Quote__c> qutObjListOuter = [SELECT Id, Name, DOI__c, Active_Quote__c FROM SBQQ__Quote__c WHERE DOI__c in :quoteDOIs order by Name DESC];           
            Map<String, Id> mapOfQuotes = new Map<String, Id>();           
            for(SBQQ__Quote__c qtOuter: qutObjListOuter){
                if(!mapOfQuotes.containsKey(qtOuter.DOI__c)){
                    mapOfQuotes.put(qtOuter.DOI__c, qtOuter.Id);
                }
            } 
            
            List<SBQQ__Quote__c> quotesToDeactivate = new List<SBQQ__Quote__c>();
            List<SBQQ__Quote__c> listOfQuotes = [SELECT Id FROM SBQQ__Quote__c WHERE DOI__c IN :mapOfQuotes.keySet()];
            for(SBQQ__Quote__c qtObj: listOfQuotes){
                quotesToDeactivate.add(new SBQQ__Quote__c(Id = qtObj.Id, Active_Quote__c = false)); 
            }
            
            if(!quotesToDeactivate.isEmpty()){             
                update quotesToDeactivate; // deactivate duplicates                 
            }
                     
            List<SBQQ__Quote__c> quotesToActivate = new List<SBQQ__Quote__c>();
            for (Id quoteId : mapOfQuotes.values()){
                quotesToActivate.add(new SBQQ__Quote__c(Id = quoteId, Active_Quote__c = true));
            }
            
            if(!quotesToDeactivate.isEmpty()){
                update quotesToActivate; //activate latest quote 
            }
        }
    }
}