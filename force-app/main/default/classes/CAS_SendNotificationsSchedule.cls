/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-03-26
** 
***************************************************************************/
global class  CAS_SendNotificationsSchedule implements Schedulable{
    global void execute(SchedulableContext SC)  
    {  
    	
    	Boolean isSandbox = false;
    	Set<Id> batchProcessIds = new Set<Id>();
    	
    	if (UserInfo.getOrganizationId() != '00D0Y0000035IjiUAE') isSandbox = true;
    	
    	
    	//Send first email
    	CAS_TextbookFeedbackCreatedEmail createEmail = new CAS_TextbookFeedbackCreatedEmail();
    	createEmail.isTesting=isSandbox;
    	createEmail.orgId=UserInfo.getOrganizationId();
    	createEmail.isAvailable = true;// send new requests
    	batchProcessIds.add(Database.executeBatch(createEmail)); 
    	createEmail.isAvailable = false;// send old requests for backorders
    	batchProcessIds.add(Database.executeBatch(createEmail)); 
    	
    	Boolean sendMessage = false;
    	String emailMessage = '';
    	String emailCreated = '';
    	for(AsyncApexJob apexJob: [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchProcessIds])
    	{
    		if (apexJob.NumberOfErrors > 0  || Test.isRunningTest())
			{
				sendMessage = true;
				emailCreated = apexJob.CreatedBy.Email;
				emailMessage += apexJob.Id + ') The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.\n\n' + apexJob.ExtendedStatus + '\n\n';
			}
    	}
    	
    	if (sendMessage)
    	{
    		CASEmail.SendErrorEmail( emailCreated + ';Do_Not_Reply.SFDC@informausa.com','CAS Textbook Feedback Schedule', emailMessage );
    	}
    	
    	
    	
    	
    	/****Old Schedule for CAS Email Future calls
    	String orgId = [select Id from Organization].Id;
    	
    	String tesingMethodId = '';
    	
    	if (Test.isRunningTest()) 
    	{
    		tesingMethodId = [Select id from CAS_Inspection_Copy__c where IsTesting__c = true limit 1].Id; //'TEST';
    		system.debug('#######tesingMethodId=' +  tesingMethodId);
    		
    	}
    	else
    	{	//Does not run in test methods, interferes with test methods and covered by zTest_AsyncApexJobAlerts
    		AsyncApexJobAlerts.CAS_DeadMesagesQueue();
    	}
    	
         
        //Send Textbook Feedbacks
        Boolean processSendEmailInProcess = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailInProcess.true');
		if (!processSendEmailInProcess)
			{
				CASEmail.SendEmailInProcess(true,orgId, tesingMethodId);
			}
			
		//THE FUTURE - Send\Check if the products are availble now
	    	Boolean processSendEmailInProcessFalse = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailInProcess.false');
			if (!processSendEmailInProcessFalse)
			{
			    CASEmail.SendEmailInProcess(false,orgId, tesingMethodId);
			}
             
            //THE FUTURE - Send FeedBack
            Boolean processSendEmailFeedBack = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailFeedBack');
            if (!processSendEmailFeedBack)
            {
            CASEmail.SendEmailFeedBack(orgId, tesingMethodId);
            }
            
            //THE FUTURE - Send Sinapore
            Boolean processSendEmailFeedBackSingapore = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailFeedBackSingapore');
            if (!processSendEmailFeedBackSingapore)
            {
            CASEmail.SendEmailFeedBackSingapore(orgId, tesingMethodId);
            }
            
            //THE FUTURE - Send feedback followup after 14 days
            Boolean processSendEmailFeedBackFollowUp = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailFeedBackFollowUp');
            if (!processSendEmailFeedBackFollowUp)
            {
            CASEmail.SendEmailFeedBackFollowUp(orgId, tesingMethodId);
            }
            
            //THE FUTURE - Send feedback short form after 90 days
            Boolean processSendEmailFeedBackShortForm = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailFeedBackShortForm');
            if (!processSendEmailFeedBackShortForm)
            {
            CASEmail.SendEmailFeedBackShortForm(orgId, tesingMethodId);
            }	
        
         **/
        
    }
}