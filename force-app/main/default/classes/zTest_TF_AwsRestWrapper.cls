@isTest(seeAllData=false)

public class zTest_TF_AwsRestWrapper {
    
    //Common signed headers used in multiple tests as input.
    private static String signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
    
    //Common canonical request used in multiple tests as either input or expected result.
    
    private static String canonicalRequest = 'PUT\n' +
        '/testObjName\n\n' +
        'host:examplebucket.s3.amazonaws.com\n' +
        'x-amz-content-sha256:9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08\n' +
        'x-amz-date:20181008T000000Z\n\n' +
        'host;x-amz-content-sha256;x-amz-date\n' +
        '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08';
    
    //Common string to sign used in multiple tests as either input or expected result.
    
    private static String stringToSign = 'AWS4-HMAC-SHA256\n' + 
        '20181008T000000Z\n' +
        '20181008/eu-west-1/s3/aws4_request\n' +
        'eb45b0fa25ae8ca3e2ed383ae38c952fbe8942037a6eeb9d8b241fdb50713447'; 
    
    //Common signature used in multiple tests as either input or expected result.
    private static String signature = '285890dcb97cbfb5023b200c1ce00a8b674084cdd26660ac871cbe8596f69fd8';
    
    
    private static DateTime dateInst = DateTime.newInstanceGmt(2018, 10, 08, 00, 00, 00);
    
    
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
        newParentProduct.Hub_Id__c='1234';
        newParentProduct.Collection_Banner_Image_S3_location__c='https://s3-euw1-ap-pe-df-pch-content-public-d.s3.eu-west-1.amazonaws.com/collection/c1ede1f1-d9e6-4518-8739-7c740967cdb8/sdg-dfgtr5_bannerimage.jpg';
        newParentProduct.Collection_Banner_Image_Size__c='';
        newParentProduct.Collection_Cover_Image_S3_location__c='https://s3-euw1-ap-pe-df-pch-content-public-d.s3.eu-west-1.amazonaws.com/collection/c1ede1f1-d9e6-4518-8739-7c740967cdb8/sdg-dfgtr5_coverimage.jpg';
        newParentProduct.Collection_Cover_Image_Size__c='';
        
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
    public static void createAuthorizationHeader_awsSampleInput_Success() {   
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();        
        
        String expectedResult = 'AWS4-HMAC-SHA256 Credential=TESTAWS1234/20181008/eu-west-1/s3/aws4_request,SignedHeaders=host;x-amz-content-sha256;x-amz-date,Signature=285890dcb97cbfb5023b200c1ce00a8b674084cdd26660ac871cbe8596f69fd8';
        String result = aws.createAuthorizationHeader(dateInst,'TESTAWS1234','eu-west-1',signedHeaders,signature,'s3');
        System.assertEquals(expectedResult, result);
    }
    
    @isTest
    public static void calculateSignature_awsSampleInput_Success() {
        
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();  
        String result = aws.calculateSignature(dateInst, 'TESTAWS1234ACCESSKEY', 'eu-west-1', 's3', stringToSign);
        System.assertEquals(signature, result);
    }    
    
    @isTest
    public static void createStringToSign_awsSampleInput_Success() {
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();     
        String result = aws.createStringToSign(dateInst, 'eu-west-1', canonicalRequest,'s3');
        System.assertEquals(stringToSign, result);
    }
    
     @isTest
    public static void createCanonicalRequest_awsSampleInput_Success() {
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();     
        Map<String, String> canonicalHeaders = new Map<String, String>();
            
            canonicalHeaders.put('host', 'examplebucket.s3.amazonaws.com');
            canonicalHeaders.put('x-amz-content-sha256', aws.HexSHA256Hash('test'));
            canonicalHeaders.put('x-amz-date', aws.formatAmzLong(dateInst));
        
        String cReq = aws.createCanonicalRequest('PUT', '/testObjName', '', canonicalHeaders,signedHeaders, aws.HexSHA256Hash('test'),'s3');
        
        System.assertEquals(canonicalRequest, cReq);
    }
    
    @isTest()
    public static void createCanonicalRequest_signedHeaderCanonicalHeaderMismatch_Exception() {
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();     
        Map<String, String> canonicalHeaders = new Map<String, String>();
           
            canonicalHeaders.put('range', 'bytes=0-9');
            canonicalHeaders.put('host', 'examplebucket.s3.amazonaws.com');
            canonicalHeaders.put('x-amz-content-sha256', aws.HexSHA256Hash(''));
            canonicalHeaders.put('date', aws.formatLong(dateInst));
        
        String signedHeaders = 'range;host;x-amz-content-sha256;x-amz-date';
        boolean wasException = false;
        
        try {
            aws.createCanonicalRequest('POST', '/test.txt', '', canonicalHeaders,signedHeaders, aws.HexSHA256Hash(''),'s3');
        } 
        catch (TF_AwsRestWrapper.AwsException ex) {
            wasException = true;
        }
        System.assert(wasException);
    }
    
    @isTest
    public static void HexSHA256Hash_EmptyPayload_Success() { 
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();       
        
        String expectedResult = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
        String hashedPayload = aws.HexSHA256Hash('');
        System.assertEquals(expectedResult, hashedPayload);
    }
    
    @isTest
    public static void HexSHA256Hash_WithPayload_Success() {
        TF_AwsRestWrapper aws = new TF_AwsRestWrapper();
        
        String expectedResult = 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad';
        String hashedPayload = aws.HexSHA256Hash('abc');
        System.assertEquals(expectedResult, hashedPayload);
    }
    
    
     @isTest
    public static void testputCollectionImageonS3(){
         TF_AwsRestWrapper aws = new TF_AwsRestWrapper();
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
       // aws.putCollectionImageonS3(payload, contentType, region, folderPath, objectName, objectId, key, secret, host)
    }
    
    @isTest
    public static void testImage(){
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_PPDImageUploadToS3 PPDImg=new TF_PPDImageUploadToS3();
        PPDImg.DownloadDocuments(productId); 
        Test.stopTest();
    }
    
    @isTest
    public static void testGetImage(){
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_AwsRestWrapper PPDImg =new TF_AwsRestWrapper();
        PPDImg.getImage('eu-west-1', 'path', 'testObjName', productId, 'AKIAIGGCPKCJXTHQEPUQ', 'TESTAWS1234ACCESSKEY', 'examplebucket.s3.amazonaws.com'); 
        Test.stopTest();
    }
    
    @isTest
    public static void testGetText(){
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_AwsRestWrapper PPDImg =new TF_AwsRestWrapper();
        PPDImg.get('eu-west-1', 'path', 'testObjName', productId, 'AKIAIGGCPKCJXTHQEPUQ', 'TESTAWS1234ACCESSKEY', 'examplebucket.s3.amazonaws.com'); 
        Test.stopTest();
    }
    
    @isTest
    public static void testPostToSNS(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_AwsRestWrapper PPDImg =new TF_AwsRestWrapper();
        PPDImg.postToSNS('message','application/json' , 'eu-west-1', 'AKIAIGGCPKCJXTHQEPUQ', 'TESTAWS1234ACCESSKEY', 'examplebucket.s3.amazonaws.com', 'topic'); 
        Test.stopTest();
    }
    
    @isTest
    public static void testpostToSQS(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, '{}'));
       	TF_AwsRestWrapper PPDImg =new TF_AwsRestWrapper();
        PPDImg.postToSQS('message','application/json' , 'eu-west-1', 'AKIAIGGCPKCJXTHQEPUQ', 'TESTAWS1234ACCESSKEY', 'examplebucket.s3.amazonaws.com', ''); 
        Test.stopTest();
    }
}