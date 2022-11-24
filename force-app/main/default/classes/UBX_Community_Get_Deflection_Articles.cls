/**************************************************
* Created by: Tom Reed: 2018-10-19
* Tested by: zTest_UBX_Community_Contact_Form_ctr @ 84%
* Notes: 
* This class was created to be called from UBX_Community_Contact_Form_ctr because it needs to run with sharing.
* Updated by Ashish Purwar ; 2019-01-30
* To include TFO_Community_Contact_Topic_Map
**************************************************/
public with sharing class UBX_Community_Get_Deflection_Articles {
    
    public static List<ArticleDetails> getArticleDetails(String topicName,string ProductPlatform){
        system.debug(topicName+'-'+ProductPlatform); 
        boolean exceptionThrown = false;
        map<Setting_Item__c, String> mappedTopicMap = new map<Setting_Item__c, String>();
        list<ArticleDetails> artDetails = new List<ArticleDetails>();
        map<Id,KnowledgeArticleVersion> articlesMap = new map<Id,KnowledgeArticleVersion>();
        //Based upon the contact reason selected in the UI locate the related topic from the mapping below.
        Setting__c settingRecord = [SELECT Id FROM Setting__c WHERE Name = 'UBX_Community_Contact_Topic_Map'];
        string s = '%' + ProductPlatform + '%'; 
        try{
            for(Setting_Item__c si: [SELECT Text_1__c
                                     FROM Setting_Item__c
                                     WHERE Setting__c =: settingRecord.Id AND Text_2__c =: topicName and Text_3__c LIKE:s]){
                                         mappedTopicMap.put(si, si.Text_1__c);
                                     }            
               system.debug(mappedTopicMap);      
        }
       
        catch (exception e){
            exceptionThrown = true;   
        }
        
        if(exceptionThrown == false){
            String communityId;
            if(Test.isRunningTest()){
                Network communityForTesting =  [SELECT Id 
                                                FROM network 
                                                WHERE Name = 'Help Center - Librarian/Institution' LIMIT 1];
                communityId = communityForTesting.Id;
            } else {
                //Get the viewing Community Network Id
                communityId = Network.getNetworkId();
            }
            
            //Get the topic id from the name.
            list<Id> topicIdList = new list<Id>();     
            for(Topic t: [SELECT Id FROM Topic WHERE Name in: mappedTopicMap.values()]){
                topicIdList.add(t.Id);
            }
            system.debug('topicIdList '+topicIdList);
            system.debug('communityId '+communityId);
            
            List<Id> topArticles = new List<Id>();
            List<Id> topicAssignmentIds = new List<Id>();
            
            //Locate the topics assigned to the Community.
            for(TopicAssignment ta: [SELECT EntityId
                                     FROM TopicAssignment
                                     WHERE TopicId in: topicIdList  AND NetworkId =: communityId LIMIT 999]){
                                         //Limit of 999 added as this is a restriction imposed on Communities.
                                         topicAssignmentIds.add(ta.EntityId);
                                         //Entity id is the knowledge article version id.
                                     }
            system.debug('topicAssignmentIds'+topicAssignmentIds);
            //Locate the Knowledge Article id from the Knowledge Article Version id.
            for(KnowledgeArticleVersion kav: [SELECT KnowledgeArticleId, Title, UrlName FROM KnowledgeArticleVersion
                                              WHERE  Id in: topicAssignmentIds AND IsLatestVersion = true AND PublishStatus = 'Online' AND IsVisibleInPkb = True]){
                                                  articlesMap.put(kav.KnowledgeArticleId, kav);
                                                  //Locate the articles linked to the topic in question.
                                                  //Making sure only the latest article versions are used.
                                                  //IsVisibleInPkb indicates if the article is visible in the public knowledge base.
                                              }
             system.debug('articlesMap '+articlesMap);
            for(KnowledgeArticleViewStat kavs: [SELECT ParentId
                                                FROM KnowledgeArticleViewStat
                                                WHERE ParentId in: articlesMap.keyset() AND Channel = 'Pkb' ORDER BY ViewCount desc LIMIT 5]){
                                                    topArticles.add(kavs.ParentId);
                                                    //Add the topic 5 most viewed articles for the topic in question.
                                                    //Channel = Pkb indicates that the article is visible in the public knowledge base.
                                                }
            system.debug('top articles '+topArticles);
            //Clear the top articles map.
            //Add the most frequently viewed articles located in the topArticles list.
            //Only when article views were found run the below.
            articlesMap.clear();
            if(topArticles.size() > 0){
                if(ProductPlatform=='book_authors'){
                   for(KnowledgeArticleVersion kav: [SELECT KnowledgeArticleId, Title, UrlName FROM KnowledgeArticleVersion
                                                  WHERE  KnowledgeArticleId in: topArticles 
                                                  AND IsLatestVersion = true
                                                  AND PublishStatus = 'Online'
                                                  AND IsVisibleInPkb = True order by articletotalviewcount  desc limit 3]){
                                                      articlesMap.put(kav.KnowledgeArticleId, kav);  
                                                  }
                }else{
                for(KnowledgeArticleVersion kav: [SELECT KnowledgeArticleId, Title, UrlName FROM KnowledgeArticleVersion
                                                  WHERE  KnowledgeArticleId in: topArticles 
                                                  AND IsLatestVersion = true
                                                  AND PublishStatus = 'Online'
                                                  AND IsVisibleInPkb = True]){
                                                      articlesMap.put(kav.KnowledgeArticleId, kav);  
                                                  }
                }
            }
        }
        
        //If an exception was thrown or the articlesMap is empty return a blank article.
       
        if(articlesMap.size() == 0 || exceptionThrown == true){
            
            ArticleDetails artDet = new ArticleDetails();
            artDet.articleName = 'No Documents Available' ;
            artDet.link = '' ;
            artDet.articleId = '';
            artDetails.add(artDet);
            return artDetails;
            
        } else {
            system.debug('test');
            //Otherwise return the list of most frequently viewed articles.
            map<String,String> mapData = new map<String,String>();
            for(KnowledgeArticleVersion ka: articlesMap.values()){
                ArticleDetails artDet = new ArticleDetails();
                artDet.articleName = ka.Title ;
                artDet.link = 'article/' + ka.UrlName ;
                artDet.articleId = ka.KnowledgeArticleId;
                artDetails.add(artDet);               
            }
        }
        return artDetails;  
        
    }
    
    public static sObject getArticleDescription(String articleId){
        
        sObject articleDetailsList = [SELECT Id, Description__c, Title, Summary FROM TF_Knowledge__kav WHERE KnowledgeArticleId =: articleId 
                                      AND PublishStatus = 'Online' 
                                      AND IsVisibleInPkb = True LIMIT 1];
        return articleDetailsList;
        
    }
    
    public class ArticleDetails {
        
        @AuraEnabled
        public String articleName { get;set; }
        
        @AuraEnabled
        public String link { get; set; }
        
        @AuraEnabled
        public String articleId { get; set; }
        
    }
}