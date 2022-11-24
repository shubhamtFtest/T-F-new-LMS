trigger OACOpportunityCurrencyUpdate_Trg on TFOAC_Opportunity__c (before insert, before update,after update) {
    
    List<Id> TFOACOppIds = new List<Id>();
    if(Trigger.Isbefore){
        for(TFOAC_Opportunity__c OACOpp : Trigger.new){
            if(Trigger.IsInsert && OACOpp.CurrencyIsoCode !=null){
                OACOpp.Currency_Code__c = OACOpp.CurrencyIsoCode;
             }  
            
            else if(Trigger.IsUpdate && OACOpp.Currency_Code__c != null && Trigger.OldMap.get(OACOpp.Id).Currency_Code__c != OACOpp.Currency_Code__c){
                OACOpp.CurrencyIsoCode = OACOpp.Currency_Code__c;
                TFOACOppIds.add(OACOpp.Id);
                System.debug('old : '+Trigger.OldMap.get(OACOpp.Id).Currency_Code__c );
            }
            
           // System.debug('after : '+Trigger.IsUpdate);
            System.debug('cur : '+OACOpp.Currency_Code__c );
        }
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
    
        for(TFOAC_Opportunity__c OACOpp : Trigger.new){
            if(Trigger.IsUpdate && OACOpp.Currency_Code__c != null && Trigger.OldMap.get(OACOpp.Id).Currency_Code__c != OACOpp.Currency_Code__c){
                TFOACOppIds.add(OACOpp.Id);
            }
        }
        System.debug('TFOACOppIds : '+TFOACOppIds );
        List<TFOAC_Journal__c> UpdateJournal = new List<TFOAC_Journal__c>();
        if(trigger.new != trigger.old){
            List<TFOAC_Journal__c> lstJournal = [SELECT Id, CurrencyIsoCode, OACOpportunity__r.CurrencyIsoCode FROM TFOAC_Journal__c WHERE OACOpportunity__c = :TFOACOppIds];
            if(lstJournal.size()>0 && lstJournal != null){
                for(TFOAC_Journal__c oJournal : lstJournal){
                    oJournal.CurrencyIsoCode =  oJournal.OACOpportunity__r.CurrencyIsoCode;
                    System.Debug('Avi - '+oJournal.CurrencyIsoCode +' : '+oJournal.OACOpportunity__r.CurrencyIsoCode);
                    UpdateJournal.add(oJournal) ;
                 }
                 update UpdateJournal;
            } 
        } 
    } 
}