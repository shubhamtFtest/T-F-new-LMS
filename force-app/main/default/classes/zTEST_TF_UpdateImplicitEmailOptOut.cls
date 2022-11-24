/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Tests: TF_UpdateImplicitEmailOptOut_Schedule.cls
*        TF_UpdateImplicitEmailOptOut_Batch.cls
*/
@isTest
public class zTEST_TF_UpdateImplicitEmailOptOut {
    
    static testMethod void test1() {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id, contactRecordtypeId);
        c.Implied_Consent_Expiry_Date__c = system.today().addDays(-1);
        c.Implicit_Email_Opt_Out__c = false;
        update c;
        
        TF_UpdateImplicitEmailOptOut_Batch.SendErrorEmail('TEST.TEST@informaUSA.com','(UnitTest)Error - TF_UpdateImplicitEmailOptOut_Batch','test');
        
        Test.startTest();
        
        TF_UpdateImplicitEmailOptOut_Schedule m = new TF_UpdateImplicitEmailOptOut_Schedule();
        String sch = '20 30 8 10 2 ?';
        System.schedule('TF_UpdateImplicitEmailOptOut_Schedule',sch, m);
        
        TF_UpdateImplicitEmailOptOut_Batch tfBatch = new TF_UpdateImplicitEmailOptOut_Batch();
        tfBatch.isTesting = true;
        ID batchprocessid = Database.executeBatch(tfBatch); 
        
        Test.stopTest();
    }
    
}