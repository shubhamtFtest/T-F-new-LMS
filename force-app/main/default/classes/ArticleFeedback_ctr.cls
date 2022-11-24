/**************************************************
* Created by: Tom Reed: 2018-07-30
* Edited by: Matthew Smith: 2021-08-10 | Made the controller run in system mode due to the latest guest user security access.
* Edited by: Renil Rejith: 2022-01-27  | [SAL-5319] Made changes to include Name and Email(if available) when an article feedback is created.
* Tested by: zTest_ArticleFeedback_ctr @ 100%
**************************************************/

public without sharing class ArticleFeedback_ctr {
    
    @AuraEnabled
    public static void createArticleFeedback(Id articleId, String name, String email, String feedback){
        
        //Locate the Knowledge article. 
        //Upon article creation all articles will have a feedback record auto created 
        //by the process builder Show all versionsKnowledge Article Feedback Record Create.
        
        TF_Knowledge__kav knowledgeArticle = [SELECT Id, Knowledge_Article_Feedback__c FROM 
                                              TF_Knowledge__kav 
                                              WHERE Id =: articleId LIMIT 1]; 
        
        //Continue and create the new feedback item for the feedback provided by the user.
        Knowledge_Article_Feedback_Item__c newFeedbackItem 	= new Knowledge_Article_Feedback_Item__c();
      	newFeedbackItem.Name__c 							= (name != null || name != '')?name:'';
        newFeedbackItem.Email__c 							= (email != null || email != '')?email:'';
        newFeedbackItem.Article_Feedback__c 				= feedback;
        newFeedbackItem.Knowledge_Article_Feedback__c 		= knowledgeArticle.Knowledge_Article_Feedback__c;
        insert newFeedbackItem;       
    }
    
    @AuraEnabled
    public static void addVoting(Id articleId, String vote){
        //Get the Knowledge Article record from the incoming Id.
        TF_Knowledge__kav knowledgeArticle = [SELECT Id, Knowledge_Article_Feedback__c FROM TF_Knowledge__kav WHERE Id =: articleId LIMIT 1];
        //Locate the associated Knowledge Article Feedback record.
        Knowledge_Article_Feedback__c knowledgeArticleFeedback = [SELECT Id, Up_Votes__c, Down_Votes__c FROM Knowledge_Article_Feedback__c WHERE Id =: knowledgeArticle.Knowledge_Article_Feedback__c];
        
        if(vote == 'Yes'){
            if(knowledgeArticleFeedback.Up_Votes__c == null){
                knowledgeArticleFeedback.Up_Votes__c = 1;  
            } else {
            knowledgeArticleFeedback.Up_Votes__c =  knowledgeArticleFeedback.Up_Votes__c + 1;
            }
        }       
        if(vote == 'No'){
            if(knowledgeArticleFeedback.Down_Votes__c == null){
                knowledgeArticleFeedback.Down_Votes__c = 1;  
            } else {
            knowledgeArticleFeedback.Down_Votes__c = knowledgeArticleFeedback.Down_Votes__c + 1;
            }
        }       
        update knowledgeArticleFeedback;       
    }
}