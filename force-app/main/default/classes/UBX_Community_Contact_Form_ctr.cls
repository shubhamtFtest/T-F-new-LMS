/**************************************************
* Created by: Tom Reed: 2018-07-30
* Tested by: zTest_UBX_Community_Contact_Form_ctr @ 86%
* Notes: 
* The logic below will only look for knowledge articles which are accessable through the public channel. (IsVisibleInPkb = True)
* Should this logic need to be extended to authenticated community users the code will need to be updated.

* Update by : Ashish Purwar : 2019-01-24
  Added conditional logic for picklists filling based on parent portal.
* Updated by : Renil Rejith
  Updated line 169 to include case submissions in query.	
**************************************************/

//Without sharing so the Community user gets access to locate the contact to link to the incoming case.
public without sharing class UBX_Community_Contact_Form_ctr {
    
    @AuraEnabled
    public static Boolean runningInASandbox() {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    //Logic has been added to a class "with sharing" to stop articles being selected which shouldn't be visible in the community.
    @AuraEnabled
    public static List<UBX_Community_Get_Deflection_Articles.ArticleDetails> getArticleTableData(String topicName,string ProductPlatform ){
        
        List<UBX_Community_Get_Deflection_Articles.ArticleDetails> listOfResults = new List<UBX_Community_Get_Deflection_Articles.ArticleDetails>();
        listOfResults = UBX_Community_Get_Deflection_Articles.getArticleDetails(topicName,ProductPlatform);
        return listOfResults;
        
    }
    //If emailid is present in the setting item then we need to disable file upload field
    @AuraEnabled
    public static string getSettingItemEmailId(String ProductPLatform,String CustomerType, String Topic,String Reason){
        try{
        Setting_Item__c SettingItemrecord=[SELECT Long_Text_1__c from Setting_Item__c WHERE Text_6__c=:ProductPLatform AND Text_1__c=:CustomerType AND Text_4__c=:Topic AND Text_3__c=:Reason limit 1];
        return SettingItemrecord.Long_Text_1__c;
        } catch (exception e){
            return '';            
        }        
    } 
    @AuraEnabled
    public static list<String> getListDetails(String listType, String valuePicked, String customerType, String Parent)
    {        
        
        //Use the setting items below to locate the dynamic picklist values.
        set<String> returnedPicklistValuesSet = new set<String>();
        Setting__c settingRecord = [SELECT Id FROM Setting__c WHERE Name = 'UBX_Community_Contact_Form_Picklist_Values'];        
        
        String communityname = Parent+' Community Contact Form';
        if(listType == 'getTopic'){
            list<Setting_Item__c> values=new list<Setting_Item__c>();
               values = [SELECT Text_3__c 
                                            FROM Setting_Item__c 
                                            WHERE Text_4__c = '' 
                                            AND Text_1__c =: valuePicked 
                                            AND Setting__c =: settingRecord.Id
                                            AND Text_2__c=:communityname    
                                            ORDER BY Text_3__c ASC];           
                
            //Add a blank value to the list as default.
            returnedPicklistValuesSet.add('');
            for(Setting_Item__c si: values){
                returnedPicklistValuesSet.add(si.Text_3__c);
            }
        }
        
        if(listType == 'getContactReason'){
            list<Setting_Item__c> values = [SELECT Text_3__c 
                                            FROM Setting_Item__c 
                                            WHERE Text_4__c =: valuePicked 
                                            AND Setting__c =: settingRecord.Id 
                                            AND Text_2__c=:communityname
                                            AND Text_1__c =: customerType
                                            ORDER BY Text_3__c ASC];  
            system.debug(communityname+'-'+values);
            //Add a blank value to the list as default.
            returnedPicklistValuesSet.add('');
            for(Setting_Item__c si: values){
                returnedPicklistValuesSet.add(si.Text_3__c);
            }
        } 
        //Convert the set into a list to return.
        list<String> returnedPicklistValues = new list<String>();
        for(String picklistValues: returnedPicklistValuesSet){
            returnedPicklistValues.add(picklistValues);  
        }
        
        return returnedPicklistValues;   
    }
    
    @AuraEnabled
    public static sObject caseDeflectionMethod(String articleId, String previousArticleId){
        
        //If the currently selected article and the previous are the same 
        //don't do anything because the logic has already run on the article.
        
        if(articleId != previousArticleId){
        //Locate knowledge article.
        Map<String, String> articleIdToType = new Map<String, String>();
        for(TF_Knowledge__kav kaf: [SELECT Id, Knowledge_Article_Feedback__c, KnowledgeArticleId
                                    FROM TF_Knowledge__kav 
                                    WHERE (KnowledgeArticleId =: articleId 
                                           OR KnowledgeArticleId =: previousArticleId)
                                    AND PublishStatus = 'Online' 
                                    AND IsVisibleInPkb = True]){
                                        String typeValue;                                     
                                        if(kaf.KnowledgeArticleId == articleId && (articleId != null && articleId != '')){ 
                                            typeValue = 'New Article Selected';
                                        }
                                        if(previousArticleId != null && previousArticleId != ''){
                                            if(kaf.KnowledgeArticleId == previousArticleId){ 
                                                typeValue = 'Previous Article Selected';
                                            }
                                        }
                                        articleIdToType.put(kaf.Knowledge_Article_Feedback__c, typeValue);
                                        
                                    }
        
        //Locate the Knowledge Article Feedback record to update.
        list<Knowledge_Article_Feedback__c> kafToUpdate = new list<Knowledge_Article_Feedback__c>();
        for(Knowledge_Article_Feedback__c kaf: [SELECT Id, Case_Deflections__c FROM Knowledge_Article_Feedback__c
                                                WHERE Id =: articleIdToType.KeySet()]){ 
                                                    
                                                    //For the currently selected article id.
                                                    if(articleIdToType.get(kaf.Id) == 'New Article Selected'){
                                                        //If Case_Deflections__c is null make it 1, otherwise add 1 to the existing value.
                                                        if(kaf.Case_Deflections__c == null){
                                                            kaf.Case_Deflections__c = 1;
                                                        } else {                          
                                                            kaf.Case_Deflections__c = kaf.Case_Deflections__c + 1;
                                                        }        
                                                    }
                                                    //For the previously selected article id.
                                                    if(articleIdToType.get(kaf.Id) == 'Previous Article Selected'){
                                                        //Remove the article case deflection.
                                                        if(kaf.Case_Deflections__c == null){
                                                            kaf.Case_Deflections__c = 0;
                                                        } else {                          
                                                            kaf.Case_Deflections__c = kaf.Case_Deflections__c - 1;
                                                        }        
                                                    }                                                   
                                                    kafToUpdate.add(kaf);                    
                                                }       
        
        if(kafToUpdate.size()>0){
            update kafToUpdate;
        }
        }
        
        sObject listOfResults = UBX_Community_Get_Deflection_Articles.getArticleDescription(articleId);
        return listOfResults;
        
    }
   
   
    @AuraEnabled
    public static Id createCase(String queryType, String vendorId, String articleIdValue, String customerTypeValue, String emailAddressValue, String institutionNameValue, String titleValue, String nameValue, String isbnValue, string additionalCommentsValue, String priorityValue, String topicValue, String contactReasonValue, String agentNameValue, String agentEmailValue, string SourceCommunity){
        
        //Remove the case deflection value because the article didn't stop the case from being submitted.
        if(articleIdValue != 'Blank' && articleIdValue != ''){
            TF_Knowledge__kav knowledgeArticleId = [SELECT Id, Knowledge_Article_Feedback__c 
                                                    FROM TF_Knowledge__kav 
                                                    WHERE KnowledgeArticleId =: articleIdValue 
                                                    AND PublishStatus = 'Online' LIMIT 1];
            
            list<Knowledge_Article_Feedback__c> kafToUpdate = new list<Knowledge_Article_Feedback__c>();
            
            for(Knowledge_Article_Feedback__c kaf: [SELECT Id, Case_Deflections__c, Case_Submissions__c FROM Knowledge_Article_Feedback__c
                                                    WHERE Id =: knowledgeArticleId.Knowledge_Article_Feedback__c]){
                                                        //If Case_Deflections__c is null or 0 make it 0, otherwise subtract 1 to the existing value.
                                                        if(kaf.Case_Deflections__c == null || kaf.Case_Deflections__c == 0){
                                                            kaf.Case_Deflections__c = 0;    
                                                        } else {
                                                            kaf.Case_Deflections__c = kaf.Case_Deflections__c -1;  
                                                        }
                                                        //If Case_Submissions__c is null make it 1, otherwise add 1 to the existing value.
                                                        if(kaf.Case_Submissions__c == null){
                                                            kaf.Case_Submissions__c = 1;
                                                        } else {
                                                            kaf.Case_Submissions__c = kaf.Case_Submissions__c +1;
                                                        }
                                                        kafToUpdate.add(kaf);
                                                    }
            if(kafToUpdate.size() > 0){
                update kafToUpdate;
            }
        }
        //Create a map for the Product Platform, Query Type and Query Category fields to be mapped from the setting item values
        
        String communityname = SourceCommunity+' Community Contact Form';
        Setting__c settingRecord = [SELECT Id FROM Setting__c WHERE Name = 'UBX_Community_Contact_Form_Picklist_Values'];
        map<String,Setting_Item__c> caseFieldsMap = new map<String,Setting_Item__c>();
        for(Setting_Item__c si: [SELECT Text_1__c,Text_3__c,Text_4__c,Text_6__c,Text_7__c,Text_8__c,Long_Text_1__c 
                                 FROM Setting_Item__c WHERE Setting__c =: settingRecord.Id AND Text_2__c=:communityname ]){
                                     caseFieldsMap.put(si.Text_1__c + si.Text_4__c + si.Text_3__c, si);                                      
                                     //A key is created by combining customer type + topic value + contact reason.
                                 } 
      //If Setting item contains an email id then email need to be sent instead of creating case
      //This is to implement functionality of sending emails instead of creating case for some combinations of values in setting items for TFO help portal
      //Ashish Purwar-27/02/2019
        system.debug('customerTypeValue'+customerTypeValue+'topicValue'+topicValue+'contactReasonValue'+contactReasonValue);
        if(caseFieldsMap.containsKey(customerTypeValue+topicValue+contactReasonValue))
        {
            String EmailIdToreplaceCase=caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Long_Text_1__c;
            if(EmailIdToreplaceCase!=null)
            {
                id Nullid;            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;           
                String[] toAddresses = new String[] {caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Long_Text_1__c};
                    mail.setToAddresses(toAddresses) ;
                mail.setSubject(caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Text_3__c);                   
                String body = 'Customer Type: ' + customerTypeValue + '</br>' +
                    'Request Priority: '+priorityValue+'</br>'+
                    'Contact Category: '+topicValue+'</br>'+
                    'Contact Reason: '+contactReasonValue+'</br>'+                               
                    'Full Name: ' + nameValue + '</br>' +   
                    'Email Address: ' + emailAddressValue + '</br>' +
                    'Title: ' + titleValue + '</br>' +
                    'ISBN/ISSN/Order Number: ' + isbnValue + '</br>' +
                    'Additional Comments: ' + additionalCommentsValue;           
                mail.setHtmlBody(body);         
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                return Nullid;
            }
        }     
        
        // If the case prioirty is high use CSD UBX Priority
        // If the case prioirty is not high use CSD UBX
        // Case assignment takes place using the case assignment rules.
        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox.
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        dmlOpts.EmailHeader.triggerAutoResponseEmail= true;//Ashish Purwar- Added this line to activate auto response rule

        
        // If contact is known by email address link them to the new case, also link their account.
        list<Contact> locatedContact = new list<Contact>(); 
        if(emailAddressValue != ''){
            try{           
                locatedContact = [SELECT Id, AccountId FROM Contact WHERE email =: emailAddressValue];           
            } catch(exception e){
                system.debug('Error: ' + e.getMessage());
            }
        }
        
        // If multiple contacts are found for the same email don't link the contact and account.       
        // Use T&F - CSD eBooks record type.
        //Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD eBooks').getRecordTypeId();
        Id caseRecordTypeId;
        if(SourceCommunity=='UBX'){
        caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD eBooks').getRecordTypeId();
        }
        else if(SourceCommunity=='TFO'){
            caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD').getRecordTypeId();
        }
        else if(SourceCommunity=='book_authors'){
            if(vendorId.startsWith('SE') || vendorId.startsWith('se') || (vendorId.length()<=6) && (!vendorId.startsWith('S') && !vendorId.startsWith('s')) ){ 
                caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - CSD Book Royalties').getRecordTypeId();
            }else
               caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - US Book Royalties').getRecordTypeId();

        }
        Case newCase = new Case();
        system.debug('locatedContact ' + locatedContact);
        //If the contact has been located link it to the incoming case.
        if(locatedContact.size() == 1){
            newCase.ContactId = locatedContact[0].Id;
            if(locatedContact[0].AccountId != null){
                newCase.AccountId = locatedContact[0].AccountId;
            }
        }                
        
        if(emailAddressValue != ''){
            newCase.SuppliedEmail = emailAddressValue;
        }
        
        if(emailAddressValue == '' && agentEmailValue != ''){
            newCase.SuppliedEmail = agentEmailValue;
        }
        
        //So the agent values don't appear on the case if they don't get populated by the customer.
        String agentNameString = '';
        String agentEmailString = '';
        if(agentNameValue != ''){agentNameString = 'Agent Name: ' + agentNameValue + ' \r\n';}
        if(agentEmailValue != ''){agentEmailString = 'Agent Email: ' + agentEmailValue + ' \r\n';}       
        //Should there be an error with the webform to case mapping.
        try{   
            if(customerTypeValue=='Librarian/Institution'){
                 newCase.Customer_Type111__c='Librarian';//Added this line to save customer type in the case. This is for case assignment rule for TFO community.
            }
            else if(customerTypeValue=='Student/Researcher'){
                newCase.Customer_Type111__c='Student';//Added this line to save customer type in the case. This is for case assignment rule for TFO community.
            }
            else{
                newCase.Customer_Type111__c=customerTypeValue;//Added this line to save customer type in the case. This is for case assignment rule for TFO community.
            }  
         if(SourceCommunity=='book_authors'){
             string queryTypeStr='';
             if(topicValue!='Other')
                 queryTypeStr=topicValue;
             else{
                 queryTypeStr=queryType;
                 newCase.Subject_Explanation__c=queryType;
             }
             newCase.RR_Vendor_Id__c=vendorId;
             system.debug('queryTypeStr='+queryTypeStr+'vendorId='+vendorId);
             newCase.Subject=queryTypeStr+' - '+vendorId;
             newCase.Query_Type__c=topicValue;
             newCase.Query_Category__c='Royalties';
             newCase.Product_Platform__c='Authors Portal';
             if(caseRecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('T&F - US Book Royalties').getRecordTypeId())
                 newCase.origin  ='T&F - US Book Royalties';
             else{
                     if(topicValue=='Bank Details' || topicValue=='Personal Details' || topicValue=='Address Change' || topicValue=='Login'){
                         newCase.origin  ='AM - Book Royalties - Account Update';
                     }else if(topicValue=='Statements'){
                         newCase.origin  ='AM - Book Royalties - Statement Requests';
                     }
                     else if(topicValue=='Tax Form'  || topicValue=='Other'){
                         newCase.origin  ='T&F - CSD Book Royalties';
                     }
                 }
             newCase.Description=additionalCommentsValue;
         }else{
             newCase.Query_Type__c = caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Text_8__c;
             newCase.Subject = caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Text_8__c;
             newCase.Product_Platform__c = caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Text_6__c;
             newCase.Query_Category__c = caseFieldsMap.get(customerTypeValue+topicValue+contactReasonValue).Text_7__c;
         }
            
        } catch(exception e){
            system.debug(e.getMessage());
            newCase.Product_Platform__c = '';
            newCase.Query_Category__c = '';
            newCase.Query_Type__c = '';  
            newCase.Subject = '';
        }
        newCase.Priority = priorityValue;
        newCase.RecordTypeId = caseRecordTypeId;
        if(SourceCommunity=='UBX'){
            newCase.Description = 'Customer Type: ' + customerTypeValue + ' \r\n' +
            'Institution Name: ' + institutionNameValue + ' \r\n' +
            'Full Name: ' + nameValue + ' \r\n' +
            agentNameString +
            agentEmailString +
            'Book Title: ' + titleValue + ' \r\n' +
            'ISBN: ' + isbnValue + ' \r\n' +
            'Additional Comments: ' + additionalCommentsValue;
        }
        else if(SourceCommunity=='TFO' && customerTypeValue=='Agent'){
            newCase.Description = 'Customer Type: ' + customerTypeValue + ' \r\n' +
            'Institution Name: ' + institutionNameValue + ' \r\n' +
            'Full Name: ' + nameValue + ' \r\n' +
            agentNameString +
            agentEmailString +
            'Journal Title: ' + titleValue + ' \r\n' +
            'Order Number: ' + isbnValue + ' \r\n' +
            'Additional Comments: ' + additionalCommentsValue;
        }
        else if(SourceCommunity=='TFO' && customerTypeValue!='Agent')
        {
           newCase.Description = 'Customer Type: ' + customerTypeValue + ' \r\n' +
            'Institution Name: ' + institutionNameValue + ' \r\n' +
            'Full Name: ' + nameValue + ' \r\n' +
            'Journal Title: ' + titleValue + ' \r\n' +
            'ISSN: ' + isbnValue + ' \r\n' +            
            'Additional Comments: ' + additionalCommentsValue; 
        }
        
        
        if(SourceCommunity!='book_authors'){
            newCase.Origin = SourceCommunity+' Community Help Portal';
        }
        if(nameValue != ''){
            newCase.SuppliedName = nameValue;
        }
        if(nameValue == '' && agentNameValue != ''){
            newCase.SuppliedName = agentNameValue;
        }
        
        //Use active assignment rules.
        //Ashish Purwar-14/02/2019, Updated DML options for auto response rule.
        newCase.setOptions(dmlOpts);

        try{
         insert newCase ;  
        }Catch(DMLException ex){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
            String[] toAddresses = new String[] {'ashish.purwar@tandfindia.com'};
            mail.setToAddresses(toAddresses) ;
            mail.setSubject('Exception: '+SourceCommunity+' Contact Form');
            String errorMessage = ex.getMessage();             
            String body = 'An exception has occured while trying to insert a case in class '+SourceCommunity+'_Community_Contact_Form.' + newCase.Description + ' Contact Category: ' + topicValue + ' Contact Reason: ' + contactReasonValue + ' Error Message '+errorMessage;
           
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        }
        
        //To be used later if a file needs to be attached to the case.
        return newCase.id;
        
    }
    
    @AuraEnabled
    public static String getScreen(String customerType, String topic, String SourceCommunity){
        //The Setting Item records below are used to identify which screen should be displayed to the user based upon the customer and contact reason (topic) selected.
        list<String> returnedPicklistValues = new list<String>();
        Setting__c settingRecord = [SELECT Id FROM Setting__c WHERE Name = 'UBX_Community_Contact_Form_Picklist_Values'];
        String CommunityName = SourceCommunity+' Community Contact Form';
        system.debug(topic+'customerType='+customerType+'CommunityName'+CommunityName);
        Setting_Item__c values = [SELECT Text_5__c FROM Setting_Item__c WHERE Text_3__c =: topic AND Text_1__c =: customerType AND Setting__c =: settingRecord.Id AND Text_2__c=:CommunityName LIMIT 1];
        String valueToReturn = String.ValueOf(values.Text_5__c);
        return valueToReturn;
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert,
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks  
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
}