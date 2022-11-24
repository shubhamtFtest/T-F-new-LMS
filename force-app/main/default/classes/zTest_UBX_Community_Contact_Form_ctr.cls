/**************************************************
* Created by: Tom Reed: 2018-07-30
* Test class for: UBX_Community_Contact_Form_ctr
**************************************************/

@isTest (SeeAllData = true) // Because Salesforce won't allow Knowledge Articles to be published in a test class.
public class zTest_UBX_Community_Contact_Form_ctr {
    
    static testmethod void testUBX_Community_Contact_Form_ctr(){
        
        list<Knowledge_Article_Feedback__c> ArticleFeedbackList = new list<Knowledge_Article_Feedback__c>();
        for(Knowledge_Article_Feedback__c kaf: [SELECT Id 
                                                FROM Knowledge_Article_Feedback__c]){
                                                    ArticleFeedbackList.add(kaf);
                                                }
        
        
        //locate the realted knowledge articles
        list<String> testArticleList = new list<String>();
        for(TF_Knowledge__kav ka: [SELECT KnowledgearticleId 
                                   FROM TF_Knowledge__kav 
                                   WHERE PublishStatus = 'Online' 
                                   AND IsVisibleInPkb = True
                                   AND Knowledge_Article_Feedback__c in: ArticleFeedbackList]){
                                       testArticleList.add(string.ValueOf(ka.KnowledgearticleId));
                                   }
        
        Case testCase = new Case();
        insert testCase;
        
        UBX_Community_Contact_Form_ctr.runningInASandbox();       
        UBX_Community_Contact_Form_ctr.getArticleTableData('Exploring our content','UBX'); 
        //UBX_Community_Contact_Form_ctr.getArticleTableData('Access Queries','TFO'); 
        
        UBX_Community_Contact_Form_ctr.getSettingItemEmailId('TFO','Societies','Access to content','Access');
        UBX_Community_Contact_Form_ctr.getListDetails('getTopic', 'Agent','','UBX'); 
        UBX_Community_Contact_Form_ctr.getListDetails('getTopic', 'Agent','','TFO');
        UBX_Community_Contact_Form_ctr.getListDetails('getContactReason', 'Access queries','Agent','UBX');
        UBX_Community_Contact_Form_ctr.getListDetails('getContactReason', 'Access Queries','Agent','TFO');
        UBX_Community_Contact_Form_ctr.caseDeflectionMethod(testArticleList[0], null); 
        
        UBX_Community_Contact_Form_ctr.createCase('test','test',testArticleList[0], 'Agent', 'tom.reed@tandf.co.uk', 'Test Institution', 'Test Title', 'Tom Reed', '1234567891011', 'Test Comments', 'High', 'Access to content', 'Access to content', 'Tom', 'ashish.purwar@tandfindia.com','UBX');        
        UBX_Community_Contact_Form_ctr.createCase('test','test',testArticleList[0], 'Agent', 'tom.reed@tandf.co.uk', 'Test Institution', 'Test Title', 'Tom Reed', '1234567891011', 'Test Comments', 'High', 'Access to content', 'Access', 'Tom', 'ashish.purwar@tandfindia.com','TFO');        
        UBX_Community_Contact_Form_ctr.createCase('test','test',testArticleList[0], 'Societies', 'tom.reed@tandf.co.uk', 'Test Institution', 'Test Title', 'Tom Reed', '1234567891011', 'Test Comments', 'High', 'Access to content', 'Access', 'Tom', 'ashish.purwar@tandfindia.com','TFO'); 
        UBX_Community_Contact_Form_ctr.createCase('test','test',testArticleList[0], 'Societies', 'tom.reed@tandf.co.uk', 'Test Institution', 'Test Title', 'Tom Reed', '1234567891011', 'Test Comments', 'High', 'Access to content', 'Access', 'Tom', 'ashish.purwar@tandfindia.com','book_authors'); 

        //UBX_Community_Contact_Form_ctr.getScreen('Agent', 'Access Queries','UBX');
        UBX_Community_Contact_Form_ctr.getScreen('Authors', 'Personal details','book_authors');
        Id attachmentId = UBX_Community_Contact_Form_ctr.saveChunk(testCase.Id, 'Test File', 'Test', 'pdf', '');
        UBX_Community_Contact_Form_ctr.saveChunk(testCase.Id, 'Test File', 'Test', 'pdf', attachmentId);
    }
    
}