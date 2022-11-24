@isTest(seeAllData=false)
public class AccountDetailsCmpControllerTest {
  
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
         thisAccount = AccountDetailsCmpController.getAccountDetails(testAccount.id);
         Test.stopTest();
         System.assert(thisAccount != null);
         System.assertEquals('Test Account', thisAccount.name);
     }
    @istest 
     private static void test_getAccountDetails_Null(){
         Account thisAccount = null;
         Test.startTest();
         thisAccount = AccountDetailsCmpController.getAccountDetails(null);
         Test.stopTest();
         System.assert(thisAccount == null);
     }
}