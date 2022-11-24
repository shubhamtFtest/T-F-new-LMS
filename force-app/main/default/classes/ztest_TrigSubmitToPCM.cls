@istest
public class ztest_TrigSubmitToPCM {
    public  static testMethod void Trig_SubmitToPCMOnProductApproval () {
        String result='';  
        string testbusinessId = 'BIS-123';
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        // create the product
        Product2 p1= new Product2(
            name='TestProduct',
            Description='My Product',
            RecordTypeId=productRecordtypeId,
            businessId__c=testbusinessId,
            Product_category__c='SDGO',
            Sales_Channels__c='UBX_sales',
            hub_id__c='123456'
           
        );
        insert p1;
        p1.Approval_Status__c='Approved';
        update p1;
        
        
        //checking for cloned
        Product2 p2= new Product2(
            name='TestProduct2',
            Description='My Products',
            RecordTypeId=productRecordtypeId,
            APIStatus__c='Failure',
            originalProductId__c=p1.id,
            businessId__c=testbusinessId,
            Product_category__c='SDGO',
            Sales_Channels__c='UBX_sales',
            hub_id__c='123455'
        );
        insert p2;
        //change by chetan on 17 DEC20
        bundle_line_item__C bl1 =new bundle_line_item__C(
            Title__c ='test',
            Type__c ='book',
            uuid__c='1244',
            Product_Bundle_Parent__c =p2.id
        );
        insert bl1;
        //End Change
        p2.Approval_Status__c='Approved';
        p2.APIStatus__c='Success';    
        update p2;
        
        
        
        
        //checking for Draft
        /*     Product2 p3= new Product2(
name='TestProduct2',
Description='My Products',
RecordTypeId=productRecordtypeId,
APIStatus__c='Failure',
originalProductId__c=null
);
insert p3;
p3.Approval_Status__c='Draft';
p3.APIStatus__c='Success';    
update p3;*/
        
        
        
        //checking for Rule based
        Product2 p4= new Product2(
            name='TestProduct2',
            Description='My Products',
            RecordTypeId=productRecordtypeId,
            //APIStatus__c='Failure',
            //Product_Type_Author_Facing__c='Rule based',
            originalProductId__c=p1.id,
            businessId__c=testbusinessId,
            Product_category__c='SDGO',
            Sales_Channels__c='UBX_sales',
            hub_id__c='123454'
        );
        insert p4;
        //change by chetan on 17 DEC20
        bundle_line_item__C bl2 =new bundle_line_item__C(
            Title__c ='test',
            Type__c ='book',
            uuid__c='1234',
            Product_Bundle_Parent__c =p4.id
        );
        insert bl2;
        //End Change
        p4.Approval_Status__c='Approved';
        p4.APIStatus__c='Success';    
        update p4;
    }
    
}