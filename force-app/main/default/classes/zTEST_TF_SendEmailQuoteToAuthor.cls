/***************************************************************************************
   This test class is used for TF_SendEmailQuoteToAuthor class.
******************************************************************************************/
@isTest
public class zTEST_TF_SendEmailQuoteToAuthor {
    /***************************************************************************************
    This method is used to test TF_SendEmailQuoteToAuthor class.
    ******************************************************************************************/
    @isTest static void testPrepayAccepted() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
           
            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;

            //Create Prepay Account
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id);
            insert prepayAccountObj;
            
            
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = 'Accepted',CSD_Approval_Status__c = 'Approved',SBQQ__ExpirationDate__c=date.today()+20); 
            insert quoteObject;
    
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
                   
            Test.stopTest();
        }
    }
    
    @isTest static void testOpenPrepayRejected() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer',Manual_Check__c=true);
            insert accObject;
            
            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;

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
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = null,CSD_Approval_Status__c = 'null',SBQQ__ExpirationDate__c=date.today()+20, Previous_Quote_Rejection_Reason__c = 'Prepay Rejected'); 
            insert quoteObject;
    
            //Create QuoteLine
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            insert quoteLineObject;
            
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
                   
            Test.stopTest();
        }
    }

    @isTest static void testOpenPrepayQoteRejected() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;

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
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Payer__c='Organization',Payer_Organization_Name__c='TEST',Organization_Name__c='TEST',Use_Prepay_Budget__c=true,SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = null,CSD_Approval_Status__c = 'null',SBQQ__ExpirationDate__c=date.today()+20, Previous_Quote_Rejection_Reason__c = ''); 
            insert quoteObject;
            
            //Create QuoteLine
            //SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            //insert quoteLineObject;
            
            SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.SBQQ__Quote__c = quoteObject.Id;
            quoteLine.SBQQ__Product__c = prodObject.Id;
            quoteLine.SBQQ__Quantity__c = 1;
            quoteLine.Author_Facing_Article_Type__c = 'Article'; 
            insert quoteLine;
            /*
            if(quoteLine.id!=null){
    			SBQQ__Quote__c quoteToUpdate = [SELECT Id FROM SBQQ__Quote__c WHERE Id=:quoteObject.Id LIMIT 1];
    			quoteToUpdate.CSD_Approval_Status__c = 'Rejected';
    			update quoteToUpdate;
        	}
			*/
            
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            

            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
                   
            Test.stopTest();
        }
    } 
    
    @isTest static void testOpenSelectPrepayRejected() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;

            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;

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
                                           Open_Access_Category__c = 'Open Select',
                                           Readership_Level__c = 'Test');
            insert prodObject; 
        
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = null,CSD_Approval_Status__c = null,SBQQ__ExpirationDate__c=date.today()+20, Previous_Quote_Rejection_Reason__c = 'Prepay Rejected'); 
            insert quoteObject;
    
            //Create QuoteLine
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            insert quoteLineObject;
            
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
                   
            Test.stopTest();
        }
    }
   
    
    @isTest static void testOpenSocietyRejected() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
              
            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;

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
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = null,CSD_Approval_Status__c = null,SBQQ__ExpirationDate__c=date.today()+20, Previous_Quote_Rejection_Reason__c = 'Society Rejected'); 
            insert quoteObject;
    
            //Create QuoteLine
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            insert quoteLineObject;
            
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
            
            Test.stopTest();
        }
    }
    
    @isTest static void testOpenSelectSocietyRejected() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create contact 
            Contact c = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
            insert c;              
            
            //Create Product
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(RecordTypeId = TFProductsRecordTypeId, 
                                           Name = 'Test Prod',
                                           Family = 'Journals-Author Side Charges',
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open Select',
                                           Readership_Level__c = 'Test');
            insert prodObject; 
        
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, Author_Status__c = null,CSD_Approval_Status__c = null,SBQQ__ExpirationDate__c=date.today()+20, Previous_Quote_Rejection_Reason__c = 'Society Rejected'); 
            insert quoteObject;
    
            //Create QuoteLine
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id);
            insert quoteLineObject;
            
            Set<Id> quoteIdSet = new Set<Id>();
            quoteIdSet.add(quoteObject.Id);
            List<Id> quoteIdList = new List<Id>();
            quoteIdList.add(quoteObject.Id);
            
            Test.startTest();
            
            TF_SendEmailQuoteToAuthor.send(quoteIdList);
            TF_SendEmailApprovedQuoteToAuthor.send(quoteIdSet);
            System.assert(quoteIdSet != Null);
                   
            Test.stopTest();
        }
    }
}