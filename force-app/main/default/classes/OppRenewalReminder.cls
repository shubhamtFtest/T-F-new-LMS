//Modified by Jeff Lup - 2018.03.08 - CHG0042222 (added AccountId and Account.Name to the query)
//Modified by Piyush Jain - 2018.03.12 - CHG0042222 (added Amount_USD__c to the opps query)
global class OppRenewalReminder implements Schedulable {

    global void execute(SchedulableContext sc) {
        
        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getOrgDefaults();
        Id orgWideEmailAddressId = setting.Org_Wide_Email_Address_Id__c; //the sender of the email
        String testingEmail = setting.Inbound_Email_Error_Address__c; //the recipient if in a sandbox
        
        Id tfTaskRecordtype = MiscFunctions.getRecordtypeId('Task', 'T&F - Tasks'); //CHG0038379
        
        List<Opportunity> opps = [SELECT Id,Amount_USD__c , Product_Family__c, End_Date__c, Stage_Date__c,
                                    Date_Sent__c, Date_Reminder_Sent__c, Date_Second_Reminder_Sent__c, Owner.Email, Previous_Renewal__r.End_Date__c
                                    , AccountId, Account.Name //CHG0042222
                                  FROM Opportunity
                                  WHERE StageName = 'Evaluating'
                                    AND Don_t_Send__c = false
                                    AND Order_Type__c <> 'Maintenance'
                                    AND Order_Type__c <> 'One-Time Purchase'
                                    AND Renewal_Method__c <> 'Agent'
                                    AND Renewal_Method__c <> 'Consortium/Network'
                                    AND Stage_Date__c = LAST_N_DAYS:95
                                    AND (Date_Sent__c = null
                                        OR Date_Reminder_Sent__c = null
                                        OR Date_Second_Reminder_Sent__c = null)];
        if (opps.size() > 0) {
            Set<Id> oppIds = new Set<Id>();
            for (Opportunity opp : opps) {
                Integer daysOnEvaluating = opp.Stage_Date__c.daysBetween(Date.Today());
                if (opp.Date_Sent__c == null && daysOnEvaluating >= 0 && daysOnEvaluating < 5) {
                    opp.Date_Sent__c = system.now(); //Sending first email
                    oppIds.add(opp.Id);
                } else if (opp.Date_Reminder_Sent__c == null && daysOnEvaluating >= 60 && daysOnEvaluating < 65) {
                    opp.Date_Reminder_Sent__c = system.now();  //Sending 1st reminder
                    oppIds.add(opp.Id);
                } else if (opp.Date_Second_Reminder_Sent__c == null && daysOnEvaluating >= 90 && daysOnEvaluating < 95) {
                    opp.Date_Second_Reminder_Sent__c = system.now(); //Sending 2nd reminder
                    oppIds.add(opp.Id);
                }
            }

            if (oppIds.size() > 0) {                
                //save changes to dates
                update opps;
                //Get OLI/Product Information
                List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, Product2.Name, TotalPrice, CurrencyIsoCode, Previous_Sales_Price__c,
                                                    Product2.Current_Year__c, Product2.Current_Year_Number_of_Titles__c, Product2.Current_Year_Value_of_Titles__c,
                                                    Product2.Next_Year__c, Product2.Next_Year_Number_of_Titles__c, Product2.Next_Year_Value_of_Titles__c
                                                  FROM OpportunityLineItem
                                                  WHERE OpportunityId IN :oppIds];
                Map<Id, List<OpportunityLineItem>> mapOppIdToOlis = new Map<Id, List<OpportunityLineItem>>();
                for (OpportunityLineItem oli : olis) {
                    List<OpportunityLineItem> olisThisOpp = new List<OpportunityLineItem>();
                    if (mapOppIdToOlis.containsKey(oli.OpportunityId))
                        olisThisOpp = mapOppIdToOlis.get(oli.OpportunityId);
                    olisThisOpp.add(oli);
                    mapOppIdToOlis.put(oli.OpportunityId, olisThisOpp);
                }
                //Get OCR Information
                List<OpportunityContactRole> ocrs = [SELECT Id, OpportunityId, Contact.Id, Contact.Name, Contact.Email
                                                     FROM OpportunityContactRole
                                                     WHERE OpportunityId IN :oppIds
                                                        AND Role = 'Delivery'];
                Map<Id, OpportunityContactRole> mapOppIdToOcr = new Map<Id, OpportunityContactRole>();
                for (OpportunityContactRole ocr : ocrs) {
                    mapOppIdToOcr.put(ocr.OpportunityId, ocr);
                }
                //Construct Emails
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                List<Attachment> oppAttachments = new List<Attachment>();           
                List<Task> oppTasks = new List<Task>();         
                for (Opportunity opp : opps) {
                    //Check for missing records
                    if (mapOppIdToOcr.containsKey(opp.Id) && mapOppIdToOlis.containsKey(opp.Id) && opp.Amount_USD__c != null && opp.Amount_USD__c != 0) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        //email.setTargetObjectId(mapOppIdToOcr.get(opp.Id).Contact.Id); //for Contact's activity related list
                        //email.setWhatId(opp.Id); //for Opp's activity related list                        
                        if (MiscFunctions.isProduction())
                            email.setToAddresses(new String[] {mapOppIdToOcr.get(opp.Id).Contact.Email});
                        else
                            email.setToAddresses(new String[] {testingEmail}); //so customers don't get emails from a sandbox
                        email.setOrgWideEmailAddressId(orgWideEmailAddressId);
                        email.setReplyTo(opp.Owner.Email);
                        //**** Set Body using OppRenewalPrompt_TFeBooks_Email.cls
                        String emailBody = OppRenewalPrompt_TFeBooks_Email.getEmail(opp, mapOppIdToOlis.get(opp.Id), mapOppIdToOcr.get(opp.Id));
                        email.setHtmlBody(emailBody);
                        emails.add(email);
                        //Add to Opp's Attachments Related List
                        Attachment oppAttachment = new Attachment();
                        oppAttachment.ParentId = opp.Id;
                        oppAttachment.Name = 'RenewalReminder.html';
                        oppAttachment.Body = Blob.valueOf(emailBody);
                        oppAttachment.Description = 'Renewal Reminder Email Sent to the Primary Contact';
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
                if (emails.size() > 0)
                    If (Test.isRunningTest() != true)
                        {
                           Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                        }   
                //Insert all attachments
                if (oppAttachments.size() > 0)
                    insert oppAttachments;
                //Insert all tasks
                if (oppTasks.size() > 0)
                    insert oppTasks;
            }
        }       
    }

}