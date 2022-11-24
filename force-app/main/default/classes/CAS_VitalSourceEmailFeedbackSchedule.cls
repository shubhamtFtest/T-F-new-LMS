/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
***************************************************************************/
global class CAS_VitalSourceEmailFeedbackSchedule implements Schedulable
{
	global boolean sendStatus = false;
    global void execute(SchedulableContext SC)    
    {  
    	CAS_VitalSourceEmailFeedback vsFeedback = new CAS_VitalSourceEmailFeedback();
    	Set<Id> batchProcessIds = new Set<Id>();
        
		vsFeedback.isTesting = false; 
		vsFeedback.queryLimit = 5000; 
		       
		if (UserInfo.getOrganizationId() != '00D0Y0000035IjiUAE')// if uat'00Dg00000004X5lEAE'
		  vsFeedback.isTesting = true;
		  
		  
		vsFeedback.emailProcess='Email2'; //VS 2 Unredeemed codes - 7 days after first instructor email       
		batchProcessIds.add(Database.executeBatch(vsFeedback));  
		
		
		vsFeedback.emailProcess='Email3'; //VS 3 unredeemed codes final push - 14 days after first instructor email
		batchProcessIds.add(Database.executeBatch(vsFeedback));  
		
		
		vsFeedback.emailProcess='Email4'; //VS 4 Request for Feedback "redeemed" - 14 days after redeemed if no feedback
		batchProcessIds.add(Database.executeBatch(vsFeedback));  
		
		
		vsFeedback.emailProcess='Email5'; //VS 5 Request for Feedback final push "redeemed" - 28 days after redeemed if no feedback
		batchProcessIds.add(Database.executeBatch(vsFeedback));  
    	
    	Boolean sendMessage = false;
    	String emailMessage = '';
    	String emailCreated = '';
    	for(AsyncApexJob apexJob: [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchProcessIds])
    	{
    		if (apexJob.NumberOfErrors > 0  || vsFeedback.isTesting || sendStatus)
			{
				sendMessage = true;
				emailCreated = apexJob.CreatedBy.Email;
				emailMessage += apexJob.Id + ') The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.\n\n' + apexJob.ExtendedStatus + '\n\n';
			}
    	}
    	
    	if (sendMessage)
    	{
    		CAS_VitalSourceEmailFeedback.SendErrorEmail( emailCreated + ';Do_Not_Reply.SFDC@informausa.com','CAS VitalSource FeedbackSchedule', emailMessage );
    	}
    	
    	
    	
    }
    
    
}