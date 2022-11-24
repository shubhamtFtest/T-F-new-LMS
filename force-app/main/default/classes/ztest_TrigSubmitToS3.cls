@istest
public class ztest_TrigSubmitToS3 {
    
    public  static testMethod void Trig_SubmitToS3AndSNSOnProductApproval () {
        String result='';  
        test.startTest();
        Id productRecordtypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Collection');
        // create the product
        Product2 p1= new Product2(
            name='TestProduct',
            Description='My Product',
            RecordTypeId=productRecordtypeId
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
            originalProductId__c=p1.id
        );
        insert p2;
        p2.Approval_Status__c='Approved';
        p2.APIStatus__c='Success';    
        update p2;
    }
}