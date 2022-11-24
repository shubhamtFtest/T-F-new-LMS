public  class Trig_lockOpp implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            List<SBQQ__Quote__c> listQuote = new List<SBQQ__Quote__c>([ SELECT Name,id,SBQQ__Status__c,SBQQ__Primary__c FROM SBQQ__Quote__c WHERE  SBQQ__Opportunity2__c =:trig.oldList.get(0).id  LIMIT 1 ]);
            Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
            //  || (!listQuote.isEmpty() && listQuote.get(0).SBQQ__Status__c =='Accepted' )
            if ( trig.oldList.get(0).recordtypeid == oppRecordTypeId && ( trig.oldList.get(0).stagename == 'Closed Won' ) && trig.newList.get(0).stagename != 'Closed Lost' ) {
                    trig.newList[0].addError('You can not edit once the opportunity is Closed Won ');
                
            }
        }
    }
}