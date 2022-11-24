@isTest
public class Ztest_Trig_UploadCollectionImageOnS3 {
 public static testmethod void testupdate() { 
        Test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        string addError ;
        string testProduct = 'Collection_test1' ;
        string testbusinessId = 'BIS-1234' ;
        
        product2 p1  = new Product2(name=testProduct,businessid__c=testbusinessId,RecordTypeId=productRecordtypeId,version__c='1.0.0',hub_id__c='123456',Product_category__c='SDGO', Approval_Status__c ='Draft',Sales_Channels__c='UBX_sales');
        insert p1;  
        
        Product2 P2=[Select id,name from product2 where id=:p1.id];
        P2.Approval_Status__c='pending';
        update P2;
       
        Test.stopTest();
    }
}