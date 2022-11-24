global class CAS_OpportuntityAutoCloseSchedule implements Schedulable{
	global boolean sendStatus = false;
    global void execute(SchedulableContext SC)    
    {  
        CAS_OpportuntityAutoCloseBatch OpportuntityAutoClose = new CAS_OpportuntityAutoCloseBatch();
        
        OpportuntityAutoClose.isTesting = false; 
        OpportuntityAutoClose.queryLimit = 5000; 
        
        if (UserInfo.getOrganizationId() != '00D0Y0000035IjiUAE')// if uat'00Dg00000004X5lEAE'
        OpportuntityAutoClose.isTesting = true;
         
        ID batchprocessid = Database.executeBatch(OpportuntityAutoClose); 
        
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
						TotalJobItems, ExtendedStatus, CreatedBy.Email from AsyncApexJob where Id =:batchprocessid];
			// Send an email to the Apex job's submitter notifying of job completion.
		if (a.NumberOfErrors > 0  || OpportuntityAutoClose.isTesting || sendStatus)
		{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('CAS OpportuntityAutoCloseBatch ' + a.Status);
		mail.setPlainTextBody
			(batchprocessid + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

		}
         
    }
    
//CAS_OpportuntityAutoCloseBatch OpportuntityAutoClose = new CAS_OpportuntityAutoCloseBatch();
//OpportuntityAutoClose.isTesting = true;
//ID batchprocessid = Database.executeBatch(OpportuntityAutoClose, 500);
    
}