global class TF_Batch_DeleteInvalidContent implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    private String prdId;
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    public TF_Batch_DeleteInvalidContent(String productId) {
        prdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
		string validationStatus = 'false' ;
        
        String queryString = 'SELECT id FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c = :prdId and Valid__c = :validationStatus'; 
        
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {

        Database.DeleteResult[] drList = Database.delete(bLItms, false);
    }
    
    global void finish(Database.BatchableContext BC) { 
        TF_PPDProcessController.submitCollectionImageonS3(prdId);
        String jobId = Database.executeBatch(new TF_Batch_GetUUIDsForDOIs(prdId), 5000);
        }   
}