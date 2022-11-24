@isTest
public class ztest_TF_UpdateProductToApproved{
      static testmethod void test(){
           test.startTest();
          Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F-Journal Master').getRecordTypeId();
          
          Product2 prodObject = new Product2(Name = 'Test Product Sec', 
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
          insert prodObject;

           TF_UpdateProductToApproved.updateProd(prodObject.id);

           test.stopTest();
      }
}