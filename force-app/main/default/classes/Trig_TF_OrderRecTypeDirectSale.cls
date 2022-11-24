public class Trig_TF_OrderRecTypeDirectSale implements TriggerInterface_Order.Runnable {
    public void run(TriggerInterface_Order.Trig trig) {
        Id recordtypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        system.debug(recordtypeIdOpp);
        Id recordtypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Automated eBook Direct Sales Order').getRecordTypeId();
        system.debug(recordtypeIdOrder);

        if (trig.isBefore && trig.isInsert) {
            for(order ord : Trig.newList ){
                // System.debug('ord.opportunity.RecordTypeId-'+ord.opportunity.RecordTypeId);
                if( ord.opportunity!= null && ord.opportunity.RecordTypeId == recordtypeIdOpp )ord.recordtypeId = recordtypeIdOrder;
            }            
        }
    }
}