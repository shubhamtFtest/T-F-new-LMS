/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-03-26
** 
***************************************************************************/
global class  CAS_SendFeedbackSchedule implements Schedulable{
    global void execute(SchedulableContext SC)  
    {  
    	
    	Boolean isSandbox = false;
    	Set<Id> batchProcessIds = new Set<Id>();
    	
    	if (UserInfo.getOrganizationId() != '00D0Y0000035IjiUAE') isSandbox = true;
    	
    	
    	
    	//Send feedback emails
    	CAS_TextbookFeedbackEmail feedbackEmail = new CAS_TextbookFeedbackEmail(); 
    	feedbackEmail.isTesting=isSandbox;
    	feedbackEmail.orgId=UserInfo.getOrganizationId();
    	
    	feedbackEmail.templateId = '00X0Y000000sUhwUAE';// Request for Feedback 35 days after created email 
    	batchProcessIds.add(Database.executeBatch(feedbackEmail));
        
        feedbackEmail.templateId = '00X0Y000000sUhwUAE-ROW';// Request for Feedback 60 days after created email for ROW/APAC
    	batchProcessIds.add(Database.executeBatch(feedbackEmail));
    	
    	feedbackEmail.templateId = '00X0Y000000sUhyUAE';// Request for Feedback Singapore 60 days after created email
    	batchProcessIds.add(Database.executeBatch(feedbackEmail));
    	
    	feedbackEmail.templateId = '00X0Y000000sUhxUAE';// Request for Feedback - FollowUp 14 days  after Feedback or feedback for Singapore
    	batchProcessIds.add(Database.executeBatch(feedbackEmail));
    	
    	feedbackEmail.templateId = '00X0Y000000sUmNUAU';// Request for Feedback - Shortform 90 days after Feedback or Feedback for Singapore if the product family not CRC and less than 50 students
    	batchProcessIds.add(Database.executeBatch(feedbackEmail));
    	
    	
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
    	
    	
    	
    }
}