/***************************************************************************************
Author : Vikas Varshney
Description : This class updates fields on order standard object from SBQQ__Quote__c SFAL-160
Test class : zTest_TF_OrderUpdateLMS_Trigger
***************************************************************************************/


public with sharing class TF_OrderUpdateLMS_Trigger implements TriggerInterface_Order.Runnable {
    public void run(TriggerInterface_Order.Trig trig) {
        Map<String, String> orderIdToquoteIdMap = new Map<String, String>();
        String automatedRTId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Automated eBook Direct Sales Order').getRecordTypeId();
        
        //Iterating order list to get order Ids and quote Ids
        if ( trig.isAfter && ( trig.isInsert ) ) {
            if ( !trig.newList.isEmpty() ) {
                for ( Order ord : trig.newList ) {
                    if ( ord.SBQQ__Quote__c != Null && ord.RecordTypeId == automatedRTId ) {
                        orderIdToquoteIdMap.put( ord.id, ord.SBQQ__Quote__c );
                    }
                }
            }
        }
        System.debug('orderIdToquoteIdMap size =====>' + orderIdToquoteIdMap.size());
        System.debug('orderIdToquoteIdMap =====>' + orderIdToquoteIdMap);
        
        try {
            if ( !orderIdToquoteIdMap.isEmpty() ) {
                updateOrderLMS( orderIdToquoteIdMap );
            }
        } catch ( Exception ex ) {
            System.debug('************ Order Trigger Exception ************' + ex.getMessage());
            System.debug('************ Order Trigger Exception Line ************' + ex.getLineNumber());
        }
    }
    
    private void updateOrderLMS( Map<String, String> orderIdToquoteIddMap ) {
        List<Order> orderUpdateList = new List<Order>();
        
        if ( !orderIdToquoteIddMap.isEmpty() ) {
            for ( Order ord : [ SELECT id, SBQQ__Quote__c, SBQQ__Quote__r.TF_eBook_Subscription_Start_Date__c, SBQQ__Quote__r.TF_eBook_Subscription_End_Date__c, SBQQ__Quote__r.Business_Model__c FROM Order WHERE id IN :orderIdToquoteIddMap.keySet() AND SBQQ__Quote__c IN :orderIdToquoteIddMap.values() ] ) {
                orderUpdateList.add( new Order( Id = ord.id, TF_eBook_Subscription_Start_Date__c = ord.SBQQ__Quote__r.TF_eBook_Subscription_Start_Date__c, TF_eBook_Subscription_End_Date__c = ord.SBQQ__Quote__r.TF_eBook_Subscription_End_Date__c, Business_Model__c = ord.SBQQ__Quote__r.Business_Model__c ) );
            }
        }
        
        if ( !orderUpdateList.isEmpty() ) {
            update orderUpdateList;
            System.debug('orderUpdateList size =====>' + orderUpdateList.size());
            System.debug('orderUpdateList =====>' + orderUpdateList);
        }
    }
}