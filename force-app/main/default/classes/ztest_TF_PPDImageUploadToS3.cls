@isTest
public class ztest_TF_PPDImageUploadToS3 {
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
        newParentProduct.BusinessId__c='Pub12';
        newParentProduct.Sales_Channels__c='UBX_sales';
        newParentProduct.hub_Id__c='ad823191-fb07-4de0-88cc-929e439636ee';
        
        insert newParentProduct;
        
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode('ghty67fhhkkjhh6');
        cv.Title = 'TestImage_bannerimage.jpg';
        cv.PathOnClient = 'TestImage_bannerimage.jpg';
        insert cv;
       
         ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [
              SELECT ContentDocumentId 
              FROM ContentVersion 
              WHERE Id =: cv.id
            ].ContentDocumentId;
    
            cdl.LinkedEntityId = newParentProduct.id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'InternalUsers';
            insert cdl;
        
        
        
        //inserting cover image
        ContentVersion cv1 = new ContentVersion();
        cv1.VersionData = EncodingUtil.base64Decode('ghty67fhhgftthkkjhh6');
        cv1.Title = 'TestImage_coverimage.jpg';
        cv1.PathOnClient = 'TestImage_coverimage.jpg';
        insert cv1;
       
         ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.ContentDocumentId = [
              SELECT ContentDocumentId 
              FROM ContentVersion 
              WHERE Id =: cv1.id
            ].ContentDocumentId;
    
            cdl1.LinkedEntityId = newParentProduct.id;
            cdl1.ShareType = 'V';
            cdl1.Visibility = 'InternalUsers';
            insert cdl1;
        
        
        
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.AWS_Region_Name__c = 'us-west-2';
        setting.AWS_S3_Host_Url__c = 'https://s3-euw1-ap-pe-df-pch-content-public-d.s3.eu-west-1.amazonaws.com';
        setting.AWS_Secret_Access_key__c = 'hY+Hd6mxpYsqASJDQDG2at53nyKgJZ6OBWn98gic';
        setting.AWS_Access_Key_Id__c = 'AKIAIGGCPKCJXTHQEPUQ ';
        setting.AWS_SNS_Host_Url__c = 'https://sns.eu-west-1.amazonaws.com';
        setting.AWS_SNS_TopicArn__c = 'arn:aws:sns:eu-west-1:012177264511:sns-euw1-ap-pe-df-product-store-products-d';
        setting.Name = 'sample';
        insert setting; 
        
    }
    
     @isTest  
    public static void test_UploadDocuments_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String bucketName;
        
         List<string> ids=new List<string>();
            List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =: productId];
            if(cdlList!=null){
                for (ContentDocumentLink cdl : cdlList) {
                    ids.add(cdl.ContentDocumentId);
                }
            }
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
        TF_PPDImageUploadToS3 PPDImg=new TF_PPDImageUploadToS3();
        PPDImg.UploadDocuments(ids,productId);       
        Test.stopTest();
    }  
    
 	@isTest  
    public static void test_DownloadDocuments(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_PPDImageUploadToS3 PPDImg=new TF_PPDImageUploadToS3();
        PPDImg.DownloadDocuments(productId); 
        Test.stopTest();
    }
    
    
    
    
}