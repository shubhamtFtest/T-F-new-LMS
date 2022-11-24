@isTest
public class ztest_TF_UpdateProductHubIdForFSDProduct {
    @testSetup 
    private static  void createdata()
    {
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F-Journal Master').getRecordTypeId();
        
        Product2 prodObjectSec = new Product2(Name = 'Test Product Sec', 
                                              RecordTypeId = TFProductsRecordTypeId,
                                              CPQ_Category__c = 'Technology',
                                              Article_Type__c = 'Letter',
                                              Sales_Organization__c = 'NA',
                                              Open_Access_Category__c = 'Open',
                                              ProductCode = 'XYZ',
                                              Readership_Level__c = 'Test',
                                              IsActive = true,
                                              Hub_Id__c='143f5db0-b038-48f5-a0da-50bb4f3485fa',
                                              Family = 'Journal Service Product');  
        insert prodObjectSec;
        
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'XYZ',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Hub_Id__c='',
                                           Family = 'Journal Master Product',
                                           Commissioning_Editor_Email__c = 'xyz@gmail.com');  
        insert prodObject;
        
        
        
        List<Article_Type__c> articleList=new List<Article_Type__c>();
        Article_Type__c objarticle=new Article_Type__c();
        objarticle.Article_Name__c='test';
        objarticle.cat_Article_Type__c='Article';
        objarticle.Product__c=prodObject.id; 
        objarticle.Price_Point__c=prodObjectSec.id;
        articleList.add(objarticle);  
        insert articleList;
        
        
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = prodObject.id,unitprice=1.0, isActive=true);
        
        Pricebook2 pb = new pricebook2(name='OA APC PriceBook');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=prodObject.id,unitprice=1.0, isActive=true);
        insert pbe;
        
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = prodObjectSec.id,unitprice=1.0, isActive=true);
        
        PricebookEntry pbeSec = new PricebookEntry(pricebook2id=pb.id, product2id=prodObjectSec.id,unitprice=1.0, isActive=true);
        insert pbeSec;
    }
    private static  testMethod void testthirdmeth()
    {
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObjectSec = new Product2(Name = 'Test Product Second', 
                                              RecordTypeId = TFProductsRecordTypeId,
                                              CPQ_Category__c = 'Technology',
                                              Article_Type__c = 'Letter',
                                              Sales_Organization__c = 'NA',
                                              Open_Access_Category__c = 'Open',
                                              ProductCode = 'XYZ',
                                              Readership_Level__c = 'Test',
                                              IsActive = true,
                                              Hub_Id__c='143f5db0-b038-48f5-a0da-50bb4f3485fa',
                                              Family = 'Journal Service Product');  
        insert prodObjectSec;
        product2 prodObj=[select id,Product2.Hub_Id__c,Family from product2 where name='Test Product' limit 1];

        Test.startTest();
        TF_FSDSyncCallout.updateProductHubId('143f5db0-b038-48f5-a0da-50bb4f3485fa',prodObjectSec.id);
        TF_FSDSyncCallout.getHubID(prodObjectSec.id);
        TF_FSDSyncCallout.getHubIDSync(prodObjectSec.id);
        TF_FSDSyncCallout.syncServiceProductAssociteMappingCallout(prodObj.id,new map<String,String>{'' => ''});
        TF_FSDSyncCallout.updateCall(prodObjectSec.id,'143f5db0-b038-48f5-a0da-50bb4f3485fa','PUT');
        TF_FSDSyncCallout.updateCall(prodObjectSec.id,'143f5db0-b038-48f5-a0da-50bb4f3485fa','POST');
        TF_FSDSyncCallout.updateCall(prodObj.id,'143f5db0-b038-48f5-a0da-50bb4f3485fa','PUT');
        TF_FSDSyncCallout.updateCall(prodObj.id,'143f5db0-b038-48f5-a0da-50bb4f3485fa','POST');
        TF_FSDSyncCallout.updateCall(prodObj.id,null,'PUT');
        TF_FSDSyncCallout.doAction(new list<product2> {prodObj});
        Test.stopTest();
        
    }
    
    private static testMethod void testMeth()
    {
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F-Services').getRecordTypeId();
        Product2 prodObjectSec = new Product2(Name = 'Test Product Second', 
                                              RecordTypeId = TFProductsRecordTypeId,
                                              CPQ_Category__c = 'Technology',
                                              Article_Type__c = 'Letter',
                                              Sales_Organization__c = 'NA',
                                              Open_Access_Category__c = 'Open',
                                              ProductCode = 'XYZ',
                                              Readership_Level__c = 'Test',
                                              IsActive = true,
                                              Family = 'Journal Service Product');  
        insert prodObjectSec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new generatorSuccess());
        TF_FSDSyncCallout.getHubID(prodObjectSec.id);
        product2 prodObj=[select id,Product2.Hub_Id__c,Family from product2 where id=:prodObjectSec.Id limit 1];
        Test.stopTest();
        
    }
    
    public class generatorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{ "metadata": { "_id":"89798", "code": 200, "timestamp": "2019.12.11.11.21.32.011", "details": "New Customer" } }');
            return res;
        }
    }
}