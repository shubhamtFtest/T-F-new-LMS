@IsTest(SeeAllData=false)
public class zTest_Contact_DeleteRelatedPlatRole_Trig {
    @isTest
    private static void test_deleteContact(){
        User u = zTEST_Shared.insertUser();
        Id Contact_RT = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        TriggerInterfaceHelper.runTrigger('Contact_DeleteRelatedPlatformRole_Trig', 'Contact', 99, 'bd', Contact_RT, null);
        
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        testAccount.website = 'TestAccount@xyz.com';
        testAccount.BillingCity = 'Test City';
        testAccount.BillingPostalCode = '23398';
        testAccount.Mailing_State_List__c = 'XY';
        testAccount.type = 'Agent';
        testAccount.Customer_Id__c = '4887680';
        insert testAccount; 
        
    	Contact testCon = new Contact();
        testCon.FirstName = 'tstc';
        testCon.LastName = 'con001';
        testCon.Email = 'testconemail1@testing.com';
        insert testCon;
        
        Platform_Role__c testPL = new Platform_Role__c();
        testPL.Account__c = testAccount.id;
        testPL.Contact__c = testCon.id;
        insert testPL;
         
        Test.startTest();
            delete testCon;
        Test.stopTest();
        
    }
    

}