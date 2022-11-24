global class TF_Batch_SubmitStaticColToPcm implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String prdId;
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    
    public TF_Batch_SubmitStaticColToPcm(String productId) {
        prdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        String isDelete='IsDelete';
        String queryString = 'SELECT id,name,Title__c,Content_ID__c,uuid__c, Open_access__c, Type__c, Source__c,mediaType__c,Content_Position__c,lineItemActualStatus__c, Product_Bundle_Parent__r.RecordTypeId FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =: prdId and uuid__c != null and lineItemStatus__c != :isDelete ORDER BY Content_Position__c'; 
        
        system.debug('queryString'+queryString);
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {
        system.debug('=====inside execute======');

        fullBLItms.addAll(bLItms);
        
    }
    
    global void finish(Database.BatchableContext BC) { 
        //SFAL-158 Vikas Varshney
        //Adding condition for Bespoke collection
        Id productBespokeRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - BespokeCollection').getRecordTypeId();
        String jsonString = '';
        
        if ( !fullBLItms.isEmpty() && productBespokeRT == fullBLItms[0].Product_Bundle_Parent__r.RecordTypeId ) {
            jsonString = TF_GenerateJson.GenerateCommonModelJsonBespokeLMS(prdId, fullBLItms,null);
        } else {
            jsonString = TF_GenerateJson.GenerateCommonModelJson(prdId, fullBLItms,null);
        }
        
        //TF_ProcessUnsiloresponse.putCollectionJsonToS3AndNotify(prdId, jsonString);
        TF_PPDProcessController.submitStaticPackageToPCMCommonModel(prdId, jsonString);
      
    }   
}