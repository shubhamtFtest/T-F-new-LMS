/**************************************************
* Created by: Tom Reed: 2018-07-30
* Tested class for: ArticleFeedback_ctr
**************************************************/

@istest
public class zTest_ArticleFeedback_ctr {
    
    public static testMethod void runArticleFeedback_ctr(){
        
        //Insert a Knowledge Article Feedback record.
        Knowledge_Article_Feedback__c testKAF = new Knowledge_Article_Feedback__c();
        insert testKAF;
        
        //Insert a Knowledge Article record.
        TF_Knowledge__kav testknowledgeArticle = new TF_Knowledge__kav(Knowledge_Article_Feedback__c = testKAF.Id, Title='test', urlname = 'test');
        insert testknowledgeArticle;
        
        //Run the ArticleFeedback_ctr methods.
        ArticleFeedback_ctr.createArticleFeedback(testknowledgeArticle.id, 'John Doe','johndoe@email.com','testFeedback');
        ArticleFeedback_ctr.addVoting(testknowledgeArticle.id, 'Yes');
        ArticleFeedback_ctr.addVoting(testknowledgeArticle.id, 'No');
        
        Knowledge_Article_Feedback__c testKAFUpdated = [SELECT Id, Up_Votes__c, Down_Votes__c 
                                                        FROM Knowledge_Article_Feedback__c 
                                                        WHERE id =: testKAF.Id LIMIT 1];
        
        system.assertEquals(1, testKAFUpdated.Up_Votes__c);
        system.assertEquals(1, testKAFUpdated.Down_Votes__c);            
        
        ArticleFeedback_ctr.addVoting(testknowledgeArticle.id, 'Yes');
        ArticleFeedback_ctr.addVoting(testknowledgeArticle.id, 'No');
        
        testKAFUpdated = [SELECT Id, Up_Votes__c, Down_Votes__c 
                          FROM Knowledge_Article_Feedback__c 
                          WHERE id =: testKAF.Id LIMIT 1];            

        system.assertEquals(2, testKAFUpdated.Up_Votes__c);
        system.assertEquals(2, testKAFUpdated.Down_Votes__c);        
        
    }
}