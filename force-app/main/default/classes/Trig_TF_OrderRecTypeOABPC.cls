public class Trig_TF_OrderRecTypeOABPC implements TriggerInterface_Order.Runnable {
    public void run(TriggerInterface_Order.Trig trig) {
        Id recordtypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - OA BPC Opportunity').getRecordTypeId();
        system.debug(recordtypeIdOpp);
        Id recordtypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('TF OA BPC Order').getRecordTypeId();
        system.debug(recordtypeIdOrder);
        
        if (trig.isBefore && trig.isInsert) {
            for(order ord : Trig.newList ){
                system.debug('ord.opportunity.RecordTypeId-->'+ord.opportunity.RecordTypeId);
                system.debug('ord.opportunityId'+ord.opportunityId);
                
                // System.debug('ord.opportunity.RecordTypeId-'+ord.opportunity.RecordTypeId);
                if( ord.opportunityId!= null){
                    Opportunity oppRec = new Opportunity();
                    oppRec = [Select Id,RecordTypeId from Opportunity where Id =: ord.opportunityId Limit 1];
                    if(oppRec.RecordTypeId == recordtypeIdOpp){
                        ord.recordtypeId = recordtypeIdOrder;   
                    }
                    
                }
            }            
        }
    }
}