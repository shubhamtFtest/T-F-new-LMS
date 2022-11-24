@isTest
public class zTest_TF_Batch_DeleteInvalidContent {
    
    @testSetup
    public static void createTestData(){
        
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        
        Product2 newParentProduct = new Product2();
        newParentProduct.name='testDelBatch';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=productRecordtypeId;
        newParentProduct.Category__c='[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        newParentProduct.keywords__c='[{"name":"harish","description":"HARISH","position":1}]';
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
        newParentProduct.Sales_Channels__c='UBX_Sales';
        newParentProduct.businessId__c='sdfhkjds';
        newParentProduct.Product_Category__c='HSS';
        
        insert newParentProduct;
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Valid__c ='false';
        lineItem.uuid__c = null ;
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.uuid__c = null;
        lineItem2.Valid__c ='false';
        lineItem2.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem2;        
    }

    @isTest  
    public static void test_Batch_DeleteInvalidContent_success(){
        string prdName = 'testDelBatch';
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        product2 thisProduct = [select id  from product2 where RecordTypeId =: productRecordtypeId and name =: prdName  limit 1];
        String productId = thisProduct.id;
        Test.startTest();
        String jobId = Database.executeBatch(new TF_Batch_DeleteInvalidContent(productId), 50);
        Test.stopTest(); 
    } 
}