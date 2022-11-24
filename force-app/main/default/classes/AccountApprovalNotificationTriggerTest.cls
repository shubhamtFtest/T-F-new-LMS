@IsTest(SeeAllData=false)
public class AccountApprovalNotificationTriggerTest {
	@isTest
    private static void test_trigger_positive(){
    	Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Source_of_Account__c = 'OA';
        testAccount.BillingCity = 'Bangalore';
        testAccount.BillingState = 'Karnataka';
        testAccount.BillingPostalCode = '560100';
        testAccount.BillingCountry = 'India';
        testAccount.Website = 'www.testAcc.com';
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
		testAccount.Ringgold_Account_ID__c = '546670';
        insert testAccount;

        Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'NEW';
        log.Source__c = 'OA';
        insert log;
        
        Test.startTest();
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        update testAccount;
        Test.stopTest();
        
        Account_Request_Log__c accountReqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :testAccount.Id limit 1];
        System.assert(accountReqLog != null);
        System.assertEquals(accountReqLog.Status__c, 'APPROVED');
        
    }
    
    @isTest
    private static void test_trigger_negative(){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Source_of_Account__c = 'GOBI';
        testAccount.BillingCity = 'Bangalore';
        testAccount.BillingState = 'Karnataka';
        testAccount.BillingPostalCode = '560100';
        testAccount.BillingCountry = 'India';
        testAccount.Website = 'www.testAcc.com';
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Third Party Account Request').getRecordTypeId();
		testAccount.Ringgold_Account_ID__c = '546670';
        insert testAccount;

        Account_Request_Log__c log = new Account_Request_Log__c();
        log.Party_ID__c = testAccount.Customer_Id__c;
        log.Request_ID__c = testAccount.id;
        log.BP_Numbers__c = '';
        log.Account_ID__c = testAccount.id;
        log.Status__c = 'NEW';
        log.Source__c = 'OA';
        insert log;
        
        Test.startTest();
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        update testAccount;
        Test.stopTest();
        
        Account_Request_Log__c accountReqLog = [SELECT id, Status__c from Account_Request_Log__c WHERE Request_ID__c = :testAccount.Id limit 1];
        System.assert(accountReqLog != null);
        System.assertEquals(accountReqLog.Status__c, 'NEW');
    }
}