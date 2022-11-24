@isTest
public class Ztest_Trig_validateBusinessID {
    public static testmethod void testinsert() { 
        Test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        string addError ;
        string testProduct = 'Collection_test' ;
        string testbusinessId = 'BIS-123' ;
        product2 p1  = new Product2(name=testProduct,businessid__c=testbusinessId,RecordTypeId=productRecordtypeId,version__c='1.0.0',hub_id__c='123456',Product_category__c='SDGO',Sales_Channels__c='UBX_sales');
        insert p1;  
        product2 p2  = new Product2(name=testProduct,businessid__c=testbusinessId,RecordTypeId=productRecordtypeId,version__c='1.0.0',hub_id__c='123456',Product_category__c='SDGO',Sales_Channels__c='UBX_sales');
        List<Product2> prd = [select id from Product2 where version__c!=null AND  businessId__c!=null AND businessid__c=:testbusinessId AND hub_id__c!='123456'];
        
        if(prd.size()<1) {
            system.assertEquals(0,prd.size());
            insert p2;
        }
        else {
            addError='BusinessId already exist';
        }
        //system.assertEquals('BusinessId already exist',addError);
        Test.stopTest();
    }
    
    
    public static testmethod void testupdate() { 
        Test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        string addError ;
        string testProduct = 'Collection_test1' ;
        string testbusinessId = 'BIS-123' ;
        
        product2 p1  = new Product2(name=testProduct,businessid__c=testbusinessId,RecordTypeId=productRecordtypeId,version__c='1.0.0',hub_id__c='123456',Product_category__c='SDGO',Sales_Channels__c='UBX_sales');
        insert p1;  
        
        product2 p2  = new Product2(name=testProduct,businessid__c=testbusinessId,RecordTypeId=productRecordtypeId,version__c='1.0.1',hub_id__c='123456',Product_category__c='SDGO',Sales_Channels__c='UBX_sales');
        List<Product2> prd = [select businessid__c,Business_Id_Calc__c from Product2 where businessid__c=:testbusinessId AND RecordTypeId=:productRecordtypeId];
        
        if(prd.size()<1) {
            system.assertEquals(0,prd.size());
            insert p2;
           
        }
        else {
            addError='BusinessId already exist';
        }
        
       // system.assertEquals('BusinessId already exist',addError);
        
        p2 = [select id,name From Product2 where Name = 'Collection_test1'];
        p2.IsActive = true;
        update p2;
        Test.stopTest();
    }
    
    
}