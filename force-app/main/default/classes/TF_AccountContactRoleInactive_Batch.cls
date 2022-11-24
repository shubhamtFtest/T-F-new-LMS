/*
* Created by Jeff Lup - 2016.10.11 - part of JCM project
* Called by: TF_AccountContactRoleInactive_Schedule
* Tested by: zTEST_TF_AccountContactRoleInactive
*
* Replaces inefficient workflow: "T&F - Account Contact Role Inactive Rule"
*/
global class TF_AccountContactRoleInactive_Batch implements Database.Batchable<Sobject> {
    public Boolean isTesting;// used for test methods
    public Integer queryLimit;
    private String query;

    global database.querylocator start(Database.BatchableContext BC)  
    {
        String DaysAgo730 = string.valueOfGmt(system.now().addDays(-730)).replace(' ','T') + 'Z';
        query = 'SELECT Id FROM AccountContactRole__c ';
        query += ' WHERE Account_Contact_Role__c <> \'eToC Subscriber\'';
        query += ' AND Active__c = true';
        query += ' AND Last_Interaction_Date__c <= ' + DaysAgo730;
        
        if (isTesting != null && isTesting)
            queryLimit = 500;
        
         if (queryLimit != null && queryLimit != 0) 
             query = query + ' LIMIT ' + queryLimit;
    
        System.debug('TF_AccountContactRoleInactive_Batch soql = ' + query);
        
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('DEBUG: Inside execute');
        List<AccountContactRole__c> acrs = new List<AccountContactRole__c>();
        for(sobject s : scope) {
            AccountContactRole__c acr = (AccountContactRole__c)s;
            acr.Active__c = false;
            acrs.add(acr);
        }
        try {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.optAllOrNone = false;
            database.update(acrs,dlo);
        } catch (Exception e) {            
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 || isTesting)
            SendErrorEmail(a.CreatedBy.Email + ';jeff.lup@informa.com','TF_AccountContactRoleInactive_Batch ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
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