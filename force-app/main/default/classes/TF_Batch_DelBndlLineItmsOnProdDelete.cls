global class TF_Batch_DelBndlLineItmsOnProdDelete implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String prdId;
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    public TF_Batch_DelBndlLineItmsOnProdDelete(String productId) {
        prdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        
        String queryString = 'SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = NULL'; 
        
        system.debug('queryString'+queryString);
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {
        system.debug('=====inside execute======');

        fullBLItms.addAll(bLItms);
        database.delete(fullBLItms, false);  
        
    }
    
    global void finish(Database.BatchableContext BC) { 
        
        //String jsonString = TF_GenerateJson.GenerateS3Json(prdId, fullBLItms);
        //TF_ProcessUnsiloresponse.putCollectionJsonToS3AndNotify(prdId, jsonString);
        System.debug('All Items have been deleted successfully!!');
        
     
    }   
}