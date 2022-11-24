/************************************************************************** 
** Last Modified by Jeff Lup on 2017.02.09
** Tests: TF_MigrateNotes_Batch at 100%
* Commented out, but saved for future use
***************************************************************************/
@isTest
private class zTEST_TF_MigrateNotes_Batch {

	static testMethod void testTF_MigrateNotes_Batch() {
    	TF_MigrateNotes_Batch tfBatch = new TF_MigrateNotes_Batch();
    }
    
/*
    static testMethod void testTF_MigrateNotes_Batch() {
        User u = zTEST_Shared.insertUser();

        Account a1 = zTEST_Shared.insertAccount(u.Id, '01260000000DXrfAAG'); //OLD - CAS - Campus Accounts
        Account a2 = zTEST_Shared.insertAccount(u.Id, '01260000000DXrfAAG'); //OLD - CAS - Campus Accounts

        Campus__c camp = new Campus__c();
        camp.Account__c = a1.Id;
        camp.Name = 'test';
        insert camp;

        a1.Admin_Field_1__c = camp.Id;
        update a1;

        a2.Admin_Field_1__c = camp.Id;
        update a2;
        
        ContentNote cn = new ContentNote();
        cn.Title = 'test';
        String body = 'test';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert(cn);
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = a1.Id;
        cdl.ContentDocumentId = cn.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        Test.startTest();
        TF_MigrateNotes_Batch tfBatch = new TF_MigrateNotes_Batch();
        ID batchprocessid = Database.executeBatch(tfBatch); 
        Test.stopTest();
    }
    
    static testMethod void testTF_MigrateNotes_Batch_CauseError() {
        User u = zTEST_Shared.insertUser();

        Account a1 = zTEST_Shared.insertAccount(u.Id, '01260000000DXrfAAG'); //OLD - CAS - Campus Accounts
 
        Campus__c camp = new Campus__c();
        camp.Account__c = a1.Id;
        camp.Name = 'test';
        insert camp;

        a1.Admin_Field_1__c = '000000000000000000'; //invalid Id, so it can test our error block
        update a1;
        
        ContentNote cn = new ContentNote();
        cn.Title = 'test';
        String body = 'test';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert(cn);
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = a1.Id;
        cdl.ContentDocumentId = cn.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        Test.startTest();
        TF_MigrateNotes_Batch tfBatch = new TF_MigrateNotes_Batch();
        ID batchprocessid = Database.executeBatch(tfBatch); 
        Test.stopTest();
    }
*/
    
}