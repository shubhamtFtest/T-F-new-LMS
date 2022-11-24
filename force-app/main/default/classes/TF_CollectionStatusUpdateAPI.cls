//Test Class-zTEST_TF_CollectionStatusUpdateAPI
@RestResource(urlMapping='/CollectionStatusUpdateAPI/*')
global with sharing class TF_CollectionStatusUpdateAPI  {
    
    global class UpdateProductRequest {
        public String Id;
        public String status;
        public String Cause;
        public String type;
        public List<String> isPartOf;
    }
     
    global class UpdateProductResponse{
        public String Id;
        public String Status;
        public String errorMessage;
        
        public void setError(String errorMessage) {
            this.Status = 'Failure';
            this.errorMessage = errorMessage;
        }
    }
    
    @HttpPost
    global static void doPost() {
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationCommit('POST', command);
        system.debug(RestContext.request.requestBody.tostring());
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
          
       
        if (operation == 'updateStatus') {
            result = updateStatus(jsonStr);
            result=result.replace('"Id":','"@Id":');
        } else {
            result = 'Invalid Resource';
        }
        
        if (result != '' || !String.isBlank(result)){
            RestContext.response.responseBody = Blob.valueOf(result);
        }
        
    }
    
    
    global static String updateStatus(String jsonString){              
        UpdateProductResponse response = new UpdateProductResponse();     
       // UpdateProductRequest request = (UpdateProductRequest)JSON.deserialize(jsonString, UpdateProductRequest.class);
       //TF_ProductHubServiceNewModelWrapper request = (TF_ProductHubServiceNewModelWrapper)JSON.deserialize(jsonString, TF_ProductHubServiceNewModelWrapper.class);
        TF_CollectionStatusUpdateAPIWrapper request = new TF_CollectionStatusUpdateAPIWrapper(); 
        List<TF_CollectionStatusUpdateAPIWrapper.Messages> msg = new List<TF_CollectionStatusUpdateAPIWrapper.Messages>();      
        TF_CollectionStatusUpdateAPIWrapper.metadata meta = new TF_CollectionStatusUpdateAPIWrapper.metadata();      
       TF_CollectionStatusUpdateAPIWrapper.data data = new TF_CollectionStatusUpdateAPIWrapper.data();      
       system.debug('##UpdateStatusJSON##' + jsonString);
        request = (TF_CollectionStatusUpdateAPIWrapper)JSON.deserialize(jsonString, TF_CollectionStatusUpdateAPIWrapper.class);
        system.debug('request###'+request);
        meta=request.Metadata;
        data=request.Data;
        msg=meta.messages;
        If (String.isNotBlank(meta.status) && String.isNotBlank(meta.Id) && (meta.status.equalsIgnoreCase('Success') || meta.status.equalsIgnoreCase('failed')))
        {
            try 
            {  
                Product2 prd = [SELECT Id, Name,Hub_Id__c,originalProductId__c,IsActive,Product_Type_Author_Facing__c FROM Product2 Where Hub_Id__c=:meta.Id order by CreatedDate DESC LIMIT 1];
               // if( prd.IsActive == false){
                    String apiStatus = '';
                    apiStatus = prd.Product_Type_Author_Facing__c == 'Rule based' ? 'Submit To PCM Failed' : 'Failure' ;
                    prd.APIStatus__c = meta.status.equalsIgnoreCase('Success') ? 'Success' : apiStatus ;
                    if(msg != null){
                        String errorMessage='';
                         for(TF_CollectionStatusUpdateAPIWrapper.Messages message : msg){
                             errorMessage=errorMessage+ ','+ message.description; 
                         }
                        if(errorMessage.length()>=254){
                           errorMessage = errorMessage.substring(0, 254); 
                        }
                      
 
                        prd.API_Error_Cause__c=errorMessage;
                    }
                   // prd.API_Error_Cause__c=msg.description;
                    if(string.isBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('available')){
                        prd.IsActive = true ;
                    }
                    if(string.isNotBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('available')){
                        prd.IsSellable__c =true;
                    }
                    
                    //for withdrawn
                    if(string.isBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('withdrawn')){
                        prd.IsActive = false ;
                    }
                    if(string.isNotBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('withdrawn')){
                        prd.IsSellable__c =false;
                    }
                    //for planned
                    if(string.isBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('Planned')){
                        prd.IsActive = false ;
                    }
                    if(string.isNotBlank(prd.originalProductId__c) && meta.status.equalsIgnoreCase('Success')&& Data.collection.status.equalsIgnoreCase('Planned')){
                        prd.IsSellable__c =false;
                    }
                    update prd; 
                //}
                
                response.Id=prd.Hub_Id__c;
                response.Status='Success'; 
                response.errorMessage='';
                
                return JSON.serialize(response);
            }               
            catch(exception e){
                response.Id=meta.Id;
                response.Status='Failure';  
                response.errorMessage = 'Some error has occured,Please try again';
                // response.errorMessage=e.getMessage();
                system.debug(e.getMessage());
                return JSON.serialize(response);
            }
        }
        else
        {
            if (meta.Id=='' || String.isBlank(meta.Id)){
                response.setError('Product JSON does not have mandatory field Id');
                return JSON.serialize(response);
            }
            
            else if (meta.Status=='' || String.isBlank(meta.Status)){
                response.setError('Product JSON does not have mandatory field Status');
                return JSON.serialize(response);
            }
            else{
                response.setError('Invalid Jason');
                return JSON.serialize(response);
            }
            
        }
    }
    
    
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/CollectionStatusUpdateAPI/')+13);
    }
    
    private static String operationCommit(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            
        } else if(method.equals('POST')) {
            if (command.contains('updateStatus')) {
                operation = 'updateStatus';
            } 
        } 
        
        return operation;
    }
    
    
    
}