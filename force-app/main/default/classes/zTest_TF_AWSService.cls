@isTest
public class zTest_TF_AWSService implements HttpCalloutMock{
    
    private integer statusCode;
    private String responseJson;
    private static TF_AWSService tF_AWSService = new TF_AWSService();
    
    public zTest_TF_AWSService(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/xml');
        resp.setBody(responseJson);      
        resp.setStatusCode(statusCode);
        return resp;
    }
    
    @testSetup
    public static void createTestData(){
        
        String strJason;
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='test';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Category__c='cat1,cat2,cat3';
        newParentProduct.keywords__c='key1,key2,key3';
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='UNSDG';
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        newParentProduct.businessId__c = 'TEST';
        newParentProduct.Sales_Channels__c = 'UBX_Sales';
        insert newParentProduct;
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.AWS_Region_Name__c = 'us-west-2';
        setting.AWS_S3_Host_Url__c = 'https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com';
        setting.AWS_Secret_Access_key__c = 'hY+Hd6mxpYsqASJDQDG2at53nyKgJZ6OBWn98gic';
        setting.AWS_Access_Key_Id__c = 'AKIAIGGCPKCJXTHQEPUQ ';
        setting.AWS_SNS_Host_Url__c = 'https://sns.eu-west-1.amazonaws.com';
        setting.AWS_SNS_TopicArn__c = 'arn:aws:sns:eu-west-1:012177264511:sns-euw1-ap-pe-df-product-store-products-d';
        setting.Name = 'sample';
        insert setting; 
        
    }
    @isTest  
    public static void test_putProductJsonToS3_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String bucketName;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.putProductJsonToS3('test',productId,bucketName);       
        Test.stopTest();
    }   
    
    
    @isTest  
    public static void test_putUUIDReqJsonToS3_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String bucketName;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.putUUIDRequestJsonToS3('test','2018-11-23-15-25-10-001.json','s3-euw1-ap-pe-df-product-store-products-d','Integrations/Identifier-Identifier-Map/Responses/2018/11/23/15/25');    
        Test.stopTest();
    }
    @isTest  
    public static void test_ggetUUIDJsonFromS3_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.getUUIDJsonFromS3(productId, '');       
        Test.stopTest();
    }
    
    
    @isTest  
    public static void test_PostProductJsonToSNS_succes(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.postNotificationToSNS('test',productId);       
        Test.stopTest();
    }
    @isTest  
    public static void test_putProductJsonToS3_failure_response(){
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String bucketName;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(400, '{}'));
        tF_AWSService.putProductJsonToS3('test',productId,bucketName);       
        Test.stopTest();
    } 
    
    @isTest  
    public static void test_putProductJsonToS3_failure(){
        String csName = 'sample';
        String SettingId = [select id  from TF_OrgSpecificProps__c where name =: csName limit 1].id;
        TF_OrgSpecificProps__c cSetting = new TF_OrgSpecificProps__c();
        cSetting.id = SettingId ;
        cSetting.AWS_S3_Host_Url__c = '';
        update cSetting;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String bucketName;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(400, '{}'));
        tF_AWSService.putProductJsonToS3('test',productId, bucketName);       
        Test.stopTest();
    }    
    
    @isTest  
    public static void test_getUUIDJsonFromS3_failure(){
        String csName = 'sample';
        String SettingId = [select id  from TF_OrgSpecificProps__c where name =: csName limit 1].id;
        TF_OrgSpecificProps__c cSetting = new TF_OrgSpecificProps__c();
        cSetting.id = SettingId ;
        cSetting.AWS_S3_Host_Url__c = '';
        update cSetting;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(400, '{}'));
        tF_AWSService.getUUIDJsonFromS3(productId, '');       
        Test.stopTest();
    }
    
    
    @isTest  
    public static void test_PostProductJsonToSNS_failure(){
        String csName = 'sample';
        String SettingId = [select id  from TF_OrgSpecificProps__c where name =: csName limit 1].id;
        TF_OrgSpecificProps__c cSetting = new TF_OrgSpecificProps__c();
        cSetting.id = SettingId ;
        cSetting.AWS_SNS_Host_Url__c = '';
        update cSetting;
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(400, '{}'));
        tF_AWSService.postNotificationToSNS('test',productId);       
        Test.stopTest();
    }
    @isTest  
    public static void test_postNotificationToSQS_succes(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.postNotificationToSQS('test message body');       
        Test.stopTest();
    }
    @isTest  
    public static void test_sendCustomerNotification_succes(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.sendCustomerNotification('test message body');       
        Test.stopTest();
    }
    @isTest 
    public static void test_postAccountSyncNotificationToSNS_succes(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.postAccountSyncNotificationToSNS('test');       
        Test.stopTest();
    }
    @isTest 
    public static void test_postAccountSyncNotificationToSNSNamedCred_succes(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        tF_AWSService.postAccountSyncNotificationToSNSNamedCred('test');       
        Test.stopTest();
    }
}