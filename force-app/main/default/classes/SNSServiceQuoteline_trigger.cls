/*Created By: Piyush Jain
 *Description: Used to send SNS message(Quote Creation) on Quote Line Creation in SF as part of FSD Project
 *Test Class: SNSServiceFSDTest
**/
public class SNSServiceQuoteline_trigger implements TriggerInterface_SBQQ_QuoteLine.Runnable{
    public static Map<Id,SNSServiceQuote_Handler.RequestBody> messageBodyyMap = new Map<Id,SNSServiceQuote_Handler.RequestBody>();
    
    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig){
        System.debug('@@@@@Trigger SNSServiceQuoteline_Trigger start');
        Set<Id> quoteIdSet = new Set<Id>();
        Map<Id, SBQQ__Quote__c> quoteIdToQuoteMap = new Map<Id, SBQQ__Quote__c>();
        List<SBQQ__Quote__c> quoteUpdateList = new List<SBQQ__Quote__c>();
        
        for (SBQQ__QuoteLine__c ql : trig.newList){
            System.debug('SBQQ__ListPrice__c =====>' + ql.SBQQ__ListPrice__c);
            System.debug('SBQQ__Discount__c =====>' + ql.SBQQ__Discount__c);
            System.debug('SBQQ__AdditionalDiscountAmount__c =====>' + ql.SBQQ__AdditionalDiscountAmount__c);
            System.debug('SBQQ__NetPrice__c =====>' + ql.SBQQ__NetPrice__c);
            quoteIdSet.add(ql.SBQQ__Quote__c);
            System.debug('quoteIdSet =====>' + quoteIdSet);
        }
        
        if(trig.isAfter && trig.isInsert){
            System.debug('@@@@@Is After Insert =====>');
            Id quoteRecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('T&F - CPQ Quote').getRecordTypeId();
            
            for ( SBQQ__Quote__c quo : [ Select id, Is_Create_Quote__c, recordTypeId FROM SBQQ__Quote__c WHERE Id IN :quoteIdSet AND Is_Create_Quote__c = true AND recordTypeId =: quoteRecordTypeId] ) {
                quoteIdToQuoteMap.put(quo.id, quo);
                system.debug('@Passed!!');
            }
            //Shalini added 
            System.debug('@quoteIdToQuoteMap '+quoteIdToQuoteMap);
            if(quoteIdToQuoteMap != null && !quoteIdToQuoteMap.isEmpty())
                SNSServiceQuote_Handler.processRequest(quoteIdSet,null,quoteIdToQuoteMap);
            //Shalini changes end 
           
        }  
    }
    
    
}