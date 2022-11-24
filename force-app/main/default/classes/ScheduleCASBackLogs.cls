global class ScheduleCASBackLogs implements Schedulable{
	global void execute(SchedulableContext SC) {
		
		CASEmailIssue send = new CASEmailIssue();
    	send.query = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,System_Id__c, SystemModstamp from CAS_Inspection_Copy__c ' + 
    				'where Contact_Email__c != null AND System_Id__c != null and Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c > 2021-11-04T20:00:00Z  and (Opportunity__r.Start_Date__c >= Today or Opportunity__r.Start_Date__c = null) Order by CreatedDate DESC ';
   		send.orgId =[select Id from Organization].Id;
   		//send.templateId = '00X60000000sksNEAQ';
        send.templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Request_for_Feedback'].Id;
		send.isTesting=false;
		send.recordLimit = '7000';
		ID batchprocessid = Database.executeBatch(send);
		
	}
}