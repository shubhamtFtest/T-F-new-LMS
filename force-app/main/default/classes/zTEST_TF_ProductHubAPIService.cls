@isTest
Private with sharing class zTEST_TF_ProductHubAPIService {
    static final String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();
    private static testmethod void UpdateProductRequest(){
        test.startTest();
        String Id='';
        String status='';
        String Cause='';
        String type='';
        List<String> isPartOf;
        test.stopTest();
    }
    
    private static testmethod void UpdateProductResponse(){
         test.startTest();
         String Id='';
         String Status='';
         String errorMessage='';
        test.stopTest();
    }
    
   
    
    static TestMethod void testAPIcallwithTypeUpdate() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '919191919191';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.Hub_Id__c;
        request.Status='Success';   
        request.type='update';
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
     static TestMethod void testAPIcallwithTypeDelete() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '919191919191';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.Hub_Id__c;
        request.Status='Success';   
        request.type='delete';
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
    static TestMethod void testAPIcallwithTypeBlank() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '919191919191';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.Hub_Id__c;
        request.Status='Success';   
        request.type='';
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
     static TestMethod void testAPIcallwithIncorrectMethodName() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '919191919191';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.Hub_Id__c;
        request.Status='Success';   
        request.type='update';
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStat';
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
     static TestMethod void testAPIcallwithIsPartOf() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '919191919191';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        List<string> isPartOfVal =new List<string>();
         isPartOfVal.add('aa');
         isPartOfVal.add('bb');
         
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.Hub_Id__c;
        request.Status='Success';   
        request.type='update';
         request.isPartOf = isPartOfVal;
        String myJSON = JSON.serialize(request); 
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';        
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
   
    //test for null product Id
    static TestMethod void testNullPrdId() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '818181818181';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id='';
        request.Status='Success';        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }

    //test for null status
    static TestMethod void testNullStatus() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '717171717171';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id=prd.id;
        request.Status='';        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
     //test for Invalid ProductId/HubId
    static TestMethod void testInvalidProductId() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '7171717188171';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id='yuyuyuyu';
        request.Status='Failure'; 
        request.Cause='Test Error';
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }
    
     static TestMethod void testInValidJson() {
        //create test product
        Product2 prd;
        prd = new Product2();
        prd.Name = 'TestProduct';
        prd.isActive = true;
        prd.Hub_Id__c = '818181818181';
        prd.Family = 'UNSDG';
        insert prd; 

        //Initializing rest resouce variables
        TF_ProductHubAPIService.UpdateProductRequest request = new TF_ProductHubAPIService.UpdateProductRequest();
        request.Id= prd.Hub_Id__c;
        request.Status='Successfull';        
        String myJSON = JSON.serialize(request);
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = baseUrl + '/services/apexrest/ProductHubService/updateStatus';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response = res;
        TF_ProductHubAPIService.doPost();
        Test.stopTest();
    }

     
    static void testValidEvent() {
        
        // Create a test event instance
        License_Update_Event__e UpdatelicenceEvent = new License_Update_Event__e(hubID__c='strHubId',Update_Type__c='UPDATE_DYNAMIC_LICENSE');        
        Test.startTest();        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(UpdatelicenceEvent);            
        Test.stopTest();               
       // Verify SaveResult value
        System.assertEquals(true, sr.isSuccess());
        
        
    }

}