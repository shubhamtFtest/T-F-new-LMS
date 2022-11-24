/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** PLEASE KEEP FOR A YEAR!
** Replaced by CAS_VitalSourceEmailFeedback

** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-01-09
** create schedule Apex - Job Name: CAS_CAS_VitalSourceHSSFeedbackSchedule


CAS_VitalSourceHSSFeedback vsHSSFeedback = new CAS_VitalSourceHSSFeedback();
        
vsHSSFeedback.isTesting = false; 
vsHSSFeedback.queryLimit = 5000; 
       
if (UserInfo.getOrganizationId() != '00D300000001NXOEA2')// if uat'00Dg00000004X5lEAE'
  vsHSSFeedback.isTesting = true;

vsHSSFeedback.templateId='00X60000004ynaPEAQ';          
ID batchprocessid = Database.executeBatch(vsHSSFeedback);  
AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchprocessid];

vsHSSFeedback.templateId='00X60000004ynaZEAQ'; 
batchprocessid = Database.executeBatch(vsHSSFeedback);  
a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchprocessid];

vsHSSFeedback.templateId='00X60000004ynajEAA'; 
batchprocessid = Database.executeBatch(vsHSSFeedback);  
a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchprocessid];

vsHSSFeedback.templateId='00X60000004ynaoEAA'; 
batchprocessid = Database.executeBatch(vsHSSFeedback);  
a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchprocessid];

 
***************************************************************************/
global class  CAS_VitalSourceHSSFeedback implements Database.Batchable<Sobject>
{
public Boolean isTesting;// used for test methods
public Integer queryLimit;
private String query;   
public String templateId;


	global database.querylocator start(Database.BatchableContext BC)  
	{
		/**
		query = 'SELECT CreatedDate,Id, Name, Contact_Email__c, Sent_VS_Back_Order__c,Sent_VS_Bookshelf_Code__c,Sent_VS_Instructor__c,Sent_VS_Redeemed_Feedback_Final_Push__c,Sent_VS_Redeemed_Feedback__c,Sent_VS_Redeemed__c,Sent_VS_Unredeemed_Final_Push__c,Sent_VS_Unredeemed__c,SystemModstamp FROM CAS_Inspection_Copy__c ';
		query +='WHERE (Order_Type__c = \'HSS Vitalsource e-Exam copy\' AND Contact_Email__c != null)';
		
		if (templateId == '00X60000004ynaPEAQ')//HSS VS 2 Unredeemed codes - 7 days after first instructor email
		{
			query +=' AND Sent_VS_Redeemed__c = null AND Sent_VS_Unredeemed__c = null AND Sent_VS_Instructor__c < LAST_N_DAYS:7';
		}
		else if (templateId == '00X60000004ynaZEAQ')//HSS VS 3 unredeemed codes final push - 14 days after first instructor email
		{
			query +=' AND Sent_VS_Redeemed__c = null AND Sent_VS_Unredeemed__c != null AND Sent_VS_Unredeemed_Final_Push__c=null AND Sent_VS_Unredeemed__c < LAST_N_DAYS:7';
		}
		else if (templateId == '00X60000004ynajEAA')//HSS VS 4 Request for Feedback "redeemed" - 14 days after redeemed if no feedback
		{
			query +=' AND (Adoption_Short__c = null and Adoption_Stage__c = null) AND Sent_VS_Redeemed__c != null AND Sent_VS_Redeemed_Feedback__c = null AND Sent_VS_Redeemed__c < LAST_N_DAYS:14';
		}
		else if (templateId == '00X60000004ynaoEAA')//HSS VS 5 Request for Feedback final push "redeemed" - 28 days after redeemed if no feedback
		{
			query +=' AND (Adoption_Short__c = null and Adoption_Stage__c = null) AND Sent_VS_Redeemed__c != null AND Sent_VS_Redeemed_Feedback__c != null AND Sent_VS_Redeemed_Feedback_Final_Push__c =null AND Sent_VS_Redeemed_Feedback__c < LAST_N_DAYS:14';
		}
		
		if (isTesting != null && isTesting)	
		{queryLimit = 500; } 
		
		if (queryLimit != null && queryLimit != 0)
		{query = query + ' LIMIT ' + queryLimit;}
		
		System.debug('#### CAS_VitalSourceHSSFeedback soql=' + query); 
		**/
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{/**
		if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()))
        {
          	
		 //Production Organization Id = '00D300000001NXOEA2'
		Boolean uat = true;
        If (UserInfo.getOrganizationId() == '00D300000001NXOEA2')uat = false; 
                        
        System.debug('####SendInspectionCopy.size = ' + scope.size());
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<CAS_Inspection_Copy__c> updateInspectionCopies = new List<CAS_Inspection_Copy__c>();
        Set<Id> sentHSSVSUnredeemedCodes = new Set<Id>();
    	Set<Id> sentHSSVSUnredeemedCodesFinalPush = new Set<Id>();
    	Set<Id> sentHSSVSRequestFeedbackRedeemed = new Set<Id>();
    	Set<Id> sentHSSVSRequestFeedbackRedeemedFinalPush = new Set<Id>();
    	
        Integer currentRecord= 0;
		
			for(sObject s : scope)
			{
				
				CAS_Inspection_Copy__c sendingICI= (CAS_Inspection_Copy__c) s;
				
				System.debug('*****currentRecord = ' + currentRecord);
                System.debug('*****SendingICI.Id = ' + sendingICI.Id);
                                
                                //Update a different Field for each Process
                                if (templateId == '00X60000004ynaPEAQ')//HSS VS 2 Unredeemed codes
                                {
                                    sentHSSVSUnredeemedCodes.add(sendingICI.Id);
                                    updateInspectionCopies.add(new CAS_Inspection_Copy__c(Id = sendingICI.Id, Sent_VS_Unredeemed__c = System.now()));
                                    
                                }
                                else if(templateId == '00X60000004ynaZEAQ')//HSS VS 3 unredeemed codes final push
                                {
                                	sentHSSVSUnredeemedCodesFinalPush.add(sendingICI.Id);
                                    updateInspectionCopies.add(new CAS_Inspection_Copy__c(Id = sendingICI.Id, Sent_VS_Unredeemed_Final_Push__c = System.now()));
                                
                                }
                                else if(templateId == '00X60000004ynajEAA')//HSS VS 4 Request for Feedback "redeemed" - 14 days after redeemed if no feedback
                                {
                                	sentHSSVSRequestFeedbackRedeemed.add(sendingICI.Id);
                                    updateInspectionCopies.add(new CAS_Inspection_Copy__c(Id = sendingICI.Id, Sent_VS_Redeemed_Feedback__c = System.now()));
                                
                                }
                                else if(templateId == '00X60000004ynaoEAA')//HSS VS 5 Request for Feedback final push "redeemed" - 28 days after redeemed if no feedback
                                {
                                	sentHSSVSRequestFeedbackRedeemedFinalPush.add(sendingICI.Id);
                                    updateInspectionCopies.add(new CAS_Inspection_Copy__c(Id = sendingICI.Id, Sent_VS_Redeemed_Feedback_Final_Push__c = System.now()));
                                
                                }
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses;
                                
                //Check if code is firing in a Dev environment
                //Production Organization Id = '00D300000001NXOEA2'
                if (uat)
                {
                   toAddresses = new String[] {'Shay.Spoonmore@informaUSA.com','Do_Not_Reply.SFDC@informausa.com'};
                                    //errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                }
                else
                {
                   toAddresses = new String[] {SendingICI.Contact_Email__c}; //, 'Shay.Spoonmore@informaUSA.com' ,'SASInforma@gmail.com', 'Haley.McCarthy@informausa.com'
                }
                                
                                
                                mail.setToAddresses(toAddresses);
                                mail.setTemplateId(templateId);
                                //The Target object is a Contact and will not work with out one
                                //A Contact setup with the do_not_reply_textbookfeedback@taylorandfrancis.com email is the only way to make this work
                                mail.setTargetObjectId('0036000000sg1QMAAY');//
                                mail.setwhatId(SendingICI.Id);
                                mail.setSaveAsActivity(false);
                                mail.setBccSender(false);
                                mail.setUseSignature(false);
                                //CHANGE THE ORG WIDE EMAIL WITH PRODUCTION!!!
                                mail.setOrgWideEmailAddressId('0D2600000004CA6CAM');
                                //
                                mails.add(mail); 
                                   
                                currentRecord = currentRecord + 1;
          }
          
          //Send emails
          Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(mails, false);
          System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                        
          if (updateInspectionCopies.size() > 0) 
          {
                            update updateInspectionCopies;//update the date
                            System.debug('******Update Record Sent:' + sendEmailResults.size()); 
          }
                                
                        
          System.debug('******How Many InspectionCopy updated? ' + updateInspectionCopies.size()); 
                        
          List<CAS_Inspection_Copy__c> updateICopyError = new CAS_Inspection_Copy__c[]{};
          
           //loop through email results and update only successful related Inspection Copy
          Integer errorCount = 0;
          String emailMessage = '';
          for(Integer i = 0, j = 0; i < sendEmailResults.size(); i++)
          { 
          	if(sendEmailResults[i].isSuccess())
            { 
                    	 CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = updateInspectionCopies[i].Id, Sent_Email_Message__c = null, Sent_Email_Failure__c=false, Sent_Email_Date__c=System.now());
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
                                        
                                        String errorMessage = 'Message=' + sendEmailError.getMessage() + '::StatusCode=' + sendEmailError.getStatusCode()  + '::TargetObjectId=' +  sendEmailError.getTargetObjectId() + '::errorFields=' + errorFields ;
                                        
                                      
    		
		    		if (sentHSSVSUnredeemedCodes.contains(updateInspectionCopies[i].Id))
		    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = updateInspectionCopies[i].Id, Sent_Email_Message__c = 'HSS VS 2 Unredeemed Codes:: ' + errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_VS_Unredeemed__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
		    		}                     
		            else if (sentHSSVSUnredeemedCodesFinalPush.contains(updateInspectionCopies[i].Id))
		    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = updateInspectionCopies[i].Id, Sent_Email_Message__c = 'HSS VS 3 Unredeemed Codes Final Push:: ' +errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_VS_Unredeemed_Final_Push__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
    				}
    				 else if (sentHSSVSRequestFeedbackRedeemed.contains(updateInspectionCopies[i].Id))
		    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = updateInspectionCopies[i].Id, Sent_Email_Message__c = 'HSS VS 4 Request for Feedback "redeemed":: ' +errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_VS_Redeemed_Feedback__c  = null);
                                        updateICopyError.add(updateICopyErrorRecord);
    				}
    				 else if (sentHSSVSRequestFeedbackRedeemedFinalPush.contains(updateInspectionCopies[i].Id))
		    		{
                                        
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = updateInspectionCopies[i].Id, Sent_Email_Message__c = 'HSS VS 5 Request for Feedback final push "redeemed":: ' +errorMessage, Sent_Email_Failure__c=true, Sent_Email_Date__c=System.now(), Sent_VS_Redeemed_Feedback_Final_Push__c = null);
                                        updateICopyError.add(updateICopyErrorRecord);
    				}                        
                                        
                                        
                                        
                                        
                                        
                                        //Build Email Error Message
                                        emailMessage = emailMessage + updateInspectionCopies[i].Id + '::' + errorMessage + '\n\r';
                                        
                                        errorCount++;// keep count of how many records errored
                    }
                     
                }  
               
          }
          
          if (updateICopyError != null || Test.isRunningTest())
          {
                       //System.debug('##### Error Count:' + errorCount); 
                       //System.debug('##### Update IC Error Records:' + updateICopyError.size()); 'getEmailInvocations:' + Limits.getEmailInvocations + 
                       String countMessage = 'getEmailInvocations:' + Limits.getEmailInvocations() + '\n\rError Count:' + errorCount + '\n\rUpdate IC Error Records:' + updateICopyError.size()+ '\n\r';
                       System.debug('##### ' + countMessage); 
                       try
                       {
                        if(updateICopyError.size() > 0)
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
                        
                       	if (emailMessage != '') SendErrorEmail('Shay.Spoonmore@informaUSA.com;Do_Not_Reply.SFDC@informausa.com','Error - CAS VitalSource HSS Feedback Emails',countMessage + 'Error sending...\n\r' + emailMessage);
                        
                        System.debug('#### Sent Error Message:' + emailMessage);
                       }
                        
          }
          
		
       }
		
		**/
	}
	
	global void finish(Database.BatchableContext BC)
	{
		/**
		
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
						TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
			// Send an email to the Apex job's submitter notifying of job completion.
		if (a.NumberOfErrors > 0 || isTesting)
		{
		
		SendErrorEmail(a.CreatedBy.Email + ';Shay.Spoonmore@informaUSA.com;Do_Not_Reply.SFDC@informausa.com','CAS VitalSource HSS Feedback ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
		}
		**/
	}
	
	/**
	public static void SendErrorEmail(string emailTo,String emailSubject, String emailMessage )
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
        
    }**/

}