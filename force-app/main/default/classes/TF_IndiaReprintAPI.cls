@RestResource(urlMapping='/IndiaReprintService/*')
global with sharing class TF_IndiaReprintAPI {
    
    global class UpdateProductRequest {
        public String opportunityId;
        public String runStatus;
        public String msg;
        public Boolean status;
        public LineItems[] lineItems;
    }
    
    public class LineItems {
        public Id productid;
        public String isbn;
        public String status;
        public String remarks;
    }    
    
    global class UpdateProductResponse{
        public String Id;
        public Boolean Status;
        public String errorMessage;
        
        public void setError(String errorMessage) {
            this.Status = false;
            this.errorMessage = errorMessage;
        }
    }
    
    @HttpPost
    global static void doPost() {
        String result               = '';
        String command              = getCommand(RestContext.request.requestURI);
        String operation            = operationCommit('POST', command);
        String jsonStr              = RestContext.request.requestBody != null ? RestContext.request.requestBody.toString() : null;
        jsonStr = jsonStr.replace('"@Id":','"Id":');
        system.debug('**@@jsonStr@@::'+ jsonStr);
        if (operation == 'updatProductStatus') {
            result = updatProductStatus(jsonStr);
        } else {
            result = 'Invalid Resource';
        }
        if (result != '' || !String.isBlank(result)){
            RestContext.response.responseBody = Blob.valueOf(result);
        } 
    }
    
    global static String updatProductStatus(String jsonString){              
        UpdateProductRequest request = (UpdateProductRequest)JSON.deserialize(jsonString, UpdateProductRequest.class);
        UpdateProductResponse response = new UpdateProductResponse();                   
        If (String.isNotBlank(request.opportunityId) && String.isNotBlank(request.runStatus))
        { 
            Id oppId = request.opportunityId;
            String runStatus = request.runStatus;             
            List<OpportunityLineItem> olisToBeUpdated = new List<OpportunityLineItem>();
            for(LineItems item: request.lineItems) {
                OpportunityLineItem oli = new OpportunityLineItem(); 
                oli.Id = item.productid;           
                oli.Reprint_Eligibility__c = item.status;
                oli.Remarks__c = item.remarks;
                olisToBeUpdated.add(oli);              
            }
            try{
                list<OpportunityLineItem> olis = new list<OpportunityLineItem>([select Id,ProductCode,Reprint_Eligibility__c from OpportunityLineItem 
                                                                                WHERE opportunityId =:request.opportunityId ORDER BY Name DESC]);                       
                
                //update opporunity
                List<opportunity> oppObj = [select Id,Overall_Reprint_Eligibility__c,Is_Reprint_Eligibility_Checked__c from opportunity where Id =:oppId LIMIT 1];
                if(oppObj.size() > 0){
                    oppObj[0].Overall_Reprint_Eligibility__c = runStatus;
                    oppObj[0].Is_Reprint_Eligibility_Checked__c = true;
                    update oppObj;
                }
                
                //update opporunity line items
                if(!olisToBeUpdated.isEmpty()) {
                    update olisToBeUpdated;
                }
                sendEmailNotification(oppId);
                response.Id = oppId;
                response.Status = true; 
                response.errorMessage = '';            
                return JSON.serialize(response);  
            }catch(exception e){
                response.Id = oppId;
                response.Status = false;  
                response.errorMessage = 'Some error has occured,Please try again';
                system.debug(e.getMessage());
                return JSON.serialize(response);            
            }
        }else{
            if (request.opportunityId == '' || String.isBlank(request.opportunityId)){
                response.setError('Request JSON does not have mandatory field Id');
                return JSON.serialize(response);
            }else if (request.runStatus == '' || String.isBlank(request.runStatus)){
                response.setError('Request JSON does not have mandatory field runStatus');
                return JSON.serialize(response);                
            }else{
                response.setError('Invalid Jason');
                return JSON.serialize(response);                
            }
        }
    }
    
    private static String getCommand(String requestedUri) {
        return requestedUri.substring(requestedUri.lastIndexOf('/IndiaReprintService/')+13);
    }
    
    private static String operationCommit(String method, String command) {
        String operation = 'unknown';
        if (method.equals('GET')) {
            //if(command.contains('ABC')) {
            //operation = 'ABC';
            //} 
        } else if(method.equals('POST')) {
            if (command.contains('updatProductStatus')) {
                operation = 'updatProductStatus';
            } 
        } 
        return operation;
    }
    
    /**
    * Method to send send reprint eligibility email notification 
    */    
    public static void sendEmailNotification(Id oppId){
        try {
            List<Opportunity> oppLst = [SELECT Id, Name, CreatedBy.Name, CreatedBy.Email, Owner.name, Owner.email FROM Opportunity WHERE Id =:oppId];                       
            Opportunity opp = oppLst[0];            
            Contact contact = [SELECT Id FROM Contact LIMIT 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea[0].Id);
            }
            email.setTargetObjectId(contact.Id);
            email.setTreatTargetObjectAsRecipient(false);
            email.saveAsActivity = false;
            String[] toAddresses = new String[] {opp.CreatedBy.Email, opp.Owner.email};
            email.setToAddresses(toAddresses);
            email.setSubject('India Reprint – Reprint Eligibility Status Update');             
            String bodyStr='<html>';
            bodyStr+='<head><title>India Reprint – Reprint Eligibility Status Update</title></head><body>';           
            bodyStr+='<table width="550" border="0">';
            bodyStr+='<tr><td>Dear '+ opp.CreatedBy.Name +' , '+ opp.Owner.Name +' <br><br>';
            bodyStr+=' Please note that the opportunity <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oppId +'" target="_blank"><b>'+ opp.Name +'</b></a>';
            bodyStr+=' has status (PASSED/FAILED/PARTIALLY PASSED) the eligibility criteria.</td></tr>';
            bodyStr+='<tr><td><br>With regards,<br>CSD Team</td></tr></table>';
            bodyStr+='</body></html>';
            email.setHtmlBody(bodyStr);            
            emailList.add(email);            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
        } 
        catch(Exception e){
            System.debug('Error'+e.getMessage());
        }
    }     
    class NoProductsException extends Exception {}
}