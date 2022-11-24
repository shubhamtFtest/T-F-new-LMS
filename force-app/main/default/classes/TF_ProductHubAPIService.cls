@RestResource(urlMapping='/ProductHubService/*')
global with sharing class TF_ProductHubAPIService {
    
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
        jsonStr=jsonStr.replace('"@Id":','"Id":');
        system.debug('**$$%%'+ jsonStr);
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
        UpdateProductRequest request = (UpdateProductRequest)JSON.deserialize(jsonString, UpdateProductRequest.class);
        If (String.isNotBlank(request.status) && String.isNotBlank(request.Id) && (request.status.equalsIgnoreCase('Success') || request.status.equalsIgnoreCase('Failure')))
        {
            try
            {  
                Product2 prd = [SELECT Id, Name,Hub_Id__c,originalProductId__c,IsActive FROM Product2 Where Hub_Id__c=:request.Id order by CreatedDate DESC LIMIT 1];
                prd.APIStatus__c = request.Status;
                prd.API_Error_Cause__c=request.Cause;
                if(string.isBlank(prd.originalProductId__c)){
                    prd.IsActive = true ;
                }
                update prd;
                response.Id=prd.Hub_Id__c;
                response.Status='Success'; 
                response.errorMessage='';
                // trigger platform Event for licence updation
                
                if(request.status=='Success')
                { 
                    if(request.isPartOf != NULL && request.isPartOf.size()>0)
                    { 
                        List<License_Update_Event__e> licenceEventList = new List<License_Update_Event__e>();
                        for (String strHubId : request.isPartOf) {
                            License_Update_Event__e UpdatelicenceEvent = new License_Update_Event__e(hubID__c=strHubId,Update_Type__c='UPDATE_DYNAMIC_LICENSE');
                            // Add event objects to the list.
                            licenceEventList.add(UpdatelicenceEvent);                            
                        }
                        // Call method to publish events
                        List<Database.SaveResult> results = EventBus.publish(licenceEventList);
                        for (Database.SaveResult sr : results) {
                            if (sr.isSuccess()) { 
                                System.debug('Successfully published update_dynamic_licence event.');
                                //response.setError('Successfully published update_dynamic_licence event.');
                            } else {
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Error returned: ' + err.getStatusCode() +' - ' + err.getMessage());
                                }
                            }       
                            
                        }
                        
                    }
                    
                    License_Update_Event__e UpdatelicenceEvent = new License_Update_Event__e(hubID__c=prd.Hub_Id__c,Update_Type__c='UPDATE_DYNAMIC_LICENSE');
                    Database.SaveResult result= EventBus.publish(UpdatelicenceEvent);
                    if (result.isSuccess()) {
                        System.debug('Successfully published update_dynamic_licence event.');                            
                    }                   
                    
                }               
                return JSON.serialize(response);
            }               
            catch(exception e){
                response.Id=request.Id;
                response.Status='Failure';  
                response.errorMessage = 'Some error has occured,Please try again';
                system.debug(e.getMessage());
                return JSON.serialize(response);
            }
        }
        else
        {
            if (request.Id=='' || String.isBlank(request.Id)){
                response.setError('Product JSON does not have mandatory field Id');
                return JSON.serialize(response);
            }
            
            else if (request.Status=='' || String.isBlank(request.Status)){
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
        return requestedUri.substring(requestedUri.lastIndexOf('/ProductHubService/')+13);
    }
    
    private static String operationCommit(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            //if(command.contains('ABC')) {
            //operation = 'ABC';
            //}
            
        } else if(method.equals('POST')) {
            if (command.contains('updateStatus')) {
                operation = 'updateStatus';
            } 
        } 
        
        //else if (method.equals('DELETE')) {
        
        // } 
        //else if (method.equals('PUT')) {
        
        //}
        return operation;
    }
    
    class NoProductsException extends Exception {}
    
}