/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Tests: TF_SubjectInterestRoleInactive_Schedule.cls
*        TF_SubjectInterestRoleInactive_Batch.cls
* Modified by Hailey Niemand - 2017.01.26 - CHG0031794
*/
@isTest
public class zTEST_TF_SubjectInterestRoleInactive {
    
    static testMethod void test1() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id, contactRecordtypeId);
        
        SubjectInterest__c acr = new SubjectInterest__c();
        acr.ContactID__c = c.Id;
        acr.Active__c = true;
        acr.Last_Interaction_Date__c = system.now().addDays(-750);
        insert acr;        
        
        TF_SubjectInterestRoleInactive_Batch.SendErrorEmail('TEST.TEST@informaUSA.com','(UnitTest)Error - TF_SubjectInterestRoleInactive_Batch','test');
        
        Test.startTest();
        
        TF_SubjectInterestRoleInactive_Schedule m = new TF_SubjectInterestRoleInactive_Schedule();
        String sch = '20 30 8 10 2 ?';
        //System.schedule('TF_SubjectInterestRoleInactive_Schedule',sch, m);
        System.schedule('TF_SubjectInterestRoleInactive_ScheduleTest',sch, m); //CHG0031794
        
        TF_SubjectInterestRoleInactive_Batch tfBatch = new TF_SubjectInterestRoleInactive_Batch();
        tfBatch.isTesting = true;
        ID batchprocessid = Database.executeBatch(tfBatch); 
        
        Test.stopTest();
    }
    
}