@isTest
public class Test_CaseWithAttachment {
	
    static testMethod void setupTestData(){
        
        Case case_Obj = new Case(Status = 'New', Subject = 'Scheduled Report: OA Article Publishing Charges', Priority = 'High', IsEscalated = false);
        Insert case_Obj;
        
        EmailMessage email_Obj = new EmailMessage(Incoming = true, ParentId = case_Obj.Id);
        Insert email_Obj;
        
        Attachment attachment_Obj = new Attachment(ParentId = email_Obj.id, Name = 'Name288', IsPrivate = false, Body = Blob.valueOf('Unit Test Attachment Body'));
        Insert attachment_Obj;
        
        System.debug('attachment_Obj '+attachment_Obj);
        test.startTest();
        CasesWithAttachment obj01 = new CasesWithAttachment();
        CasesWithAttachment.getData();
        test.stopTest();
    }
}