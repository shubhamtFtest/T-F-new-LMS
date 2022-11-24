/************************************************************************** 
** create schedule Apex - Job Name: CAS_OpportuntityAutoCloseSchedule
** Created/Modified by Shay Spoonmore - 2012-03-20
** Modified by Jeff Lup - 2017.04.28 - CHG0033156
***************************************************************************/
global class CAS_OpportuntityAutoCloseBatch implements Database.Batchable<Sobject>{
    public Boolean isTesting; //used for test methods
    Public Integer queryLimit;
    Private String query;
    
    global database.querylocator start(Database.BatchableContext BC) {
        System.debug('DEBUG: Start CAS_OpportuntityAutoCloseBatch'); 
        String oppDoNotProcessStringIds= '';
        String dupId = '';
         
        query = 'SELECT Adoption_Stage__c, Id, OpportunityId, Opportunity.Course_Start_Date__c, Opportunity.IsClosed, Opportunity.StageName ' +
                'FROM OpportunityLineItem ' +
                'WHERE (Opportunity.Course_Start_Date__c < LAST_N_DAYS:120 ' +
                '  AND Opportunity.RecordType.Name = \'T&F - CAS Opportunity\' ' +
                '  AND Opportunity.IsClosed = false) ' + 
                'ORDER BY OpportunityId ASC, Opportunity.Course_Start_Date__c ASC ';
        if (isTesting)
           queryLimit = 500; 
        
        if (queryLimit != null && queryLimit != 0)
            query = query + ' LIMIT ' + queryLimit;
        
        System.debug('DEBUG:CAS_OpportuntityAutoCloseBatch soql=' + query); 
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Opportunity> opportunityUpdate = new List<Opportunity>();
        Set<Id> oppLineItemsIds = new Set<Id>();
        Set<Id> oppStage = new Set<Id>();
        Set<Id> oppLineItemEmail = new Set<Id>();
        Integer HowManyDays = 2;
        
        //Opps to mark Closed Won - Adoption Confirmed
        for(sObject s : scope) {
            OpportunityLineItem oppLineItem = (OpportunityLineItem) s;
            oppLineItemsIds.add(oppLineItem.Id);
            
            if (oppLineItem.Adoption_Stage__c == 'Completed - Order Confirmed'
              || oppLineItem.Adoption_Stage__c == 'Completed - Adopted'
              || oppLineItem.Adoption_Stage__c == 'Completed - Purchased'
              || oppLineItem.Adoption_Stage__c == 'Completed - Library Purchase and Adopted')
            {
                oppStage.add(oppLineItem.OpportunityId);
            }
        }
        for(Id closed: oppStage) {
            Opportunity oppClosed = new Opportunity(Id = closed, StageName = 'Closed Won');
            System.debug('@@@'+oppClosed);
            opportunityUpdate.add(oppClosed);
        }
        if (opportunityUpdate.size() > 0 )
            system.debug('*********'+opportunityUpdate);
            Database.update(opportunityUpdate, false);
        
        //Now set the rest of the Opportunities as 'Closed Lost'
        LIST<OpportunityLineItem> oppProductCompleted = new LIST<OpportunityLineItem>();
        
        OpportunityLineItem[] oppLineItems = [SELECT o.Opportunity.StageName, o.Adoption_Stage__c, o.Id, o.OpportunityId, o.CreatedDate
                                              FROM OpportunityLineItem o
                                              WHERE o.Opportunity.IsClosed=false
                                                AND o.Opportunity.StageName NOT IN ('Closed Won') //not just set to closed won
                                                AND o.Id = :oppLineItemsIds
                                                AND o.OpportunityId != :oppStage
                                              ORDER BY o.OpportunityId ASC, o.Opportunity.Course_Start_Date__c ASC];
        oppStage.clear();
        opportunityUpdate.clear(); 
                
        for (OpportunityLineItem oppLineItem: oppLineItems) {
            if (oppLineItem.Adoption_Stage__c == 'Created'
                || oppLineItem.Adoption_Stage__c == 'In-Process'
                || oppLineItem.Adoption_Stage__c == 'Open - Under Consideration'
                || oppLineItem.Adoption_Stage__c == 'Committee Review')
            {
                OpportunityLineItem oppProductComplete = new OpportunityLineItem(Id= oppLineItem.Id, Adoption_Stage__c = 'Completed - No Response');
                oppProductCompleted.add(oppProductComplete);
            }
            if (oppLineItem.Opportunity.StageName != 'Closed Lost')
                oppStage.add(oppLineItem.OpportunityId);
        }
        //Update OLIs
        if (oppProductCompleted.size() > 0)
            Database.update(oppProductCompleted, false);

        //Update Opps to Closed Lost
        for(Id closed: oppStage) {
            Opportunity oppClosed = new Opportunity(Id = closed,StageName = 'Closed Lost');
            opportunityUpdate.add(oppClosed);
        }
        if (opportunityUpdate.size() > 0)
            Database.update(opportunityUpdate, false);
    }

    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                        TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
            // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 || isTesting) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email, 'Shay.Spoonmore@informaUSA.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('CAS OpportuntityAutoCloseBatch ' + a.Status);
            mail.setPlainTextBody
                (BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    /*

    global database.querylocator start(Database.BatchableContext BC)  
    {
        System.debug('DEBUG: Start CAS_OpportuntityAutoCloseBatch'); 
        String oppDoNotProcessStringIds= '';
        String dupId = '';

        List<OpportunityLineItem> oppDoNotProcessIds = [SELECT OpportunityId FROM OpportunityLineItem where (Opportunity.IsClosed=false and (Opportunity.StageName not in ( 'Closed Won') and Opportunity.Course_Start_Date__c < LAST_N_DAYS:120 and Opportunity.RecordType.Name like 'CAS%' )) and Adoption_Stage__c in ('Open - Under Consideration','Committee Review')];// order by OpportunityId
        
        oppDoNotProcessIds.sort();
        for(OpportunityLineItem  oli : oppDoNotProcessIds )// build opportunities not to be included in query
        {
            String oppId = oli.OpportunityId; 
            if (dupId != oppId)//dedupe
            {
            oppDoNotProcessStringIds += '\'' + oli.OpportunityId + '\',';
            }
            
            dupId = oli.OpportunityId;
        }
        
        if (oppDoNotProcessStringIds != '')// Make sure string is not blank and build soql to be included in the query 
        {
            Integer commaTakeOff = oppDoNotProcessStringIds.length() - 1;
            oppDoNotProcessStringIds = ' and OpportunityId Not In (' + oppDoNotProcessStringIds.substring(0,commaTakeOff ) + ')';
        } 
        System.debug('DEBUG:CAS_OpportuntityAutoCloseBatch oppDoNotProcessStringIds=' + oppDoNotProcessStringIds);
        
         
        query = 'Select Adoption_Stage__c, Id, OpportunityId, Opportunity.Course_Start_Date__c, Opportunity.IsClosed, Opportunity.StageName from OpportunityLineItem  where ' + 
                        '(Opportunity.Course_Start_Date__c < LAST_N_DAYS:120 and Opportunity.RecordType.Name like \'CAS%\' and Opportunity.IsClosed=false and Opportunity.StageName not in ( \'Closed Won\')) and ' + 
                        'Adoption_Stage__c not in (null)'+ oppDoNotProcessStringIds + ' order by OpportunityId ASC, Opportunity.Course_Start_Date__c ASC ';
        //\'Open - Under Consideration\', \'Open – Under Consideration\',\'Committee Review\',
        if (isTesting)  
        {queryLimit = 500; } 
        
        if (queryLimit != null && queryLimit != 0)
        {query = query + ' LIMIT ' + queryLimit;}
        
        System.debug('DEBUG:CAS_OpportuntityAutoCloseBatch soql=' + query); 
        
    return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Opportunity> opportunityUpdate = new List<Opportunity>();
        Set<Id> oppLineItemsIds = new Set<Id>();
        Set<Id> oppStage = new Set<Id>();
        Set<Id> oppLineItemEmail = new Set<Id>();
        Integer HowManyDays = 2;
        
        
        
        for(sObject s : scope)
        {
            OpportunityLineItem oppLineItem = (OpportunityLineItem) s;
            oppLineItemsIds.add(oppLineItem.Id);
            
            if (oppLineItem.Adoption_Stage__c == 'Completed - Order Confirmed' ||  oppLineItem.Adoption_Stage__c == 'Completed - Adopted')
            {
                oppStage.add(oppLineItem.OpportunityId);
            }
            //else if (oppLineItem.Adoption_Stage__c == 'Open - Under Consideration' || oppLineItem.Adoption_Stage__c == 'Committee Review')
            //{
            //  
            //}
            
        }
        
        //Close all opps that have one product on the opportunity that have Adoption_Stage__c == 'Completed - Order Confirmed' or 'Completed - Adopted' with 'Closed Won'
        for(Id closed: oppStage)
        {
            Opportunity oppClosed = new Opportunity(Id = closed,StageName = 'Closed Won' );
            opportunityUpdate.add(oppClosed);
        }
        
        if (opportunityUpdate.size() > 0 ) update opportunityUpdate;
        
        //Now set the rest of the Opportunities as 'Closed Lost'
        LIST<OpportunityLineItem> oppProductCompleted = new LIST<OpportunityLineItem>();
        
        OpportunityLineItem[] oppLineItems = [Select o.Opportunity.StageName, o.Adoption_Stage__c, o.Id, o.OpportunityId, o.CreatedDate from OpportunityLineItem o where o.Opportunity.IsClosed=false and o.Opportunity.StageName not in ( 'Closed Won') and (o.Id=:oppLineItemsIds and o.OpportunityId!=: oppStage) order by o.OpportunityId ASC, o.Opportunity.Course_Start_Date__c ASC];
        oppStage.clear();
        opportunityUpdate.clear(); 
        
        
        for (OpportunityLineItem oppLineItem: oppLineItems) 
        {
            System.debug('######DEBUG: Adoption_Stage__c='+ oppLineItem.Adoption_Stage__c +':' + oppLineItem.Id);
            
            System.debug('>>>>>>' + oppLineItem.Id + '<<<<<<<');
                        dateTime dtNow = System.now();
                        dateTime dtCreated = oppLineItem.CreatedDate ;//c.CreatedDate;
                        dtCreated = dtCreated.addDays(HowManyDays);
                        
            
            if (oppLineItem.Adoption_Stage__c == 'In-Process' )//diff dash|| oppLineItem.Adoption_Stage__c == 'In-Process'
            {
                OpportunityLineItem oppProductComplete = new OpportunityLineItem(Id= oppLineItem.Id, Adoption_Stage__c = 'Completed - No Response');
                oppProductCompleted.add(oppProductComplete);
                
                oppStage.add(oppLineItem.OpportunityId);
                
                        if (dtCreated >= dtNow)
                        {
                            System.debug('*****dtNow = ' + dtNow );
                            System.debug('*****oppLineItem.CreatedDate= ' + oppLineItem.CreatedDate );
                            System.debug('*****dtCreatedPlus = ' + dtCreated );
                            System.debug('*****Building Emails to OLI Owners' );
                            oppLineItemEmail.add(oppLineItem.Id);
                            
                        }
                
                //Opportunity oppClosed = new Opportunity(Id = oppLineItem.OpportunityId,StageName = 'Closed Lost');
                //opportunityUpdate.add(oppClosed);
            }
            else if (
                    oppLineItem.Adoption_Stage__c == 'Completed - Library Purchase' ||  
                    oppLineItem.Adoption_Stage__c == 'Completed - Purchased' ||  
                    oppLineItem.Adoption_Stage__c == 'Completed - Not Appropriate' ||  
                    oppLineItem.Adoption_Stage__c == 'Completed - No Response' ||  
                    oppLineItem.Adoption_Stage__c == 'Completed - Returned' ||  
                    oppLineItem.Adoption_Stage__c == 'Never Received Product'   
                    )
            {
                if (oppLineItem.Opportunity.StageName != 'Closed Lost')
                {
                        
                        
                        if (dtCreated >= dtNow)
                        {
                            System.debug('*****dtNow = ' + dtNow );
                            System.debug('*****oppLineItem.CreatedDate= ' + oppLineItem.CreatedDate );
                            System.debug('*****dtCreatedPlus = ' + dtCreated );
                            System.debug('*****Building Emails to OLI Owners' );
                            oppLineItemEmail.add(oppLineItem.Id);
                            
                        }
                    
                    oppStage.add(oppLineItem.OpportunityId);
                    
                
                }
            }
        }
        
        if (oppProductCompleted.size() > 0)
        {
            Update oppProductCompleted;
        }
        
        
        for(Id closed: oppStage)
        {
            Opportunity oppClosed = new Opportunity(Id = closed,StageName = 'Closed Lost');
            opportunityUpdate.add(oppClosed);
        }
         
        
        System.debug('######DEBUG: Closed Lost opportunityUpdate.size()='+ opportunityUpdate.size() );
        if (opportunityUpdate.size() > 0 ) update opportunityUpdate;
        
        
        
        
        SendCASEmail(oppLineItemEmail);//Send Alert emails
        
    }


    public static void SendCASEmail(Set<Id> sendOLIIdOwners )
    {
    
        if (sendOLIIdOwners != null)
       {
            
          if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()))
          { 
            
            List<OpportunityLineItem> sendOLICreated = [Select o.CreatedById, o.CreatedBy.Email, o.CreatedDate, o.OpportunityId, o.Opportunity.Name, o.Order_Type__c, o.PricebookEntryId, o.PricebookEntry.Name, o.PricebookEntry.Product2Id, o.SystemModstamp, o.PricebookEntry.Product2.Author__c, o.PricebookEntry.Product2.Edition_Number__c from OpportunityLineItem o where o.Id =: sendOLIIdOwners ];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (OpportunityLineItem sendBuildEmail: sendOLICreated )
            {
                String[] emailInfo = EmailNotificationMessage(sendBuildEmail);
                String[] toAddresses = new String[]{ sendBuildEmail.CreatedBy.Email};//sendBuildEmail.CreatedBy.Email'Shay.Spoonmore@informausa.com',
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setToAddresses(toAddresses);
                                mail.setSubject(emailInfo[0]);
                                mail.setPlainTextBody(emailInfo[1]);
                                mail.setEmailPriority('High');
                                mail.setSaveAsActivity(false);
                                mail.setBccSender(false);
                                mail.setUseSignature(false);
                               mail.setOrgWideEmailAddressId('');
                mails.add(mail);
            
            }
            
            
            Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(mails, false);
                       
            System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                       
                       
               //loop through email results                
               Integer errorCount = 0;
               String emailMessage = '';
               for(Integer i = 0, j = 0; i < sendEmailResults.size(); i++)
               { 
                    if(!sendEmailResults[i].isSuccess())
                    {       
                         for (Messaging.Sendemailerror sendEmailError : sendEmailResults[i].getErrors()) 
                              {
                                        
                                        System.debug('******Error Message:' + sendEmailError.Message);
                                        
                                        //Build Email Error Message
                                        emailMessage = emailMessage + sendEmailError.Message + '\n\r';
                                        
                                        errorCount++;// keep count of how many records errored
                              }
                     
                     } 
               
               }
               

                        
                        
                if (errorCount > 0 )
                    {
                       //System.debug('##### Error Count:' + errorCount); 
                       //System.debug('##### Update Forum Error Records:' + updateICopyError.size()); 'getEmailInvocations:' + Limits.getEmailInvocations + 
                       String countMessage = 'getEmailInvocations:' + Limits.getEmailInvocations() + '\n\rError Count:' + errorCount ;
                       System.debug('##### ' + countMessage); 
                       
                        
                       CASEmail.SendErrorEmail('Shay.Spoonmore@informaUSA.com','Error - Sending T&F 48hr Opp Close',countMessage + 'Error sending...\n\r' + emailMessage);
                        
                       System.debug('#### Sent Error Message:' + emailMessage);
                      
                        
                    }
            
            
            
          }
       }
    }


    static string[] EmailNotificationMessage(OpportunityLineItem oli)//send after 72 hrs
{
    
    string[] emailInfo = new String[2];
    //datetime createDate = lead.CreatedDate;
    
    emailInfo[0] = oli.Opportunity.Name + ' has been closed out due to an old course start date';
    
    emailInfo[1] = oli.Opportunity.Name + ' has been closed out due to an old course start date. The following Complimentary Exam Copies have been closed out as well:\n\n'
                    + oli.Order_Type__c + ', ' + oli.PricebookEntry.Name + ', ' + oli.PricebookEntry.Product2.Author__c + ', ' + (Integer)oli.PricebookEntry.Product2.Edition_Number__c + '\n\n' 
                    + 'Please update the Stage/Adoption Stage if you feel this was done in error.\n\n' 
                    + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + oli.OpportunityId;
    
    
    

    return emailInfo;
}


    global void finish(Database.BatchableContext BC)
    {
        
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                        TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
            // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 || isTesting)
        {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email, 'Shay.Spoonmore@informaUSA.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('CAS OpportuntityAutoCloseBatch ' + a.Status);
        mail.setPlainTextBody
            (BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        }
    }
    */
}