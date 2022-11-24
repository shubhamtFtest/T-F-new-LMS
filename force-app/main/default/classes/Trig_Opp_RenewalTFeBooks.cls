//Trigger Class: Trig_Opp_RenewalTFeBooks.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Jeff Lup - 2017.04.10 - CHG0033459
//Modified by Bharat - 2017.12.21 - CHG0039924
//Modified by Ashish Purwar - 2018.03.21 - CHG0042747
//Modified by Shefali - 2018.09.14 - line 58 (new checkbox filter added)
//Modified by Matthew Smith - 2020.05.04 - 01476512 - Updating the emails which are sent to Samantha, as she's going on maternity leave. So sending customer responses to shared CSD inbox.
//Modified by Matthew Smith - 2021.05.07 - 01891636 - Updating the email sent to CSD to include account address information. 

public without sharing class Trig_Opp_RenewalTFeBooks implements TriggerInterface_Opp.Runnable {
    public void run(TriggerInterface_Opp.Trig trig) {
        // CHG0039924 custom setting to get the User Id
        BatchOppRenewal__c batsetting=BatchOppRenewal__c.getValues('UserID');
        string userId='';
        if(batsetting !=null){
            userId=batsetting.UserId__c;
        }
       
        if (trig.isBefore && trig.isInsert) {
            //mark Don't Send if the following apply (but don't unmark if it's already marked)
            //this same code exists in the Update section below
            for (Integer i=0; i < trig.triggerSize; i++) {
                if (trig.newList[i].Order_Type__c == 'One-Time Purchase' || trig.newList[i].Order_Type__c == 'Maintenance' || trig.newList[i].Renewal_Method__c == 'Agent' || trig.newList[i].Renewal_Method__c == 'Consortium/Network' || trig.newList[i].Previous_Renewal__c == null)
                    trig.newList[i].Don_t_Send__c = true;
            }
        }
        if (trig.isBefore && trig.isUpdate) {
            TF_ERN_Settings__c setting = TF_ERN_Settings__c.getOrgDefaults();
            Id orgWideEmailAddressId = setting.Org_Wide_Email_Address_Id__c; //the sender of the email
            Id salesRepId = setting.Sales_Rep_Id__c; //only send email for opps owned by this user
            String csEmail = setting.Customer_Service_Email__c; //Customer Service (sometimes TO, sometimes CC)
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm().replace('http:','https:');
            Id tfTaskRecordtype = '0120Y000000WnAeQAK'; //T&F - Tasks
         string productList='';

            Set<Id> oppIdsToRenew = new Set<Id>();
            List<Opportunity> oppsToRenew = new List<Opportunity>();
            Map<Id,Opportunity> mapOppsToSend_RenewalRequest = new Map<Id,Opportunity>();
            Map<Id,Opportunity> mapOppsToSend_RenewalReply_Yes = new Map<Id,Opportunity>();
            Map<Id,Opportunity> mapOppsToSend_RenewalReply_No = new Map<Id,Opportunity>();
            Map<Id,Opportunity> mapOppsToSend_ClosedLost = new Map<Id,Opportunity>();
            Map<Id,Opportunity> mapOppsToSend_ClosedWon = new Map<Id,Opportunity>();
         
          

            for (Integer i=0; i < trig.triggerSize; i++) {
                //Mark Don't Send if the following apply (but don't unmark it if it's already marked)
                if (trig.newList[i].Order_Type__c == 'Maintenance' || trig.newList[i].Order_Type__c == 'One-Time Purchase' || trig.newList[i].Renewal_Method__c == 'Agent' || trig.newList[i].Renewal_Method__c == 'Consortium/Network' || trig.newList[i].Previous_Renewal__c == null)
                    trig.newList[i].Don_t_Send__c = true;
    
                //Add to Renewal list                           
                if (trig.newList[i].Type == 'Renewal' && trig.newList[i].Order_Type__c != 'Gratis' && trig.newList[i].Order_Type__c != 'Trial' && trig.newList[i].StageName == 'Closed Won' && trig.newList[i].StageName != trig.oldList[i].StageName && trig.newList[i].Next_Renewal__c == null) {
                    oppIdsToRenew.add(trig.newList[i].Id);
                    oppsToRenew.add(trig.newList[i]);
                }
    
                //Add to notication lists
                if (trig.newList[i].OwnerId == salesRepId) {
                    if (trig.newList[i].StageName == 'Evaluating' && trig.newList[i].Don_t_Send__c == false && trig.newList[i].Order_Type__c != 'One-Time Purchase' && trig.newList[i].Order_Type__c != 'Maintenance' && trig.newList[i].Renewal_Method__c != 'Agent' && trig.newList[i].Renewal_Method__c != 'Consortium/Network' && trig.newList[i].StageName != trig.oldList[i].StageName && trig.newList[i].Previous_Renewal__c != null)
                        mapOppsToSend_RenewalRequest.put(trig.newList[i].Id, trig.newList[i]); //Send request for Renewal
                    
                    //if (trig.newList[i].StageName == 'Evaluating' && trig.newList[i].Customer_Response__c == 'Renew' && trig.newList[i].Customer_Response__c != trig.oldList[i].Customer_Response__c)
                    if (trig.newList[i].Customer_Response__c == 'Renew' && trig.newList[i].Customer_Response__c != trig.oldList[i].Customer_Response__c)
                        mapOppsToSend_RenewalReply_Yes.put(trig.newList[i].Id, trig.newList[i]); //Customer Renewed
    
                    //if (trig.newList[i].StageName == 'Evaluating' && (trig.newList[i].Customer_Response__c == 'Partially Renew' || trig.newList[i].Customer_Response__c == 'Decline' || trig.newList[i].Customer_Response__c == 'Undecided' || trig.newList[i].Customer_Response__c == 'I Want to Speak to my Sales Rep') && trig.newList[i].Customer_Response__c != trig.oldList[i].Customer_Response__c)
                    if ((trig.newList[i].Customer_Response__c == 'Partially Renew' || trig.newList[i].Customer_Response__c == 'Decline' || trig.newList[i].Customer_Response__c == 'Undecided' || trig.newList[i].Customer_Response__c == 'I Want to Speak to my Sales Rep') && trig.newList[i].Customer_Response__c != trig.oldList[i].Customer_Response__c)
                        mapOppsToSend_RenewalReply_No.put(trig.newList[i].Id, trig.newList[i]); //Customer Did NOT Renew
    
                    if (trig.newList[i].StageName == 'Acceptance' && trig.newList[i].Customer_Response__c != 'Renew' && trig.newList[i].StageName != trig.oldList[i].StageName)
                        mapOppsToSend_RenewalReply_Yes.put(trig.newList[i].Id, trig.newList[i]); //Manually Renewed Customer
    
                    if (trig.newList[i].StageName == 'Closed Lost' && trig.newList[i].StageName != trig.oldList[i].StageName)
                        mapOppsToSend_ClosedLost.put(trig.newList[i].Id, trig.newList[i]); //Closed Lost
    
                    if (trig.newList[i].StageName == 'Closed Won' && trig.newList[i].StageName != trig.oldList[i].StageName)
                        mapOppsToSend_ClosedWon.put(trig.newList[i].Id, trig.newList[i]); //Closed Won
                }
            }
            //********** Renew opps (if applicable) **********
            if (oppIdsToRenew.size() > 0) {
                //OppRenewalTFeBooks.renewOpps(oppIdsToRenew);
                OppRenewalTFeBooks.renewOpps(oppIdsToRenew, oppsToRenew);
                system.debug('LUP: oppsToRenew[0].Next_Renewal__c = ' + oppsToRenew[0].Next_Renewal__c);
            }    
    
            //Get Data needed for emails
            Map<Id, List<OpportunityLineItem>> mapOppIdToOlis = new Map<Id, List<OpportunityLineItem>>();
            Map<Id, OpportunityContactRole> mapOppIdToOcrPrimary = new Map<Id, OpportunityContactRole>();
            Map<Id, List<OpportunityContactRole>> mapOppIdToOcrs = new Map<Id, List<OpportunityContactRole>>();
            Map<Id, Opportunity> mapOpps;
            if (mapOppsToSend_RenewalRequest.size() > 0 || mapOppsToSend_RenewalReply_Yes.size() > 0) {
                //Get OLI/Product Information
                List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, Product2.Name, TotalPrice, CurrencyIsoCode, Previous_Invoice__c, Previous_Sales_Price__c,
                                                    Product2.Current_Year__c, Product2.Current_Year_Number_of_Titles__c, Product2.Current_Year_Value_of_Titles__c,
                                                    Product2.Next_Year__c, Product2.Next_Year_Number_of_Titles__c, Product2.Next_Year_Value_of_Titles__c,
                          Description //@@ Avi
                                                  FROM OpportunityLineItem
                                                  WHERE OpportunityId IN :mapOppsToSend_RenewalRequest.keySet()
                                                    OR OpportunityId IN :mapOppsToSend_RenewalReply_Yes.keySet()];
                for (OpportunityLineItem oli : olis) {
                    List<OpportunityLineItem> olisThisOpp = new List<OpportunityLineItem>();
                    if (mapOppIdToOlis.containsKey(oli.OpportunityId))
                        olisThisOpp = mapOppIdToOlis.get(oli.OpportunityId);
                    olisThisOpp.add(oli);
                    mapOppIdToOlis.put(oli.OpportunityId, olisThisOpp);
                }
                //Get OCR Information
                List<OpportunityContactRole> ocrs = [SELECT Id, IsPrimary, OpportunityId, Contact.Id, Contact.Name, Contact.Email,
                                                        Contact.MailingStreet, Contact.MailingCity, Contact.Mailing_State_List__c,
                                                        Contact.MailingPostalCode, Contact.Mailing_Country_List__c
                            ,Contact.Account.Name //@@CHG0031935
                                                     FROM OpportunityContactRole
                                                     WHERE (OpportunityId IN :mapOppsToSend_RenewalRequest.keySet()
                                                            OR OpportunityId IN :mapOppsToSend_RenewalReply_Yes.keySet())
                                                        AND Contact.Account.Type NOT IN ('Agent','Consortium')];
                for (OpportunityContactRole ocr : ocrs) {
                    List<OpportunityContactRole> ocrsThisOpp = new List<OpportunityContactRole>();
                    if (mapOppIdToOcrs.containsKey(ocr.OpportunityId))
                        ocrsThisOpp = mapOppIdToOcrs.get(ocr.OpportunityId);
                    ocrsThisOpp.add(ocr);
                    mapOppIdToOcrs.put(ocr.OpportunityId, ocrsThisOpp);
                    if (ocr.IsPrimary)
                        mapOppIdToOcrPrimary.put(ocr.OpportunityId, ocr);
                }
            }
            //Get Additional Opportunity Data (such as Account and Owner.Email)
            mapOpps = new Map<Id, Opportunity>([SELECT Id, Account.Name, Owner.Email, Previous_Renewal__r.End_Date__c, Account.BillingStreet, Account.BillingCity,
                                                Account.Mailing_State_List__c, Account.BillingPostalCode, Account.Mailing_Country_List__c
                                                FROM Opportunity
                                                WHERE Id IN :mapOppsToSend_RenewalRequest.keySet()
                                                   OR Id IN :mapOppsToSend_RenewalReply_Yes.keySet()
                                                   OR Id IN :mapOppsToSend_RenewalReply_No.keySet()
                                                   OR Id IN :mapOppsToSend_ClosedLost.keySet()
                                                   OR Id IN :mapOppsToSend_ClosedWon.keySet()]);
            
            //Get Prev Opp Owner's Email
            Set<Id> oppIds = new Set<Id>();
            oppIds.addAll(mapOppsToSend_RenewalReply_Yes.keySet());
            oppIds.addAll(mapOppsToSend_RenewalReply_No.keySet());
            oppIds.addAll(mapOppsToSend_ClosedWon.keySet());
            Map<Id, String> mapOppIdToPrevOwnerEmail = new Map<Id, String>();
            if (oppIds.size() > 0) {
                List<Opportunity> opps = [SELECT Id, Previous_Renewal__r.Owner.Email FROM Opportunity WHERE Id IN :oppIds];
                for (Opportunity opp : opps) {
                    if (opp.Previous_Renewal__c != null)
                        mapOppIdToPrevOwnerEmail.put(opp.Id, opp.Previous_Renewal__r.Owner.Email);
                }
            }
            
            //********** Send emails (if applicable) **********
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            List<Attachment> oppAttachments = new List<Attachment>();
            List<Task> oppTasks = new List<Task>();
            //Renewal Requests
            if (mapOppsToSend_RenewalRequest.size() > 0) {
                //Check for missing records
                Boolean missingData = false;
                for (Integer i=0; i < trig.triggerSize; i++) {
                    if (mapOppsToSend_RenewalRequest.containsKey(trig.newList[i].Id)) {
                        //if (!mapOppIdToOcrs.containsKey(trig.newList[i].Id)) { //don't need to surface error, just don't send
                        //    missingData = true;
                        //    trig.newList[i].addError('Missing Primary Contact.  No emails were sent.');
                        //if (!mapOppIdToOcrs.containsKey(trig.newList[i].Id)) {
                        if (!mapOppIdToOcrs.containsKey(trig.newList[i].Id)) { ////CHG0033459
                            missingData = true;
                        } else if (mapOppIdToOcrs.containsKey(trig.newList[i].Id)) { //CHG0033459
                            Boolean hasEmail = false;                           
                            for (OpportunityContactRole ocr : mapOppIdToOcrs.get(trig.newList[i].Id)) {
                                if (ocr.Contact.Email != null)
                                    hasEmail = true;
                            }
                            if (!hasEmail) {
                                missingData = true;
                                trig.newList[i].addError('All Contacts Missing Email Address.  No emails were sent.');
                            }
                        //if (mapOppIdToOcr.get(trig.newList[i].Id).Contact.Email == null) {
                        //    missingData = true;
                        //    trig.newList[i].addError('Primary Contact Missing Email Address.  No emails were sent.');
                        } else if (!mapOppIdToOlis.containsKey(trig.newList[i].Id)) {
                            missingData = true;
                            trig.newList[i].addError('Missing Products.  No emails were sent.');
                        } else if (trig.newList[i].Amount_USD__c == null || trig.newList[i].Amount_USD__c == 0) {
                            missingData = true;
                            trig.newList[i].addError('The Opportunity has no Amount.  No emails were sent.');
                        } 
                    }
                }
                if (!missingData) {
                    //Construct Emails      
                    for (Opportunity opp : mapOppsToSend_RenewalRequest.values()) {
                        //Construct Email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        //email.setWhatId(opp.Id); //for Opp's activity related list
                        //email.setTargetObjectId(mapOppIdToOcr.get(opp.Id).Contact.Id); //for Contact's activity related list
                        OpportunityContactRole ocrTo = new OpportunityContactRole();
                        Set<String> toAddresses = new Set<String>();
                        List<OpportunityContactRole> ocrs = mapOppIdToOcrs.get(opp.Id);
                        for (OpportunityContactRole ocr : ocrs) {
                            if (ocr.IsPrimary && ocr.Contact.Email != null) {
                                toAddresses.add(ocr.Contact.Email);
                                ocrTo = ocr;
                                break;
                            }
                        }
                        if (toAddresses.size() == 0) {
                            for (OpportunityContactRole ocr : ocrs) {
                                if (ocr.Contact.Email != null) {
                                    toAddresses.add(ocr.Contact.Email);
                                    ocrTo = ocr;
                                    break;
                                }
                            }
                        }
                        List<String> listToAddresses = new List<String>();
                        listToAddresses.addAll(toAddresses);

                        if (MiscFunctions.isProduction())
                            email.setToAddresses(listToAddresses);                          
                        else
                            email.setToAddresses(new String[] {UserInfo.getUserEmail()}); //so customers don't get emails from a sandbox
                            //email.setToAddresses(new String[] {'jeff.lup@informausa.com'}); //so customers don't get emails from a sandbox
                        Set<String> ccAddresses = new Set<String>();    
                        //if not in To, add to Cc                       
                        if (MiscFunctions.isProduction()) {
                            ocrs = mapOppIdToOcrs.get(opp.Id);
                            for (OpportunityContactRole ocr : ocrs) {
                                if (ocr.Contact.Email != null && !toAddresses.contains(ocr.Contact.Email))
                                    ccAddresses.add(ocr.Contact.Email);
                            }
                        }
                        if (ccAddresses.size() > 0) {
                            List<String> listCcAddresses = new List<String>();
                            listCcAddresses.addAll(ccAddresses);
                            email.setCCAddresses(listCcAddresses);
                        }
                        email.setOrgWideEmailAddressId(orgWideEmailAddressId);
                        email.setReplyTo(mapOpps.get(opp.Id).Owner.Email);
                     //   email.setSubject('Renewal Notification');
                          // CHG0039924 Add all the product list with subject of Email
                        if(opp.OwnerId==userId){
                           system.debug('oppId'+opp.Id );  
                            for (OpportunityLineItem oli :  [ SELECT Id, OpportunityId, Product2.Name FROM OpportunityLineItem  WHERE OpportunityId = :opp.Id  ]) {
                                if(productList =='')
                                    productList=oli.Product2.Name;
                                else
                                    productList=  productList+','+oli.Product2.Name;
                            }  
                        }
                        system.debug('productList'+productList);

                        if(opp.OwnerId==userId){
                            system.debug('opp.OwnerId'+opp.OwnerId);
                            email.setSubject('Renewal Notification -'+productList);  
                        }else{
                            system.debug('opp.OwnerIdnext'+opp.OwnerId);
                            email.setSubject('Renewal Notification');
                        }
                          system.debug(opp.OwnerId);
//                        email.setSubject('Renewal Notification -'+productList);  
                        //add a reference to previous renewal end date
                        if (opp.Previous_Renewal__r == null) 
                        {
                            opp.Previous_Renewal__r = new Opportunity();
                        }

                        opp.Previous_Renewal__r.End_Date__c = mapOpps.get(opp.Id).Previous_Renewal__r.End_Date__c;
                        //**** Set Body using OppRenewalPrompt_TFeBooks_Email.cls
                         system.debug(opp.OwnerId);
                        String body = OppRenewalPrompt_TFeBooks_Email.getEmail(opp, mapOppIdToOlis.get(opp.Id), ocrTo);
                         system.debug(opp.OwnerId);
                        email.setHtmlBody(body);
                        emails.add(email);
                        //Set Date Sent
                        opp.Date_Sent__c = system.now();
                        //Add to Opp's Attachments Related List
                        Attachment oppAttachment = new Attachment();
                        oppAttachment.ParentId = opp.Id;
                        oppAttachment.Name = 'RenewalNotification.html';
                        oppAttachment.Body = Blob.valueOf(body);
                        oppAttachment.Description = 'Renewal Notification Email Sent to the Primary Contact';
                        oppAttachments.add(oppAttachment);
                        //Add a Task
                        Task t = new Task();
                        t.Subject = 'Request for Renewal';
                        t.Status = 'Completed';
                        t.WhatId = opp.Id;
                        t.Description = body.stripHtmlTags();
                        t.RecordtypeId = tfTaskRecordtype;
                        oppTasks.add(t);
                        system.debug(opp.OwnerId);
                    }
                }
            }
            //Replies of "Renew", or when a opp is moved to "Acceptance"
            for (Opportunity opp : mapOppsToSend_RenewalReply_Yes.values()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setToAddresses(new String[] {csEmail}); @@CHG0042747                
                email.setToAddresses(new String[] {'ebooksetup@taylorfrancis.com'});// @@CHG0042747
                List<String> ccAddresses = new List<String>();
                
                /* Commentating this section out, as Samantha is on maternity leave
                ccAddresses.add(mapOpps.get(opp.Id).Owner.Email);
                if (mapOppIdToPrevOwnerEmail.containsKey(opp.Id))
                    ccAddresses.add(mapOppIdToPrevOwnerEmail.get(opp.Id));  // @@CHG0075516
                // ccAddresses.add('Elizabeth.Jimenez@taylorandfrancis.com');  // @@CHG0075516 //CHG0041597
                email.setCCAddresses(ccAddresses);
               */
            //    email.setSubject('Opportunity Accepted');
                String emailBody = '<html><body>'
                                    + 'The customer has decided to "Renew", so the renewal below has been moved to a stage of "Acceptance"<br/><br/>'
                                    + 'Please perform billing and setup for...<br/><br/>';
                //Account
                emailBody += '<u>Account</u><br/>';
                Account acc = mapOpps.get(opp.Id).Account;
                //emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + mapOpps.get(opp.Id).Account.Name + '<br/>';
                emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + acc.Name + '<br/>';
                if (acc.BillingStreet != null)
                	emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + acc.BillingStreet + '<br/>';
                if (acc.BillingCity != null)
                    emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + acc.BillingCity + ', ';
                if (acc.BillingPostalCode != null)
                    emailBody += ' ' + acc.BillingPostalCode;
                if (acc.Mailing_State_List__c != null)
                    emailBody += ' ' + acc.Mailing_State_List__c;
                if (acc.Mailing_Country_List__c != null)    
                 	emailBody += ' ' + acc.Mailing_Country_List__c + '<br/>' + '<br/>';
                //Contact
                if (mapOppIdToOcrPrimary.containsKey(opp.Id)) {
                    Contact c = mapOppIdToOcrPrimary.get(opp.Id).Contact;
                    emailBody += '<u>Contact</u><br/>';
                    emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + c.Name + '<br/>';
                    if (c.Email != null)
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + c.Email + '<br/>';
                    if (c.MailingStreet != null) {
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + c.MailingStreet + '<br/>';
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + c.MailingCity + ', ' + c.Mailing_State_List__c + ' ' + c.MailingPostalCode + ' ' + c.Mailing_Country_List__c + '<br/>';
                    }
                    emailBody += '<br/>';
                }
                //Opportunity
                emailBody += '<u>Opportunity</u><br/>';
                emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + opp.Name + ': <br/>';
                emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;' + '<a href="' + baseURL + '/' + opp.Id + '">' + baseURL + '/' + opp.Id + '</a><br/>';
                emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Start Date: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Start_Date__c) + '<br/>';
                emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;End Date: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.End_Date__c) + '<br/>';
                //OpportunityLineItems
               
                if (mapOppIdToOlis.containsKey(opp.Id)) {
                    
                    emailBody += '<br/><u>Products</u><br/>';
                    List<OpportunityLineItem> olis = mapOppIdToOlis.get(opp.Id);
                    for (OpportunityLineItem oli : olis) {
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Id: ' + oli.Id + '<br/>';
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Name: ' + oli.Product2.Name + '<br/>';
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Price: (' + oli.CurrencyIsoCode + ') ' + MiscFunctions.formattedAmount(oli.TotalPrice) + '<br/>';
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Prev Inv#: ' + (oli.Previous_Invoice__c != null ? oli.Previous_Invoice__c : '') + '<br/><br/>';
                        emailBody += '&nbsp;&nbsp;&nbsp;&nbsp;Line Description: ' + (oli.Description != null ? oli.Description : '') + '<br/><br/>'; //@@Avi
                        if(opp.OwnerId==userId){
                            if(productList =='')
                                productList=oli.Product2.Name;
                            else
                                productList=  productList+','+oli.Product2.Name;
                        }
                    }
                }
                emailBody += '</body></html>';
                if(opp.OwnerId==userId){
                      email.setSubject('Renewal Opportunity Accepted - '+productList);
                }else{
                      email.setSubject('Renewal Opportunity Accepted');
                }
               // email.setSubject('Renewal Opportunity Accepted - '+productList);
                //system.debug('Renewal Opportunity Accepted -'+productList);
                email.setHtmlBody(emailBody);
                emails.add(email); 
                //Add to Opp's Attachments Related List
                Attachment oppAttachment = new Attachment();
                oppAttachment.ParentId = opp.Id;
                oppAttachment.Name = 'OpportunityAccepted.html';
                oppAttachment.Body = Blob.valueOf(emailBody);
                oppAttachment.Description = 'Opportunity Accepted Email Sent to the Customer Service';
                oppAttachments.add(oppAttachment);
                //Add a Task, so the user can Close Won without validation
                Task t = new Task();
                t.Subject = 'Customer Accepted';
                t.Status = 'Completed';
                t.WhatId = opp.Id;
                t.Description = emailBody.stripHtmlTags();
                t.RecordtypeId = tfTaskRecordtype;
                oppTasks.add(t);
                //move to "Acceptance"
                opp.StageName = 'Acceptance';
            } // End Acceptance
      
            //Replies of "Partially Renew', "Decline", "Undecided", or "I Want to Speak to my Sales Rep"
            for (Opportunity opp : mapOppsToSend_RenewalReply_No.values()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {mapOpps.get(opp.Id).Owner.Email});
                
                List<String> ccAddresses = new List<String>();
                //ccAddresses.add('andrew.ciccone@taylorandfrancis.com');  //CHG0075516
                
                if (mapOppIdToPrevOwnerEmail.containsKey(opp.Id))
                    ccAddresses.add(mapOppIdToPrevOwnerEmail.get(opp.Id));
                email.setCCAddresses(ccAddresses);
				
                email.setSubject('Opportunity Not Accepted (' + opp.Customer_Response__c + ')');
                String emailBody = '<html><body>'
                                + 'When asked to renew, the customer replied with "' + opp.Customer_Response__c + '".<br/><br/>'
                                + opp.Name + ': <br/>'
                                + '<a href="' + baseURL + '/' + opp.Id + '">' + baseURL + '/' + opp.Id + '</a>'
                                + '</body></html>';
                email.setHtmlBody(emailBody);
                //emails.add(email); //commentating this line, as we don't need to send emails to Samantha as she's on maternity leave
                //Add to Opp's Attachments Related List
                Attachment oppAttachment = new Attachment();
                oppAttachment.ParentId = opp.Id;
                oppAttachment.Name = 'OpportunityNotAccepted.html';
                oppAttachment.Body = Blob.valueOf(emailBody);
                oppAttachment.Description = 'Opportunity Not Accepted Email Sent to the Opportunity Owner';
                oppAttachments.add(oppAttachment);
                //Add a Task
                Task t = new Task();
                t.Subject = 'Opportunity Not Accepted';
                t.Status = 'Completed';
                t.WhatId = opp.Id;
                t.Description = emailBody.stripHtmlTags();
                t.RecordtypeId = tfTaskRecordtype;
                oppTasks.add(t);
                //move to "Evaluating"
                opp.StageName = 'Evaluating';
            }
            //when an opp is moved to "Closed Lost"
            for (Opportunity opp : mapOppsToSend_ClosedLost.values()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setToAddresses(new String[] {csEmail});@@CHG0042747
                email.setToAddresses(new String [] {'am_renewals@taylorandfrancis.com'});
                //email.setToAddresses(new String[] {'samantha.given@taylorandfrancis.com'});//@@CHG0042747 commenting out this line as Samantha is going on maternity leave
                List<String> ccAddresses = new List<String>();
                //ccAddresses.add('andrew.ciccone@taylorandfrancis.com');  //CHG0075516
                //ccAddresses.add(mapOpps.get(opp.Id).Owner.Email);@@CHG0042747
                //email.setCCAddresses(ccAddresses);@@CHG0042747
                email.setSubject('Terminate Access');
                String emailBody = '<html><body>'
                                + 'This opportunity has been moved to a stage of "Closed Lost".  Please terminate the customer\'s access.<br/><br/>'
                                + opp.Name + ': <br/>'
                                + '<a href="' + baseURL + '/' + opp.Id + '">' + baseURL + '/' + opp.Id + '</a>'
                                + '</body></html>';
                email.setHtmlBody(emailBody);
                emails.add(email);
                //Add to Opp's Attachments Related List
                Attachment oppAttachment = new Attachment();
                oppAttachment.ParentId = opp.Id;
                oppAttachment.Name = 'OpportunityClosedLost.html';
                oppAttachment.Body = Blob.valueOf(emailBody);
                oppAttachment.Description = 'Opportunity Closed Lost Email Sent to Customer Service';
                oppAttachments.add(oppAttachment);
                //Add a Task
                Task t = new Task();
                t.Subject = 'Opportunity Closed Lost';
                t.Status = 'Completed';
                t.WhatId = opp.Id;
                t.Description = emailBody.stripHtmlTags();
                t.RecordtypeId = tfTaskRecordtype;
                oppTasks.add(t);                
            }
            //when an opp is moved to "Closed Won"
            for (Opportunity opp : mapOppsToSend_ClosedWon.values()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setToAddresses(new String[] {mapOpps.get(opp.Id).Owner.Email}); //commentating out this line as Samantha is going on maternity leave.
                email.setToAddresses(new String [] {'am_renewals@taylorandfrancis.com'});
                List<String> ccAddresses = new List<String>();
                //ccAddresses.add('andrew.ciccone@taylorandfrancis.com');  //CHG0075516
                
                /* Commenting out this section as Samantha is on maternity leave 
                if (mapOppIdToPrevOwnerEmail.containsKey(opp.Id))
                    ccAddresses.add(mapOppIdToPrevOwnerEmail.get(opp.Id));
                email.setCCAddresses(ccAddresses);
				*/
                
                email.setSubject('Opportunity Closed Won');
                String emailBody = '<html><body>'
                                + 'This opportunity has been moved to a stage of "Closed Won".<br/><br/>'
                                + opp.Name + ': <br/>'
                                + '<a href="' + baseURL + '/' + opp.Id + '">' + baseURL + '/' + opp.Id + '</a>'
                                + '</body></html>';
                email.setHtmlBody(emailBody);
                emails.add(email);
                //Add to Opp's Attachments Related List
                Attachment oppAttachment = new Attachment();
                oppAttachment.ParentId = opp.Id;
                oppAttachment.Name = 'OpportunityClosedWon.html';
                oppAttachment.Body = Blob.valueOf(emailBody);
                oppAttachment.Description = 'Opportunity Closed Won Email Sent to Opportunity Owner';
                oppAttachments.add(oppAttachment);
                //Add a Task
                Task t = new Task();
                t.Subject = 'Opportunity Closed Won';
                t.Status = 'Completed';
                t.WhatId = opp.Id;
                t.Description = emailBody.stripHtmlTags();
                t.RecordtypeId = tfTaskRecordtype;
                oppTasks.add(t);
            }
            //Send all Emails
            if (emails.size() > 0 && !test.isRunningTest())
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
            //Insert all attachments
            if (oppAttachments.size() > 0)
                insert oppAttachments;
            //Insert all tasks
            if (oppTasks.size() > 0)
                insert oppTasks;
        }
    }
}