global class TF_Batch_PlaceContentToProductHub implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String prdId;
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    public TF_Batch_PlaceContentToProductHub(String productId) {
        prdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        
        String queryString = 'SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c,mediaType__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =: prdId ORDER BY Content_Position__c'; 
        
        system.debug('queryString'+queryString);
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {
        system.debug('=====inside execute======');

        fullBLItms.addAll(bLItms);
        
    }
    
    global void finish(Database.BatchableContext BC) { 
        
        String jsonString = TF_GenerateJson.GenerateS3Json(prdId, fullBLItms);
        TF_ProcessUnsiloresponse.putCollectionJsonToS3AndNotify(prdId, jsonString);
        
      /*  Product2 prd = [Select id,name,originalProductId__c from product2 where id=:prdId];
        if(prd.originalProductId__c!=null && prd.originalProductId__c!='')
        {
            // TF_PPDProcessController.restoreClonedProductToOriginal(prd.Id,prd.originalProductId__c);
            String jobId = Database.executeBatch(new TF_Batch_updOriginalPrdDeleteBundelItms(prd.originalProductId__c,prd.Id), 9000);
        }*/
    }   
}