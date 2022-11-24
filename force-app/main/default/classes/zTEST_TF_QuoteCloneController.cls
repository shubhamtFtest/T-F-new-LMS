/***************************************************************************************
   This test class is used for TF_QuoteCloneController class.
******************************************************************************************/
/*
* CAB Ticket #: CHG0037688
* Changes: lines 58, related to CHG0037688
* Changes: lines 112, related to CHG0037688
* Changes: lines 149, related to CHG0037688
* */
@isTest
public class zTEST_TF_QuoteCloneController {
    /***************************************************************************************
    This method is used to test TF_QuoteCloneController class.
    ******************************************************************************************/
    @isTest static void testQuoteCloneWithSocietyRejection() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
      //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            List<Account> accList = new List<Account>();
      Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            accList.add(accObject);
      //Create Society Account
            Account socAccObject = new Account(Name = 'Test Soc Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Society');
            accList.add(socAccObject);
            insert accList;
      
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
            
      //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60); 
            insert quoteObject;
      
      //Create QuoteLine
      SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id,
                                                             SBQQ__ListPrice__c = 1000, Discount_Rules_Applied__c = 'Society', Best_Discount_Rule__c = 'Society');
            insert quoteLineObject;
      
      //Create Society Quote
      Society_Quote__c socQuoteObj = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = socAccObject.Id);
      insert socQuoteObj;
            
            Test.startTest();
      
      //Create Quote Approval
      Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Rejected', Quote__c = quoteObject.Id, Approval_Type__c = 'Society');
            insert quoteAppObj; 
      
      List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            TF_QuoteCloneController.clone(quoteIdList, false);
      
      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
      quoteObj = [SELECT Id,Name,RecordTypeId FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
      RecordType recordTypeObj1 = new  RecordType();
      recordTypeObj1 = [SELECT Id,IsActive,Name FROM RecordType WHERE Id = :quoteObj.RecordTypeId];
            System.assertEquals(recordTypeObj1.Name, 'T&F - Read Only Quote');
      
            Test.stopTest();
        }
    }
  
  @isTest static void testQuoteCloneWithPrepayRejection() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
      //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
      //Create Prepay Account
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
            insert prepayAccountObj;
            
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
            
      //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60, Use_Prepay_Budget__c = true); 
            insert quoteObject;
      
      //Create QuoteLine
      SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id,
                                                             SBQQ__ListPrice__c = 1000, Discount_Rules_Applied__c = 'Prepay', Best_Discount_Rule__c = 'Prepay');
            insert quoteLineObject;
      
      Test.startTest();
      
      //Create Quote Approval
      Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Rejected', Quote__c = quoteObject.Id, Approval_Type__c = 'Prepay');
            insert quoteAppObj; 
      
      List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            TF_QuoteCloneController.clone(quoteIdList, false);
      
      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
      quoteObj = [SELECT Id,Name,RecordTypeId FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
      RecordType recordTypeObj1 = new  RecordType();
      recordTypeObj1 = [SELECT Id,IsActive,Name FROM RecordType WHERE Id = :quoteObj.RecordTypeId];
            System.assertEquals(recordTypeObj1.Name, 'T&F - Read Only Quote');
      
            Test.stopTest();
        }
    }
  
  @isTest static void testQuoteWithoutQuoteLine() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
      //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
      //Create Prepay Account
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
            insert prepayAccountObj;
            
      //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60, Use_Prepay_Budget__c = true); 
            insert quoteObject;
    
      Test.startTest();
      
      //Create Quote Approval
      Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Rejected', Quote__c = quoteObject.Id, Approval_Type__c = 'Prepay');
            insert quoteAppObj; 
      
      List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            TF_QuoteCloneController.clone(quoteIdList, false);
      
      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
      quoteObj = [SELECT Id,Name,RecordTypeId FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
      RecordType recordTypeObj1 = new  RecordType();
      recordTypeObj1 = [SELECT Id,IsActive,Name FROM RecordType WHERE Id = :quoteObj.RecordTypeId];
            System.assertEquals(recordTypeObj1.Name, 'T&F - Read Only Quote');
      
            Test.stopTest();
        }
    }
}