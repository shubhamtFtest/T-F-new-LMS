global class TF_Batch_GetUUIDsForDOIs implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String prdId;
    Boolean allBatchesSuccessful = true;
    public TF_Batch_GetUUIDsForDOIs(String productId) {
        prdId = productId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
      //  string validationStatus = 'false' ;
        
        String queryString = 'SELECT id, Product_Bundle_Parent__c, doi__c, Content_ID__c, Journal__c,Publication_Date__c, Title__c, Authors__c, Product_Publisher__c, Open_access__c, Content_Position__c,Publisher__c FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =:prdId and uuid__c  = null and doi__c != null ORDER BY Content_Position__c'; 
        
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {
        Map<String,String> doiIdMap = new Map<String,String>();
        List<Bundle_Line_Item__c> updateBLItms = new List<Bundle_Line_Item__c>();
        TF_ProcessUnsiloresponse.LineitemsUUID lItmsUUID ;
        for(Bundle_Line_Item__c bli : bLItms){
            doiIdMap.put(bli.doi__c , bli.id);
        }
        
        TF_GenerateJson.ValidationJson valJson ;
        DateTime now = Datetime.now();
        String s3JsonString ;
        valJson = TF_GenerateJson.GenerateValidationJson(prdId, now, 0, 0, 0, bLItms);
        if(!String.isBlank(valJson.jsonString)){ 
            s3JsonString = valJson.jsonString;
            lItmsUUID = TF_ProcessUnsiloresponse.getUUIDForContentList(prdId, s3JsonString, doiIdMap);
            if(lItmsUUID.msg == 'Success' && allBatchesSuccessful == true){
                allBatchesSuccessful = true ;
                if(lItmsUUID.bundleItmsList != null && (lItmsUUID.bundleItmsList).size() > 0){
                    Database.SaveResult[] srList = Database.update(lItmsUUID.bundleItmsList, false);
                }
            }else{
                allBatchesSuccessful = false ;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) { 
        if(allBatchesSuccessful){
            product2 prd = new product2();
            prd.id = prdId ; 
            prd.Approval_Status__c = 'Pending';
            prd.APIStatus__c = 'Validation Complete';
            update(prd);
        }else{
             product2 prd = new product2();
            prd.id = prdId ; 
            prd.Approval_Status__c = 'Pending';
            prd.APIStatus__c = 'GetUUID Incomplete';
            update(prd);
        }
    }   
}