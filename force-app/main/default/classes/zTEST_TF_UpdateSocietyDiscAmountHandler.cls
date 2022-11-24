/**************************************************************************
  This test class is for TF_UpdateSocietyDiscountAmountFieldTrigger trigger.
***************************************************************************/
@isTest
public class zTEST_TF_UpdateSocietyDiscAmountHandler {
    /********************************************************************************************************
      This method is used to test TF_UpdateSocietyDiscountAmountFieldTrigger trigger.
      Create QuoteLine record and add Society Quote records to QuoteLine.
      Update Society Discount Amount field on QuoteLine based on Society Quote records added to the QuoteLine.
    *********************************************************************************************************/
    @isTest static void UpdateSocietyDisAmountFieldTriggerTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
			List<Account> accList = new List<Account>();
            Account accountObj1 = new Account(Name = 'Test Account1',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
			accList.add(accountObj1);
            Account accountObj2 = new Account(Name = 'Test Account2',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
		    accList.add(accountObj2);
            Account accountObj3 = new Account(Name = 'Test Account3',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
			accList.add(accountObj3);
            Account accountObj4 = new Account(Name = 'Test Account4',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
			accList.add(accountObj4);
            insert accList;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 productObj = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
            insert productObj;
            
			List<CPQ_Discount_Configuration__c> discConfList = new List<CPQ_Discount_Configuration__c>();
            Id SocietyDiscountRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - Society Discount').getRecordTypeId();
            CPQ_Discount_Configuration__c discConfigObject1 = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj1.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = '% Discount', 
                                                                                               Discount_Value_Percentage__c = 10,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);
            discConfList.add(discConfigObject1);
			CPQ_Discount_Configuration__c discConfigObject2 = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj2.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = '% Discount', 
                                                                                               Discount_Value_Percentage__c = 20,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);
            discConfList.add(discConfigObject2);
            CPQ_Discount_Configuration__c discConfigObject3 = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj3.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = 'Amount Discount', 
                                                                                               Discount_Value_Amount__c = 300,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);
            discConfList.add(discConfigObject3);
            CPQ_Discount_Configuration__c discConfigObject4 = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj4.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = 'Fixed Amount Discount', 
                                                                                               Discount_Value_Amount__c = 100,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);
            discConfList.add(discConfigObject4);																	   
            insert discConfList;
			
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id, SBQQ__ExpirationDate__c = System.today()+10, Payer_Account__c = accountObj1.Id);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = productObj.Id, SBQQ__ListPrice__c = 1000);
            insert quoteLineObject;
            
			List<Society_Quote__c> socQuoteList = new List<Society_Quote__c>();
            Society_Quote__c societyQuoteObject1 = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj1.Id);
			socQuoteList.add(societyQuoteObject1);
            Society_Quote__c societyQuoteObject2 = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj2.Id);
			socQuoteList.add(societyQuoteObject2);
            Society_Quote__c societyQuoteObject3 = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj3.Id);
			socQuoteList.add(societyQuoteObject3);
            Society_Quote__c societyQuoteObject4 = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj4.Id);
			socQuoteList.add(societyQuoteObject4);
            insert socQuoteList;
			
            Test.startTest();
            
            delete socQuoteList;
            SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
            quoteLineObj = [SELECT Id, Society_Discount_Amount__c FROM SBQQ__QuoteLine__c WHERE Id = :quoteLineObject.Id];
            //System.assertEquals(quoteLineObj.Society_Discount_Amount__c, null);
            
            Test.stopTest();
        }  
    }
	
	@isTest static void AmountDiscountTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accountObj = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
			insert accountObj;
           
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 productObj = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
            insert productObj;
            
            Id SocietyDiscountRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - Society Discount').getRecordTypeId();
            CPQ_Discount_Configuration__c discConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = 'Amount Discount', 
                                                                                               Discount_Value_Amount__c = 300,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);																   
            insert discConfigObject;
			
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accountObj.Id, SBQQ__ExpirationDate__c = System.today()+10, Payer_Account__c = accountObj.Id);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = productObj.Id, SBQQ__ListPrice__c = 1000);
            insert quoteLineObject;
            
            Society_Quote__c societyQuoteObject = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj.Id);
			
            Test.startTest();
            
            insert societyQuoteObject;
            SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
            quoteLineObj = [SELECT Id, Society_Discount_Amount__c FROM SBQQ__QuoteLine__c WHERE Id = :quoteLineObject.Id];
            //System.assertEquals(quoteLineObj.Society_Discount_Amount__c, 300);
			
            Test.stopTest();
        }  
    }
	
    @isTest static void FixedAmountDiscountTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accountObj = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Society');
			insert accountObj;
           
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 productObj = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
            insert productObj;
            
            Id SocietyDiscountRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - Society Discount').getRecordTypeId();
            CPQ_Discount_Configuration__c discConfigObject = new CPQ_Discount_Configuration__c(RecordTypeId = SocietyDiscountRecordTypeId,
                                                                                               Active__c = True,
                                                                                               Society__c = accountObj.Id, 
                                                                                               Product__c = productObj.Id, 
                                                                                               Discount_Type__c = 'Fixed Amount Discount', 
                                                                                               Discount_Value_Amount__c = 100,
                                                                                               Start_Date__c = System.today()-10,
                                                                                               End_Date__c = System.today()+20);																   
            insert discConfigObject;
			
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accountObj.Id, SBQQ__ExpirationDate__c = System.today()+10, Payer_Account__c = accountObj.Id);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = productObj.Id, SBQQ__ListPrice__c = 1000);
            insert quoteLineObject;
            
            Society_Quote__c societyQuoteObject = new Society_Quote__c(Quote_Line__c = quoteLineObject.Id, Society__c = accountObj.Id);
			
            Test.startTest();
            
            insert societyQuoteObject;
            
            SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
            quoteLineObj = [SELECT Id, Society_Discount_Amount__c FROM SBQQ__QuoteLine__c WHERE Id = :quoteLineObject.Id];
            //System.assertEquals(quoteLineObj.Society_Discount_Amount__c, 900);
			
            Test.stopTest();
        }  
    } 
}