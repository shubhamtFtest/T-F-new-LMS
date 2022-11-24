/********************************************************************
  This test class is used for TF_PreventQuoteLineDeletionTrigger trigger.
********************************************************************/
@isTest
public class zTEST_TF_PreventQuoteLineDelTrigHandler {
    /*******************************************************************
    This method is used to test TF_PreventQuoteLineDeletionTrigger trigger.
    ********************************************************************/
    @isTest static void testTF_PreventQuoteLineDeletionTrigger() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60, Payer_Account__c = accObject.Id); 
            insert quoteObject;
            
            //Create Product
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
            insert prodObject; 
            
            //Create QuoteLine
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            insert quoteLineObject;
            
            SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
            quoteLineObj = [SELECT Best_Discount_Rule__c,Id,Name FROM SBQQ__QuoteLine__c WHERE Id = :quoteLineObject.Id];
            
            Test.startTest();
            
            //try{
                quoteLineObj.Best_Discount_Rule__c = 'Society';
                update quoteLineObj;
                
                SBQQ__Quote__c quoteObj1 = new SBQQ__Quote__c();
                quoteObj1 = [SELECT id,Name,CSD_Approval_Status__c,Society_Manual_Check__c FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
                
                //System.assertEquals(quoteObj1.Society_Manual_Check__c, true);
                
                delete quoteLineObj;
                
                SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
                quoteObj2 = [SELECT id,Name,CSD_Approval_Status__c,Society_Manual_Check__c FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
                
                //System.assertEquals(quoteObj2.Society_Manual_Check__c, false);
              
                /*SBQQ__QuoteLine__c quoteLineObject2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
                insert quoteLineObject2;
                
                quoteObj2.CSD_Approval_Status__c = 'Rejected';
                update quoteObj2;
                
                delete quoteLineObject2;
            }
            catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot delete the Quote Line of a Rejected quote.') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);           
            }*/
            
            Test.stopTest();
        }
    }
}