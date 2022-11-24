/***************************************************************************************
   This test class is used for TF_QuoteApprovalTrigger trigger.
******************************************************************************************/
@isTest
public class zTEST_TF_QuoteApprovalHandler {
    @isTest static void ApprovedQuoteTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60); 
            insert quoteObject;
            
            //Create Quote Approval
            Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Pending', Quote__c = quoteObject.Id, Approval_Type__c = 'Prepay');
            insert quoteAppObj; 
            
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT Approved_Rejected_Date__c,CSD_Approval_Status__c,Author_Status__c,Id,Name FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id LIMIT 1];
                
            Test.startTest();
            
            Quote_Approval__c quoteAppObj2 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj2.Quote_Approval_Status__c = 'Approved';
            update quoteAppObj2;
            
            /*Quote_Approval__c quoteAppObj3 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj3.Quote_Approval_Status__c = 'Pending';
            update quoteAppObj3;
            
            Quote_Approval__c quoteAppObj4 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj4.Quote_Approval_Status__c = 'Rejected';
            update quoteAppObj4;*/
            
            System.assertEquals(quoteAppObj2.Quote_Approval_Status__c, 'Approved');
        
            Test.stopTest();
        }
    }
	
	@isTest static void PendingQuoteTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60); 
            insert quoteObject;
            
            //Create Quote Approval
            Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Pending', Quote__c = quoteObject.Id, Approval_Type__c = 'Prepay');
            insert quoteAppObj; 
            
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT Approved_Rejected_Date__c,CSD_Approval_Status__c,Author_Status__c,Id,Name FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id LIMIT 1];
                
            Test.startTest();
            
            /*Quote_Approval__c quoteAppObj2 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj2.Quote_Approval_Status__c = 'Approved';
            update quoteAppObj2;*/
            
            Quote_Approval__c quoteAppObj3 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj3.Quote_Approval_Status__c = 'Pending';
            update quoteAppObj3;
            
            System.assertEquals(quoteAppObj3.Quote_Approval_Status__c, 'Pending');
            
            /*Quote_Approval__c quoteAppObj4 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj4.Quote_Approval_Status__c = 'Rejected';
            update quoteAppObj4;*/
        
            Test.stopTest();
        }
    }
	
	@isTest static void RejectedQuoteTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            //Create Account
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
            insert accObject;
            
            //Create Quote
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = System.today() + 60); 
            insert quoteObject;
            
            //Create Quote Approval
            Quote_Approval__c quoteAppObj = new Quote_Approval__c(Quote_Approval_Status__c = 'Pending', Quote__c = quoteObject.Id, Approval_Type__c = 'Prepay');
            insert quoteAppObj; 
            
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT Approved_Rejected_Date__c,CSD_Approval_Status__c,Author_Status__c,Id,Name FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id LIMIT 1];
                
            Test.startTest();
            
            /*Quote_Approval__c quoteAppObj2 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj2.Quote_Approval_Status__c = 'Approved';
            update quoteAppObj2;
            
            Quote_Approval__c quoteAppObj3 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj3.Quote_Approval_Status__c = 'Pending';
            update quoteAppObj3;*/
            
            Quote_Approval__c quoteAppObj4 = [SELECT Approved_Rejected_Date__c,Id,Name,Quote_Approval_Status__c,Quote__c FROM Quote_Approval__c WHERE Quote__c = :quoteObj.Id];
            quoteAppObj4.Quote_Approval_Status__c = 'Rejected';
            update quoteAppObj4;
            
            System.assertEquals(quoteAppObj4.Quote_Approval_Status__c, 'Rejected');
        
            Test.stopTest();
        }
    }
}