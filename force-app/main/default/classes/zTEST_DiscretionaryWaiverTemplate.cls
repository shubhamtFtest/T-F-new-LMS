/*
CreatedBy       : Syam N
Apex Class      : DiscretionaryWaiverTemplateController
*/

@isTest
public class zTEST_DiscretionaryWaiverTemplate {
    private static testmethod void testMethod1(){
        Test.startTest();
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Documentq';
        cv.ContentUrl = 'Document1.pdf';
        //cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        List<ContentVersion> cvList = [SELECT Id, Title,ContentUrl,ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Id=:cvList[0].ContentDocumentId];
        DiscretionaryWaiverTemplateController dwClass = new DiscretionaryWaiverTemplateController();
        dwClass.documentlink = cvList[0].ContentDocumentId;
        String testStr = dwClass.imageURL;
        system.assertEquals(testStr, cvList[0].ContentUrl);
        Test.stopTest();
    }
}