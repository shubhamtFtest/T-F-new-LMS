@isTest
public class ztest_TF_QuoteLineUpdate {
    private static testMethod void testUpdate()
    {
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer',Manual_Check__c = True); 
        insert accObject;
        
        Prepay_Accounts__c pp = new Prepay_Accounts__c (name='Test PP',AccountName__c=accObject.id);
        insert pp;
        
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'XYZ',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journal Service Product');  
        insert prodObject;   
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
            Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true,
            Article_Acceptance_Status__c = 'Accepted',Primary_Contact_s_email_id__c='test@test.com',
            Order_Hub_Number__c='ODR881153');       
        insert quoteObject;
        TriggerInterface_SBQQ_QuoteLine.trig  triggerObj = new TriggerInterface_SBQQ_QuoteLine.trig();
        
        SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id,SBQQ__Discount__c=10, Discount_Rules_Applied__c = 'Prepay');
        insert quoteLineObject; 
        triggerObj.oldMap=new Map<Id, SBQQ__QuoteLine__c>{quoteLineObject.Id => quoteLineObject};
           
        SBQQ__QuoteLine__c quoteLineObjectSecond  =new SBQQ__QuoteLine__c();  
        quoteLineObjectSecond.Id=quoteLineObject.Id;
        quoteLineObjectSecond.SBQQ__Discount__c=0.00;
        update quoteLineObjectSecond;

        triggerObj.isAfter = true;
        triggerObj.isUpdate = true;
        triggerObj.newMap=new Map<Id, SBQQ__QuoteLine__c>{quoteLineObjectSecond.Id => quoteLineObjectSecond};
        triggerObj.newList = new List<SBQQ__QuoteLine__c>{quoteLineObject};
        
        TF_QuoteLineUpdate  controller = new TF_QuoteLineUpdate ();
        controller.run(triggerObj);
        system.assertEquals(false, quoteObject.isFutureHandler__c);
    }
}