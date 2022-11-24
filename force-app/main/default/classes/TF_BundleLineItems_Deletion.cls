/***************************************************************************
Author : Shubham Kumar
Description : This class deletes the related products and All the associated bundle Line items to the Quote Line Item.
****************************************************************************/


public with sharing class TF_BundleLineItems_Deletion implements TriggerInterface_SBQQ_QuoteLine.Runnable {
    
    public void run(TriggerInterface_SBQQ_QuoteLine.Trig trig) {
        List<Id> prodIds = new List<Id>();
        List<Id> quoteIds = new List<Id>();
        List<Bundle_Line_Item__c> BLIlist = new List<Bundle_Line_Item__c>();
        List<PriceBookEntry> PBEList = new List<PriceBookEntry>();
        map<id,String> quoteIdbyRecordType = new map<id,String>();
        String recordTypeId = PCMOppSyncControllerDS.getProdRecordTypeId('SBQQ__Quote__c','Automated eBook Direct Sales Orders');
        
        if ( trig.isAfter && ( trig.isDelete ) ) {
            if ( !trig.oldList.isEmpty() ) {
                for ( SBQQ__QuoteLine__c lic : trig.oldList ) {
                    system.debug('lic.SBQQ__Quote__r.RecordTypeId'+lic.SBQQ__Quote__c);
                    if(lic.SBQQ__Quote__c != null ){
                        quoteIds.add(lic.SBQQ__Quote__c);
                    }
                    
                }
            }
            
            List<SBQQ__Quote__c> QuoteList =  [Select id, Record_Type_Name__c ,RecordTypeId from SBQQ__Quote__c where Id IN:quoteIds];
            for(SBQQ__Quote__c quote : QuoteList){
                quoteIdbyRecordType.put(quote.Id,quote.RecordTypeId);
            }
            System.debug('Coming here'+quoteIdbyRecordType);
            if ( !trig.oldList.isEmpty() ) {
                for ( SBQQ__QuoteLine__c lic : trig.oldList ) {
                    system.debug('lic.SBQQ__Quote__r.RecordTypeId'+lic.SBQQ__Quote__c);
                    if(lic.SBQQ__Quote__c != null && quoteIdbyRecordType.get(lic.SBQQ__Quote__c) == recordTypeId && lic.SBQQ__Bundled__c == true){
                        System.debug('Coming here'+lic.SBQQ__Bundled__c);
                        prodIds.add( lic.SBQQ__Product__c );
                    }
                }
            }
            
            System.debug('prodIds size =====>' + prodIds.size());
            System.debug('prodIds =====>' + prodIds);
        }
        try {
            if ( !prodIds.isEmpty() && prodIds.size() >0 && prodIds!= null) {
                String jobId = Database.executeBatch(new TF_Batch_DeleteBundleLineItemsAndProduct(prodIds[0]),9000);
               
            }
        }catch(Exception ex){
            System.debug('************ Asset Trigger Exception ************' + ex.getMessage());
        }
    }
}