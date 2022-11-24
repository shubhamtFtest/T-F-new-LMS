/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Called by: TF_UpdateImplicitEmailOptOut_Schedule
* Tested by: zTEST_TF_UpdateImplicitEmailOptOut
*
* Replaces inefficient workflow: "T&F - Update Implicit Email Opt Out to TRUE"
*/
global class TF_UpdateImplicitEmailOptOut_Batch implements Database.Batchable<Sobject> {
    public Boolean isTesting;// used for test methods
    public Integer queryLimit;
    private String query;

    global database.querylocator start(Database.BatchableContext BC)  
    {
        String recordTypeId = '\''+label.TandF_Contact_Record_Type_Id+'\'';   
		String recordTypeIdI8 = '\''+label.TandF_Contact_Record_Type_Id_18+'\'';    
        String sToday = string.valueOfGmt(system.now()).left(10);
        String query = 'SELECT Id FROM Contact ';
        query += ' WHERE RecordtypeId in '; //T&F - Contacts
		query += '(' + recordTypeId + ',' + recordTypeIdI8 +')';
        query += ' AND Implied_Consent_Expiry_Date__c <> Null';
        query += ' AND Implicit_Email_Opt_Out__c = False';
        query += ' AND Implied_Consent_Expiry_Date__c <= ' + sToday;
        
        if (isTesting != null && isTesting)
            queryLimit = 500;
        
         if (queryLimit != null && queryLimit != 0) 
             query = query + ' LIMIT ' + queryLimit;
    
        System.debug('TF_UpdateImplicitEmailOptOut_Batch soql = ' + query);
        
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('DEBUG: Inside execute');
        List<Contact> contacts = new List<Contact>();
        for(sobject s : scope) {
            Contact c = (Contact)s;
            c.Implicit_Email_Opt_Out__c = true;
            c.Last_Modified_Opt_Out_Status_Date__c = system.now();
            contacts.add(c);
        }
        try {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.optAllOrNone = false;
            database.update(contacts,dlo);
        } catch (Exception e) {            
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 || isTesting)
            SendErrorEmail(a.CreatedBy.Email + ';jeff.lup@informa.com','TF_UpdateImplicitEmailOptOut_Batch ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
    }
    
    public static void SendErrorEmail(string emailTo,String emailSubject, String emailMessage) {
        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()) {
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