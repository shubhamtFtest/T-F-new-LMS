/**
Author : Radhikay Banerjee
Test class :  TF_BundleItemDeletionBatchTest
Description : This batch class is used to delete bundle line items of Static Bespoke Collection once submitted to PCM & post acknowledgement from PCM
**/
global class TF_BundleItemDeletionBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global database.querylocator start(Database.BatchableContext BC) {
        Id bespokeRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
        String status = 'Success';
        String query = 'SELECT Id,APIStatus__c FROM Product2 where RecordTypeId =: bespokeRecordTypeId AND APIStatus__c  =: status AND IsActive = true';
        System.debug('TF_BundleItemDeletionBatch SOQL = ' + query);
        return Database.getQueryLocator(query);        

    }
    global void execute(Database.BatchableContext BC, List<Product2> scope){
        
        if(scope != null && scope.size() > 0){
            List<Id> prdIdList = new List<Id>();
            Map<Id,Id> quoteProductMap = new Map<Id,Id>();
            List<Id> deleteBLIforPrdIdList = new List<Id>();
            
            for(Product2 thisProduct : scope){
                prdIdList.add(thisProduct.Id);
            }
            
            List<SBQQ__QuoteLine__c> quoteLineList = [Select Id, SBQQ__Quote__c, SBQQ__Product__c From SBQQ__QuoteLine__c where SBQQ__Product__c IN: prdIdList ];
            
            List<Id> quoteIdList = new List<id>();
            if(quoteLineList != null && quoteLineList.size() > 0){
                for(SBQQ__QuoteLine__c qli : quoteLineList){
                    quoteIdList.add(qli.SBQQ__Quote__c);
                    quoteProductMap.put(qli.SBQQ__Quote__c, qli.SBQQ__Product__c);
                }
                List<Opportunity> oppList = [Select id,StageName,SBQQ__PrimaryQuote__c From Opportunity where SBQQ__PrimaryQuote__c IN: quoteIdList];
                for(Opportunity opp : oppList){
                    if(opp.StageName == 'Closed Won'){
                        Id quoteId = opp.SBQQ__PrimaryQuote__c;
                        deleteBLIforPrdIdList.add(quoteProductMap.get(quoteId));
                    }
                }    
            
            }
            if(deleteBLIforPrdIdList != null && deleteBLIforPrdIdList.size() > 0){
				List<Bundle_Line_Item__c> bundleLineItemList = [SELECT id FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c IN: deleteBLIforPrdIdList ]; 
            	if(bundleLineItemList != null && bundleLineItemList.size() > 0){
                    System.debug('bundleLineItemList : '+bundleLineItemList);
                	Database.delete(bundleLineItemList);
           		} 
        	}
        }   
        
    }    
    global void finish(Database.BatchableContext BC){
      System.debug('TF_BundleItemDeletionBatch: finish');
       
    }
}