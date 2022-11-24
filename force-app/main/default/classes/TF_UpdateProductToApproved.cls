/**
* Created by Sidhant Singh
* 
*  testClass ztest_TF_UpdateProductToApproved
*/
public class TF_UpdateProductToApproved {
    @AuraEnabled        
    public static void updateProd(String recordId){ 
        List<Product2> productList=new List<Product2>();
        productList=[select id,Hub_Id__c,Family from product2 where id=:recordId];
        TF_FSDSyncCallout.doAction(productList);
    }
}