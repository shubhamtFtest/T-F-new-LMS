/********************************************************
  This test class is used for TF_QuoteTrigger trigger.
********************************************************/
@isTest
public class zTEST_TF_QuoteTriggerHandler {
   @isTest static void testQuoteTriggerHandler() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
			insert accObject;
			
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
            insert prodObject;										   
										
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;  

            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
			insert quoteObject;
			
			SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject;
			
            Test.startTest();
			
			SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
		
	        delete quoteObj;
            
            undelete quoteObj;
            
            System.assert(quoteObj != null);
            
            Test.stopTest();
        }
    }
	
	 @isTest static void changeAccountforQuote() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
			insert accObject;
			
            Account accObject2 = new Account(Name = 'Test Account2',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
			insert accObject2;
			
			Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account1', AccountName__c = accObject.Id,Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
            insert prodObject;									
			
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
			insert quoteObject;       
			
			SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject;
            
			SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
			quoteObj.SBQQ__Account__c = accObject2.Id;
            update quoteObj;
            
            System.assertEquals(quoteObj.SBQQ__Account__c , accObject2.Id);
            
            Test.stopTest(); 
        }
    }
	
	@isTest static void testDeleteOldPrepayAccTrans() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer'); 
			insert accObject;
			
			Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account1', AccountName__c = accObject.Id,Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');	
            insert prodObject;		

			
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true);   
			insert quoteObject;       
			
			SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay', Best_Discount_Rule__c = 'Prepay');
            insert quoteLineObject;
			
			Prepay_Account_Transactions__c prepayAccTransObj = new Prepay_Account_Transactions__c(PrepayAccounts__c = prepayAccountObj.Id, Quote_ID__c = quoteObject.Id);
			insert prepayAccTransObj;
			
			Map<Id,Id> accountquoteMap = new Map<Id,Id>();
            accountquoteMap.put(quoteObject.Id, accObject.Id);
			
			TF_QuoteTriggerHandler.deleteoldAccountPrepayTransaction(accountquoteMap);
            
            List<Prepay_Account_Transactions__c> prepayAccTransList = new List<Prepay_Account_Transactions__c>();
            prepayAccTransList = [select id,Name from Prepay_Account_Transactions__c where Quote_ID__c = :quoteObject.Id];
            
            System.assertEquals(prepayAccTransList.size(), 0);
	
            Test.stopTest();
        }
    }
}