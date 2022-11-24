/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** PLEASE KEEP FOR A YEAR!
** Replaced by CAS_VitalSourceEmailFeedbackSchedule
***************************************************************************/

global class CAS_VitalSourceHSSFeedbackSchedule implements Schedulable
{
	global boolean sendStatus = false;
    global void execute(SchedulableContext SC)    
    {  /**
    	CAS_VitalSourceHSSFeedback vsHSSFeedback = new CAS_VitalSourceHSSFeedback();
    	Set<Id> batchProcessIds = new Set<Id>();
        
		vsHSSFeedback.isTesting = false; 
		vsHSSFeedback.queryLimit = 5000; 
		       
		if (UserInfo.getOrganizationId() != '00D300000001NXOEA2')// if uat'00Dg00000004X5lEAE'
		  vsHSSFeedback.isTesting = true;
		  
		  
		vsHSSFeedback.templateId='00X60000004ynaPEAQ'; //HSS VS 2 Unredeemed codes - 7 days after first instructor email       
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));  
		
		
		vsHSSFeedback.templateId='00X60000004ynaZEAQ'; //HSS VS 3 unredeemed codes final push - 14 days after first instructor email
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));  
		
		
		vsHSSFeedback.templateId='00X60000004ynajEAA'; //HSS VS 4 Request for Feedback "redeemed" - 14 days after redeemed if no feedback
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));  
		
		
		vsHSSFeedback.templateId='00X60000004ynaoEAA'; //HSS VS 5 Request for Feedback final push "redeemed" - 28 days after redeemed if no feedback
		batchProcessIds.add(Database.executeBatch(vsHSSFeedback));  
    	
    	Boolean sendMessage = false;
    	String emailMessage = '';
    	String emailCreated = '';
    	for(AsyncApexJob apexJob: [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchProcessIds])
    	{
    		if (apexJob.NumberOfErrors > 0  || vsHSSFeedback.isTesting || sendStatus)
			{
				sendMessage = true;
				emailCreated = apexJob.CreatedBy.Email;
				emailMessage += apexJob.Id + ') The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.\n\n' + apexJob.ExtendedStatus + '\n\n';
			}
    	}
    	
    	if (sendMessage)
    	{
    		CAS_VitalSourceHSSFeedback.SendErrorEmail( emailCreated + ';Shay.Spoonmore@informaUSA.com;Do_Not_Reply.SFDC@informausa.com','CAS VitalSource HSS FeedbackSchedule', emailMessage );
    	}
    	
    	
    	**/
    }
    
    
}