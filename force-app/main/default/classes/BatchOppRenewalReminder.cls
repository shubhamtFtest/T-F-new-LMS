//Class: BatchOppRenewalReminder.cls
//Tested by: zTest_BatchOppRenewalReminder.cls
//Created by Bharat - 2017.12.11 - Ticket #CHG0038754
//Modified by Jeff Lup - 2018.03.08 - CHG0042222 (added AccountId and Account.Name to the query)
//Modified by Shefali - 2018.09.14 - line 34 (new checkbox filter added)

global class BatchOppRenewalReminder implements Database.Batchable<sObject> {
    TF_ERN_Settings__c setting = TF_ERN_Settings__c.getOrgDefaults();
    Id orgWideEmailAddressId = setting.Org_Wide_Email_Address_Id__c; //the sender of the email
    String testingEmail = setting.Inbound_Email_Error_Address__c; //the recipient if in a sandbox
    Set<Id> UpdateOpp=new Set<Id>();
    Map<Id,Date> mapOppQuotaion=new Map<Id,Date>();
    
    // String isNotificationTest = System.Label.OppRenewalNotificationTest;  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Custom Setting Record ======>' + setting);
        Set<String> setRecordtype=new Set<String>{ 'T&F - CAS Opportunity','T&F - CIS Opportunities','T&F - eBooks Opportunity','T&F - Journals Opportunity','T&F - One-Off Opportunity'  };
        Set<Id> setRecordtypeID=new Set<Id>();
        List<recordType> recordTypeId=new List<recordType>([select Id from recordType where name IN : setRecordtype ]);
        system.debug('recordTypeId'+recordTypeId);
         BatchOppRenewal__c cusBatch=BatchOppRenewal__c.getValues('UserID');
        Id userId=cusBatch.UserId__c;
        system.debug('userId'+userId);
        date after31Days = system.today().adddays(31);
        date after61Days=system.today().adddays(61);
        for(recordType rc : recordTypeId )
        {
            setRecordtypeID.add(rc.Id);
        }
        string query= '';
         query= ' SELECT Id, Name FROM Opportunity where RecordTypeId IN : recordTypeId   and owner.Id =: userId  and StageName = \'Evaluating\' and Don_t_Send__c=false';
         query+=' and Next_Renewal__c=null AND (Date_Sent__c = null OR Date_Reminder_Sent__c = null OR Date_Second_Reminder_Sent__c = null)';
         query+= ' and (Start_Date__c =:after31Days or Start_Date__c =:after61Days)';
     //    query+= ' and isEmail__c = false';
        system.debug('@@@@@'+query);
        List<Opportunity> oppList = (List<Opportunity>)Database.query(query);
        System.debug('oppList =======>' + oppList);
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        Id tfTaskRecordtype = [select id from recordtype where name='T&F - Tasks'].id; //T&F - Tasks 01260000000DTdqAAG
        system.debug('ccccccccc'+tfTaskRecordtype);
        // process each batch of records
        Set<Id> UpdateOpp=new Set<Id>();
        for(Opportunity opp : oppList){
            UpdateOpp.add(opp.id);
        }
               List<Opportunity> lstOpportunity= [select Id, Product_Family__c, End_Date__c, Stage_Date__c,
                                           Date_Sent__c, Date_Reminder_Sent__c, Date_Second_Reminder_Sent__c, Owner.Email, Previous_Renewal__r.End_Date__c,
                                           Amount_USD__c,Amount_GBP__c,Start_Date__c,CurrencyIsoCode
                                           , AccountId, Account.Name //CHG0042222
                                         from Opportunity where Id in : UpdateOpp ];
        System.debug('lstOpportunity =======>' + lstOpportunity);
        System.debug('UpdateOpp =======>' + UpdateOpp);
        if (UpdateOpp.size() > 0) { 
            Set<Id> oppIds = new Set<Id>();
            for(Opportunity opp : lstOpportunity){
                Integer daysOnEvaluating = Date.Today().daysBetween(opp.Start_Date__c);
                system.debug('daysOnEvaluating'+daysOnEvaluating+'date'+opp.Date_Sent__c+'remin1'+opp.Date_Reminder_Sent__c+'remin2'+opp.Date_Second_Reminder_Sent__c);
                if (opp.Date_Reminder_Sent__c == null && daysOnEvaluating==61) {
                    opp.Date_Reminder_Sent__c = system.now();  //Sending 1st reminder
                    oppIds.add(opp.Id);
                    system.debug('opp.Date_Reminder_Sent__c'+opp.Date_Reminder_Sent__c);
                } else if (opp.Date_Second_Reminder_Sent__c == null && daysOnEvaluating==31) {
                    opp.Date_Second_Reminder_Sent__c = system.now();  //Sending 1st reminder
                    oppIds.add(opp.Id);
                    system.debug('opp.Date_Reminder2_Sent__c'+opp.Date_Second_Reminder_Sent__c);
                }
            }
            
            if (oppIds.size() > 0) {
                //save changes to dates
                system.debug('Update Opportunitystart'+lstOpportunity);
                update lstOpportunity;
                List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, Product2.Name, TotalPrice, CurrencyIsoCode, Previous_Sales_Price__c,
                                                  Product2.Current_Year__c, Product2.Current_Year_Number_of_Titles__c, Product2.Current_Year_Value_of_Titles__c,
                                                  Product2.Next_Year__c, Product2.Next_Year_Number_of_Titles__c, Product2.Next_Year_Value_of_Titles__c
                                                  FROM OpportunityLineItem
                                                  WHERE OpportunityId IN :UpdateOpp];
                system.debug('OpportunityLineItem'+olis);
                Map<Id, List<OpportunityLineItem>> mapOppIdToOlis = new Map<Id, List<OpportunityLineItem>>();
                for (OpportunityLineItem oli : olis) {
                    List<OpportunityLineItem> olisThisOpp = new List<OpportunityLineItem>();
                    if (mapOppIdToOlis.containsKey(oli.OpportunityId))
                        olisThisOpp = mapOppIdToOlis.get(oli.OpportunityId);
                    olisThisOpp.add(oli);
                    mapOppIdToOlis.put(oli.OpportunityId, olisThisOpp);
                    system.debug('OpportunityLineItem'+oli.OpportunityId);
                    system.debug('OpLatest'+olisThisOpp);
                }
                //Get OCR Information
                List<OpportunityContactRole> ocrs = [SELECT Id, OpportunityId, Contact.Id, Contact.Name, Contact.Email,Contact.Account.Name
                                                     FROM OpportunityContactRole
                                                     WHERE OpportunityId IN :UpdateOpp ];
                                                 //    AND Role = 'Delivery'];
                system.debug('OpportunityContactRole'+ocrs);
                Map<Id, OpportunityContactRole> mapOppIdToOcr = new Map<Id, OpportunityContactRole>();
                for (OpportunityContactRole ocr : ocrs) {
                    mapOppIdToOcr.put(ocr.OpportunityId, ocr);
                    system.debug('OCR'+ocr);
                    system.debug('loop'+ocr.OpportunityId);
                }
                
                
                //Construct Emails
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                List<Attachment> oppAttachments = new List<Attachment>();           
                List<Task> oppTasks = new List<Task>();         
                for (Opportunity opp : lstOpportunity) {
                    system.debug('Enter in Email'+opp.Id);
                    system.debug('keys1'+mapOppIdToOcr);
                    system.debug('keys2'+mapOppIdToOlis);
                    system.debug('Amount'+opp.Amount_USD__c);
                    //Check for missing records
                    integer currencyAmount=0;
                    system.debug(opp.CurrencyIsoCode+'currencycode');
                    if(opp.CurrencyIsoCode == 'USD'){
                        currencyAmount=integer.valueOf(opp.Amount_USD__c);
                         system.debug('currencyAmountUSD'+currencyAmount);
                    }else if(opp.CurrencyIsoCode == 'GBP'){
                        currencyAmount=integer.valueOf(opp.Amount_GBP__c);
                          system.debug('currencyAmountGBP'+currencyAmount);
                    }
                    system.debug('currencyAmount'+currencyAmount);
                    if (mapOppIdToOcr.containsKey(opp.Id) && mapOppIdToOlis.containsKey(opp.Id) && currencyAmount != null && currencyAmount != 0) 
                    {    
                        system.debug('Enter in Email IF');
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        //email.setTargetObjectId(mapOppIdToOcr.get(opp.Id).Contact.Id); //for Contact's activity related list
                        //email.setWhatId(opp.Id); //for Opp's activity related list    
                        system.debug('Email'+mapOppIdToOcr.get(opp.Id).Contact.Email);                  
                        if (MiscFunctions.isProduction())
                            email.setToAddresses(new String[] {mapOppIdToOcr.get(opp.Id).Contact.Email});
                        else
                            email.setToAddresses(new String[] {testingEmail}); //so customers don't get emails from a sandbox
                        system.debug('ORG'+orgWideEmailAddressId+opp.Owner.Email);      
                        email.setOrgWideEmailAddressId(orgWideEmailAddressId);
                        email.setReplyTo(opp.Owner.Email);
                        //**** Set Body using OppRenewalPrompt_TFeBooks_Email.cls
                        String emailBody = OppRenewalPrompt_TFeBooks_Email.getEmail(opp, mapOppIdToOlis.get(opp.Id), mapOppIdToOcr.get(opp.Id));
                        system.debug('Template'+emailBody);     
                        //email.setSubject('')
                        email.setHtmlBody(emailBody);
                        emails.add(email);
                        //Add to Opp's Attachments Related List
                        Attachment oppAttachment = new Attachment();
                        oppAttachment.ParentId = opp.Id;
                        oppAttachment.Name = 'RenewalReminder.html';
                        oppAttachment.Body = Blob.valueOf(emailBody);
                        oppAttachment.Description = 'Renewal Reminder Email Sent to the Primary Contact';
                        system.debug('oppAttachment'+oppAttachment);
                        oppAttachments.add(oppAttachment);
                        //Add a Task
                        Task t = new Task();
                        t.Subject = 'Renewal Reminder';
                        t.Status = 'Completed';
                        t.WhatId = opp.Id;
                        t.Description = emailBody.stripHtmlTags();
                        t.RecordtypeId = tfTaskRecordtype;
                        oppTasks.add(t);
                    }
                    
                    
                }
                //Send all Emails
                if (emails.size() > 0){
                    system.debug('130emails ###'+emails);
                    try{
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                        system.debug('results'+results);}
                    catch(Exception ex){
                        system.debug('error'+ex.getStackTraceString());
                    }
                        
                }
                //Insert all attachments
                if (oppAttachments.size() > 0){
                    system.debug('136attachement ###'+oppAttachments);
                    insert oppAttachments;
                }
                
                //Insert all tasks
                if (oppTasks.size() > 0)
                    insert oppTasks;            
            }
        }
      
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
    
}