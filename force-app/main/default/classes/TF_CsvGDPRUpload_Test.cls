@isTest
public class TF_CsvGDPRUpload_Test {
@isTest
    public static void TestCsvMethod(){
         Blob bodyBlob=Blob.valueOf('EMAIL,Status,Reason\n test@test1.com,Prospect,Test \n test3@test.com,Prospect,Test'); 
        ContentVersion contentVersion_1 = new ContentVersion(Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H');
        
    insert contentVersion_1;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
    List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    System.assertEquals(documents.size(), 1);
    System.assertEquals(documents[0].Id, contentVersion_2.ContentDocumentId);
    System.assertEquals(documents[0].LatestPublishedVersionId, contentVersion_2.Id);
    System.assertEquals(documents[0].Title, contentVersion_2.Title);
   Email_preference__c empfr= new Email_preference__c();
        empfr.Email__c='test@test1.com';
        empfr.Status__c='Unsubscribed';
        empfr.Reason__c='Book Purchasing Page Opt Out';
        insert empfr;
        system.debug('empfr'+empfr);
       // System.runAs(u) {
        Test.startTest();       
        CSVFileReadLWCCntrl.csvFileRead(documents[0].Id);
       // Mehtod Calling
        Test.stopTest();
   // }
}
}