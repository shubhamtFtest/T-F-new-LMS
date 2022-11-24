/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Tests: TF_AccountContactRoleInactive_Schedule.cls
*        TF_AccountContactRoleInactive_Batch.cls
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*/
@isTest
public class zTEST_TF_AccountContactRoleInactive {
    
    static testMethod void test1() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id contactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id, contactRtId);
        
        AccountContactRole__c acr = new AccountContactRole__c();
        acr.AccountID__c = a.Id;
        acr.ContactID__c = c.Id;
        acr.Account_Contact_Role__c = 'test';
        acr.Active__c = true;
        acr.Last_Interaction_Date__c = system.now().addDays(-750);
        insert acr;        
        
        TF_AccountContactRoleInactive_Batch.SendErrorEmail('TEST.TEST@informaUSA.com','(UnitTest)Error - TF_AccountContactRoleInactive_Batch','test');
        
        Test.startTest();
        
        TF_AccountContactRoleInactive_Schedule m = new TF_AccountContactRoleInactive_Schedule();
        String sch = '20 30 8 10 2 ?';
        //System.schedule('TF_AccountContactRoleInactive_Schedule',sch, m);
        System.schedule('TF_AccountContactRoleInactive_ScheduleTest1',sch, m); //CHG0031794
        
        TF_AccountContactRoleInactive_Batch tfBatch = new TF_AccountContactRoleInactive_Batch();
        tfBatch.isTesting = true;
        ID batchprocessid = Database.executeBatch(tfBatch); 
        
        Test.stopTest();
    }
    
}