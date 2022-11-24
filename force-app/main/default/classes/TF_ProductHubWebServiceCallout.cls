global with sharing class TF_ProductHubWebServiceCallout {
    //private static String productHubURI = 'https://api-dev.taylorandfrancis.com/v3/products/newID';
    private static String productHubURI = '/v4/products/new-id';
    
    global class UpdateProductRequest {
        public String Id;          
    }
    
    @future (callout=true)
    Public static void  getHubID(String Id){  
        getHubIDSync(Id);
    }
    
    Public static void  getHubIDSync(String Id){
        String productHubID = null;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        
        try {
            HttpResponse res = null;
            
            res = TF_PlatformExecuter.execute(productHubURI,'GET','idtoken', null, headers, false);
            
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                String responseBody = res.getBody();
                System.debug('********!' + responseBody);
                System.debug('****ResponseCode****!' + res.getStatusCode());
                ProductHubResponse productHubRes = (ProductHubResponse)JSON.deserialize(responseBody, ProductHubResponse.class);
                productHubID = productHubRes.newId;                    
                updateProductHubId(productHubID,Id);
            }else{
                system.debug('#####!DEBUG'+ '' + res);
                system.debug('#####!DEBUG'+ '' + Id); 
                
            }
        } 
        catch (Exception ex) { 
            System.debug('******** Exception : ' + ex.getMessage());     
        }
    }
    
    private static String updateProductHubId(String productHubID,String SFProductId){           
        If (productHubID!='')
        {
            try
            {     system.debug('SFProductId' + ' ' + SFProductId);                   
             Product2 prd = [SELECT Id, Name FROM Product2 Where id = :SFProductId];
             prd.Hub_Id__c = productHubID;              
             update prd;   
             system.debug('update Success');
             Return 'Success';
            } catch(exception e){
                system.debug(e.getmessage() + ' '  + 'update failed');
                Return 'Failed';
            }            
        }
        else{ 
            if (productHubID=='' || String.isBlank(productHubID)){
                Return 'Failed';
            }           
            
        }
        Return 'Success';
    }
    
    class ProductHubResponse {
        private String newId;
    }
    
}