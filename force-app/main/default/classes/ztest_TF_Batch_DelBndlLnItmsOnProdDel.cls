@isTest
public class ztest_TF_Batch_DelBndlLnItmsOnProdDel {
  @isTest  
    public static void test_TF_Batch_DelBndlLnItmsOnProdDel_success(){
        String productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        Product2 newParentProduct=zTEST_Shared.insertProduct2(productRecordtypeId);
        Product2 newChildProduct1=zTEST_Shared.insertProduct2(productRecordtypeId); 
        Bundle_Line_Item__c lineItems = new Bundle_Line_Item__c();
        lineItems.Product_Bundle_Parent__c = NULL;
        lineItems.Product__c = newChildProduct1.id;
        insert lineItems; 
        
         Bundle_Line_Item__c lineItem1 = new Bundle_Line_Item__c();
        lineItem1.Product_Bundle_Parent__c = NULL;
        lineItem1.Product__c = newChildProduct1.id;
        insert lineItem1; 
        
         Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Product_Bundle_Parent__c = NULL;
        lineItem2.Product__c = newChildProduct1.id;
        insert lineItem2; 
        Test.startTest();
      
        String jobId = Database.executeBatch(new TF_Batch_DelBndlLineItmsOnProdDelete(newParentProduct.id), 500);
       //delete newParentProduct;
        Test.stopTest();
    }
}