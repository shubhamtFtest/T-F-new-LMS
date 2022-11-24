/************************************************************************** 
** CAS Trigger Sending Email
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-03-30
** Keep for a year! changed 2015-03-30 to delete 2016-03-30
***************************************************************************/

trigger CAS_SendNotifications on CAS_Inspection_Copy__c (after insert, before insert) {
    
    //if (!CASEmail.hasRunBeforeTrigger)
    //{CASEmail.hasRunBeforeTrigger = true;
    //the hasrunbeforetriger ...Did not work when more than one triger was fireing at the same time
    //}
    //System.debug('*****trigger.isExecuting = ' + trigger.isExecuting );
    
   /** 
    
        String tesingMethodId = '';
        
        
        
        if (MiscFunctions.triggerEnabled('CAS_SendNotifications') && !System.isFuture())
        {
        
        
         if (trigger.isAfter)
         {
         	if (trigger.new[0].IsTesting__c == true) 
         	{
         		tesingMethodId = trigger.new[0].Id;
         		System.debug('*****tesingMethodId = ' + tesingMethodId );
         	}
         	//Using the Org Id to make sure emails are only sent to contacts in production
        	String orgId = [select Id from Organization].Id;
         	
		        if (trigger.isInsert)
		         {
		         
			    	Boolean processSendEmailInProcess = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailInProcess.true');
					if (!processSendEmailInProcess)
					{
					    CASEmail.SendEmailInProcess(true,orgId, tesingMethodId);
					}
		            
		         }
         
       		
            
            //THE FUTURE - Send\Check if the products are availble now
	    	Boolean processSendEmailInProcess = ApplicationRunningProcess.CheckProcessRunning('CAS.SendEmailInProcess.false');
			if (!processSendEmailInProcess)
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
            
         } 
   		 
        }
        **/

}