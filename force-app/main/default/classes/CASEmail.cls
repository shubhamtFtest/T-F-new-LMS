/************************************************************************** 
** CAS Textbook Feedback Email
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com) (CHG0065096) 2015.04.14
** CAS_TextbookFeedbackCreatedEmail/CAS_TextbookFeedbackEmail/CAS_SendNotificationsSchedule
***************************************************************************/

public without sharing class CASEmail 
{
    //OBJECT: CAS_Inspection_Copy__c LABEL: Textbook Feedback
    //workFlow CAS - External Notification 
    //**Rule: Email "In-Process Notification "when record is created and when the record is 21 days old email(Request for Feedback)
    //EmailTemplates: In-Process Notification(00X0Y000000sUhWUAU), Request for Feedback(00X0Y000000sUhwUAE)
    //Total number of sendEmail methods allowed 10
    
    public static Boolean Testing = true; 
    public static boolean hasRunBeforeTrigger = false;
    public static Boolean unitTestingEmailLimits = false;  
     
    
    
    public static void SendCASEmail(CAS_Inspection_Copy__c[] SendInspectionCopy, String templateId,String OrgId)
    {
    
    
    if (!SendInspectionCopy.isEmpty())
       {
            
          if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()))
          {       
          	Integer email1= [Select count() from CAS_Inspection_Copy__c where isDeleted = FALSE  and Sent_Created_Notification__c = Today  limit 7001];
			Integer email2= [Select count() from CAS_Inspection_Copy__c where isDeleted = FALSE  and Sent_Feedback_Notification__c = Today  limit 7001];
			Integer email3= [Select count() from CAS_Inspection_Copy__c where isDeleted = FALSE  and Sent_Feedback_FollowUp__c = Today  limit 7001];
			Integer email4= [Select count() from CAS_Inspection_Copy__c where isDeleted = FALSE  and Sent_Feedback_ShortForm__c = Today   limit 7001];
    
    		Set<Id> sentCreatedNotification = new Set<Id>();
    		Set<Id> sentFeedbackFollowUp = new Set<Id>();
    		Set<Id> sentFeedbackShortForm = new Set<Id>();
    		Set<Id> sentFeedbackNotification = new Set<Id>();
    
    		System.debug('*****Debug email counts email1 = ' + email1 + ' email2='  + email2 + ' email3='  + email3 + ' email4='  + email4 );
    
    		Integer emailTotalSent = email1 + email2 + email3 + email4;
    
		    if (emailTotalSent <= 7000 || templateId == '00X0Y000000sUhWUAU' )//limit how many emails cas sends for daily limits but exclude first email because the first email averges 500-1000
		    {
          	       
                        //Production Organization Id = '00D0Y0000035IjiUAE'
                        If (OrgId == '00D0Y0000035IjiUAE')testing = false; 
                        
                        System.debug('*****SendInspectionCopy.size = ' + SendInspectionCopy.size());
                        Messaging.SingleEmailMessage[] mail = new Messaging.SingleEmailMessage[SendInspectionCopy.size()];
                        List<CAS_Inspection_Copy__c> UpdateInspectionCopy = new CAS_Inspection_Copy__c[SendInspectionCopy.size()];
                        Integer currentRecord= 0;
                        for (CAS_Inspection_Copy__c SendingICI: SendInspectionCopy)
                            {
                                System.debug('*****currentRecord = ' + currentRecord);
                                System.debug('*****SendingICI.Id = ' + SendingICI.Id);
                                
                                //Update a different Field for each Process
                                if (templateId == '00X0Y000000sUhWUAU')
                                {
                                    sentCreatedNotification.add(SendingICI.Id);
                                    //In-Process Notification(00X0Y000000sUhWUAU)
                                    DateTime createNotificationDate = System.now();
                                    if(SendingICI.Future_Feedback_Date__c != null){
                                    	createNotificationDate = SendingICI.Future_Feedback_Date__c;
                                    }
                                    UpdateInspectionCopy[currentRecord] = new CAS_Inspection_Copy__c(Id = SendingICI.Id, Sent_Created_Notification__c = createNotificationDate);
                                    
                                }
                                else if(templateId == '00X0Y000000sUhxUAE')
                                {
                                	sentFeedbackFollowUp.add(SendingICI.Id);
                                    //Request for Feedback follow up(00X0Y000000sUhxUAE)Request_for_Feedback_FollowUp
                                    UpdateInspectionCopy[currentRecord] = new CAS_Inspection_Copy__c(Id = SendingICI.Id, Sent_Feedback_FollowUp__c = System.now());
                                
                                }else if(templateId == '00X0Y000000sUmNUAU')
                                {
                                	sentFeedbackShortForm.add(SendingICI.Id);
                                    //Request for Feedback Short form(00X0Y000000sUmNUAU)Request_for_Feedback_ShortForm
                                    UpdateInspectionCopy[currentRecord] = new CAS_Inspection_Copy__c(Id = SendingICI.Id, Sent_Feedback_ShortForm__c = System.now());
                                
                                }
                                else 
                                { 
                                	sentFeedbackNotification.add(SendingICI.Id);
                                    //Request for Regular Feedback(00X0Y000000sUhwUAE) & Singapore
                                    UpdateInspectionCopy[currentRecord] = new CAS_Inspection_Copy__c(Id = SendingICI.Id, Sent_Feedback_Notification__c = System.now());
                                
                                }
                                 
                                //**
                                mail[currentRecord] = new Messaging.SingleEmailMessage();
                                String[] toAddresses;
                                
                                //Check if code is firing in a Dev environment
                                //Production Organization Id = '00D0Y0000035IjiUAE'
                                if (Testing)
                                {
                                    //toAddresses = new String[] {'Shay.Spoonmore@informaUSA.com'};
                                    toAddresses = new String[] {'nitish.dharm@mindtree.com'};
                                    //errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                                }
                                else
                                {
                                    toAddresses = new String[] {SendingICI.Contact_Email__c}; //, 'Shay.Spoonmore@informaUSA.com' ,'SASInforma@gmail.com', 'Haley.McCarthy@informausa.com'
                                }
                                mail[currentRecord].setToAddresses(toAddresses);
                                mail[currentRecord].setTemplateId(templateId);
                                //The Target object is a Contact and will not work with out one
                                //A Contact setup with the do_not_reply_textbookfeedback@taylorandfrancis.com email is the only way to make this work
                                //mail[currentRecord].setTargetObjectId('');//
                                mail[currentRecord].setTargetObjectId('0030Y000013XuyNQAS');//
                                mail[currentRecord].setwhatId(SendingICI.Id);
                                mail[currentRecord].setSaveAsActivity(false);
                                mail[currentRecord].setBccSender(false);
                                mail[currentRecord].setUseSignature(false);
                                //CHANGE THE ORG WIDE EMAIL WITH PRODUCTION!!!
                                mail[currentRecord].setOrgWideEmailAddressId('0D20Y000000L2FpSAK');
                                //**/
                                    
                                currentRecord = currentRecord + 1;
                            }
                            
                             //= NEW Messaging.SendEmailResult();
                        Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(mail, false);
                        System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                        
                        if (UpdateInspectionCopy != null) 
                        {
                            update UpdateInspectionCopy;//update the date
                            System.debug('******Update Record Sent:' + sendEmailResults.size()); 
                        }
                                
                        
                        System.debug('******How Many InspectionCopy updated? ' + UpdateInspectionCopy.size()); 
                        
                        List<CAS_Inspection_Copy__c> updateICopyError = new CAS_Inspection_Copy__c[]{};
                        
                        
               //loop through email results and update only successful related Inspection Copy
               Integer errorCount = 0;
               String emailMessage = '';
               for(Integer i = 0, j = 0; i < sendEmailResults.size(); i++)
               { 
                    if(sendEmailResults[i].isSuccess())
                    { 
                    	 CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c = null, Sent_Email_Failure__c=false, Sent_Email_Date__c=System.now());
                         updateICopyError.add(updateICopyErrorRecord);
                    }
                    	else
                    {      
                         for (Messaging.Sendemailerror sendEmailError : sendEmailResults[i].getErrors()) 
                              {
                                        
                                        System.debug('******Error Message:' + sendEmailError.Message);
                                        
                                        String errorFields = '';
                                        for(String field :sendEmailError.getFields())
              								 { 
              								 	errorFields = errorFields + field + '; ';
              								 }
                                        
                                        String errorMessage = 'Message=' + sendEmailError.getMessage() + '::StatusCode=' + sendEmailError.getStatusCode()  + '::TargetObjectId=' +  sendEmailError.getTargetObjectId() + '::errorFields=' + errorFields + '::EmailTotalcount='+ emailTotalSent;
                                        
                                      
    		
	    		if (sentCreatedNotification.contains(UpdateInspectionCopy[i].Id))
	    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c = 'Send Created Notification:: ' + errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_Created_Notification__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
	    		}                     
	            else if (sentFeedbackFollowUp.contains(UpdateInspectionCopy[i].Id))
	    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c = 'Send Feedback FollowUp:: ' +errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_Feedback_FollowUp__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
	    		}
	    		else if (sentFeedbackShortForm.contains(UpdateInspectionCopy[i].Id))
	    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c = 'Send Feedback ShortForm:: ' + errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_Feedback_ShortForm__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
	    		}
	            else if (sentFeedbackNotification.contains(UpdateInspectionCopy[i].Id))
	    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c ='Send Feedback Notification:: ' +  errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_Feedback_Notification__c  = null);
                                        updateICopyError.add(updateICopyErrorRecord);
	    		} 
	    		else
	    		{
    									CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c ='NA:: ' +  errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now());
                                        updateICopyError.add(updateICopyErrorRecord);
    			} 	                   
                                        
                                        
                                        
                                        
                                        
                                        
                                        //Build Email Error Message
                                        emailMessage = emailMessage + UpdateInspectionCopy[i].Id + '::' + errorMessage + '\n\r';
                                        
                                        errorCount++;// keep count of how many records errored
                              }
                     
                     }  
               
               }
               
 
                        
                        
                if (updateICopyError != null)
                    {
                       //System.debug('##### Error Count:' + errorCount); 
                       //System.debug('##### Update IC Error Records:' + updateICopyError.size()); 'getEmailInvocations:' + Limits.getEmailInvocations + 
                       String countMessage = 'getEmailInvocations:' + Limits.getEmailInvocations() + '\n\rError Count:' + errorCount + '\n\rUpdate IC Error Records:' + updateICopyError.size()+ '\n\r';
                       System.debug('##### ' + countMessage); 
                       try
                       {
                        if(updateICopyError.size() != 0)
                        {
                            update(updateICopyError);//update the date
                        }
                       }
                       catch(Exception e)
                       {
                        emailMessage = emailMessage + '\n\r' + e;
                       }
                       finally
                       {
                        
                       if (emailMessage != '') CASEmail.SendErrorEmail('Do_Not_Reply.SFDC@informausa.com','Error - Sending Inspection Copy Emails',countMessage + 'Error sending...\n\r' + emailMessage);
                        /**
                        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                        {
                        //Send Error Email
                        Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
                        //Build Email Error Message
                        errorEmail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'Shay.Spoonmore@informaUSA.com'}; 
                        errorEmail.setToAddresses(toAddresses);
                        errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                        errorEmail.setBccSender(false);
                        errorEmail.setEmailPriority('High');
                        //errorEmail.setOrgWideEmailAddressId('0D2R0000000005aKAA');
                        errorEmail.setUseSignature(false);
                        errorEmail.setPlainTextBody(countMessage + 'Error sending...\n\r' + emailMessage);
                        
                        
                        Messaging.SendEmailResult[] sendEmailErrorResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { errorEmail });
                        }
                        **/
                        System.debug('#### Sent Error Message:' + emailMessage);
                       }
                        
                    }
                        
            }
          }
       }
    }
    
    
    Public static void SendErrorEmail(string emailTo,String emailSubject, String emailMessage )
    {
        
        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                        {
                        //Send Error Email
                        Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
                        //Build Email Error Message
                        errorEmail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = emailTo.split(';',-1);
                        errorEmail.setToAddresses(toAddresses);
                        errorEmail.setSubject(emailSubject); 
                        errorEmail.setBccSender(false);
                        errorEmail.setEmailPriority('High');
                        errorEmail.setUseSignature(false);
                        errorEmail.setPlainTextBody(emailMessage);
                        
                        
                        Messaging.SendEmailResult[] sendEmailErrorResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { errorEmail });
                        }
        
    }
    
      

    
}