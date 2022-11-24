@isTest(seeAllData=false)
public class TF_CustomerOnboardingApexContTest {
    @istest 
     private static void test_getAccountDetails(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
         Account thisAccount = null;
         Test.startTest();
         thisAccount = TF_CustomerOnboardingApexController.getAccountDetails(testAccount.id);
         Test.stopTest();
         System.assert(thisAccount != null);
         System.assertEquals('Test Account', thisAccount.name);
     }
    @istest 
     private static void test_getAccountDetails_Null(){
         Account thisAccount = null;
         Test.startTest();
         thisAccount = TF_CustomerOnboardingApexController.getAccountDetails(null);
         Test.stopTest();
         System.assert(thisAccount == null);
     }
    @istest 
     private static void test_updateAccStatusPostEnrichment(){
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '123';
        testAccount.Ringgold_Account_ID__c = '5629';
        insert testAccount;
        
        Test.startTest();
        TF_CustomerOnboardingApexController.updateAccStatusPostEnrichment(testAccount.id);
        Test.stopTest();
        Account thisAccount = [Select Id, name, Onboarding_Status__c from Account where id =: testAccount.id];
        System.assert(thisAccount != null);
        System.assertEquals('RingGold Enrichment Done', thisAccount.Onboarding_Status__c);
     }

}