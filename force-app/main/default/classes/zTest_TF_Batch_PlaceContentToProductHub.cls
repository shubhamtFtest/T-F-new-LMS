@isTest
public class zTest_TF_Batch_PlaceContentToProductHub {
    
    @testSetup
    public static void createTestData(){
        
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Unsilo_Host_Url__c = 'https://services.unsilo.com/api/classify/tandf/classes/';
        setting.Unsilo_UserName__c = 'testuser';
        setting.Unsilo_Password__c = 'testpass';
        setting.AWS_Region_Name__c = 'us-west-2';
        setting.AWS_S3_Host_Url__c = 'https://s3-euw1-ap-pe-df-product-store-products-d.s3.eu-west-1.amazonaws.com';
        setting.AWS_Secret_Access_key__c = 'hY+Hd6mxpYsqASJDQDG2at53nyKgJZ6OBWn98gic';
        setting.AWS_Access_Key_Id__c = 'AKIAIGGCPKCJXTHQEPUQ ';
        setting.AWS_SNS_Host_Url__c = 'https://sns.eu-west-1.amazonaws.com';
        setting.AWS_SNS_TopicArn__c = 'arn:aws:sns:eu-west-1:012177264511:sns-euw1-ap-pe-df-product-store-products-d';
        setting.Name = 'sample1';
        insert setting; 
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='testAwsService';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Category__c='[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        newParentProduct.keywords__c='[{"name":"harish","description":"HARISH","position":1}]';
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
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem2;        
    }
    
    @isTest  
    public static void test_BatchPutProductJsonToS3_success(){
        
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        String strJason='{  "@id" : "b7d9c0ca-8337-4afc-80e5-d36f7f9881e5",  "@type" : "Collections",  "@additionalType" : "UNSDG",  "name" : "test hub id",  "alternateName" : "",  "inLanguage" : "en",  "version" : "1.0.0",  "doi" : "",  "ean" : "",  "issn" : "",  "sku" : "01t1l000000pJ4qAAE",  "productID" : "01t1l000000pJ4qAAE",  "description" : "sadf",  "publisher" : "sdfsadf",  "dateCreated" : "2018-11-20T14:00:48.000Z",  "dateModified" : "2018-12-14T11:50:22.000Z",  "copyrightYear" : "2018",  "copyrightHolder" : {    "name" : ""  },  "identifier" : [ {    "code" : ""  } ],  "category" : [ ],  "keywords" : [ ],  "contributor" : [ ],  "offers" : [ ],  "hasPart" : [ {    "@id" : "10.4324/9781315619189-11961",    "@type" : "chapter",    "position" : 1  }]  }';
         //String strJason='{  "@id" : "b7d9c0ca-8337-4afc-80e5-d36f7f9881e5",  "@type" : "Collections",  "@additionalType" : "UNSDG",  "name" : "test hub id",  "alternateName" : "",  "version" : "1.0.0",  "doi" : "",  "ean" : "",  "issn" : "",  "sku" : "01t1l000000pJ4qAAE",  "productID" : "01t1l000000pJ4qAAE",  "description" : "sadf",  "publisher" : "sdfsadf",  "dateCreated" : "2018-11-20T14:00:48.000Z",  "dateModified" : "2018-12-14T11:50:22.000Z",  "copyrightYear" : "2018",  "copyrightHolder" : {    "name" : ""  },  "identifier" : [ {    "code" : ""  } ],  "category" : [ ],  "keywords" : [ ],  "contributor" : [ ],  "offers" : [ ],  "hasPart" : [ {    "@id" : "10.4324/9781315619189-11961",    "@type" : "chapter",    "position" : 1  }]  }';

        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId limit 1];
        String productId = thisProduct.id;
        String resBody = '<PublishResponse xmlns="http://sns.amazonaws.com/doc/2010-03-31/">\n'+
            '<PublishResult>\n'+
            '<MessageId>960cd44f-e44d-5271-b195-807944061fd2</MessageId>\n'+
            '</PublishResult>\n'+
            '<ResponseMetadata>\n'+
            '<RequestId>ccb9190b-dc72-5316-ace9-4d3d7c39beb5</RequestId>\n'+
            '</ResponseMetadata>\n'+
            '</PublishResponse>'; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zTest_TF_AWSService(200, resBody));
        TF_ProductApprovalS3Submit.putCollectionJsonToS3(productId);
        //String jobId = Database.executeBatch(new TF_Batch_PlaceContentToProductHub(productId), 5000);
        Test.stopTest();
    } 
    
}