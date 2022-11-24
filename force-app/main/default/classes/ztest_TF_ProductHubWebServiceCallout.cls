@isTest
public class ztest_TF_ProductHubWebServiceCallout implements HttpCalloutMock{
    
    private integer statusCode;
    private String responseJson;
    
    public ztest_TF_ProductHubWebServiceCallout(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().endsWith('user/auth/token')){
            String resptJson = '';
            resptJson = '{"access_token":"10edc9086eefa8e672eca3ad1b0040a2","token_type":"Bearer","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsI"}';
            
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(resptJson);      
            resp.setStatusCode(200);
            return resp;
        }else{
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(responseJson);      
            resp.setStatusCode(statusCode);
            return resp;
        }
    }
    
    public static void UpdateProductRequestsetup()
    {
        String Id;
        id='1234567';
    }
    static TestMethod void testgetHubID()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='test';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='Manual Curation';                                                                                                                                                                                                                                                                                   
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        
        insert newParentProduct;
        
        string jsonStr = '{"newId":"680c1924-f019-4415-bb62-7cffb6a520b1"}';
        
        Test.setMock(HttpCalloutMock.class, new ztest_TF_ProductHubWebServiceCallout(200, jsonStr));
        
        TF_ProductHubWebServiceCallout.getHubID(newParentProduct.id); 
        test.stopTest();
        jsonStr = '{"newId":""}';
        Test.setMock(HttpCalloutMock.class, new ztest_TF_ProductHubWebServiceCallout(200, jsonStr));
        
        TF_ProductHubWebServiceCallout.getHubID(newParentProduct.id); 
        
    }
    
    static TestMethod void testgetHubID_blank()
    {
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        system.debug(productRecordtypeId);
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='test';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='Manual Curation';                                                                                                                                                                                                                                                                                   
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        
        insert newParentProduct;
        
        string jsonStr = '{"newId":""}';
        
        Test.setMock(HttpCalloutMock.class, new ztest_TF_ProductHubWebServiceCallout(200, jsonStr));
        
        TF_ProductHubWebServiceCallout.getHubID(newParentProduct.id); 
        test.stopTest();
        
    }
}