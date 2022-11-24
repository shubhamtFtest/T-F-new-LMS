/*
* Created by Jeff Lup - 2017.02.07
* Tested by: zTEST_TF_MigrateNotes_Batch at 100%
*
* Used to migrate ContentNotes from one record to another
* Commented out, but saved for future use
*/

global class TF_MigrateNotes_Batch {}

/*
global class TF_MigrateNotes_Batch implements Database.Batchable<Sobject> {
    
    private String query;
    
    global database.querylocator start(Database.BatchableContext BC)  
    {        
        query = 'SELECT Id, Admin_Field_1__c FROM Account';
        query += ' WHERE RecordtypeId IN (\'01260000000DXrfAAG\',\'01260000000DXrkAAG\')'; //"OLD - CAS - Campus Accounts" or "OLD - CAS - Department Accounts"
        query += '   AND Admin_Field_2__c NOT IN (\'Notes Found\', \'Notes Not Found\')';
        query += '   AND Admin_Field_1__c LIKE \'__________________\'';
        
        if (Test.isRunningTest()) 
            query = query + ' LIMIT 100';
    
        System.debug('TF_MigrateNotes_Batch soql = ' + query);
        
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('DEBUG: Inside execute');
        List<ContentDocumentLink> cdlsToInsert = new List<ContentDocumentLink>();
        List<Account> accounts = new List<Account>();
        for(sobject s : scope) {
            System.debug('DEBUG: Inside Account loop');
            Account a = (Account)s;
            List<ContentDocumentLink> cdls = [SELECT Id, LinkedEntityId, ContentDocumentId, ShareType, Visibility
                                              FROM ContentDocumentLink
                                              WHERE LinkedEntityId = :a.Id];
            if (cdls.size() > 0) {
                for (ContentDocumentLink cdl : cdls) {
                    ContentDocumentLink newcdl = new ContentDocumentLink();
                    newcdl.LinkedEntityId = a.Admin_Field_1__c;
                    newcdl.ContentDocumentId = cdl.ContentDocumentId;
                    newcdl.ShareType = cdl.ShareType;
                    newcdl.Visibility = cdl.Visibility;
                    cdlsToInsert.add(newcdl);
                }
                a.Admin_Field_2__c = 'Notes Found';
                accounts.add(a);
            } else {
                a.Admin_Field_2__c = 'Notes Not Found';
            }
            //accounts.add(a); //too many updates, so only updating Notes Found now
        }
        try {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.optAllOrNone = true;
            //Insert ContentDocumentLink records
            database.insert(cdlsToInsert,dlo);
            //Flag Accounts as done
            database.update(accounts,dlo);
        } catch (Exception e) {
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 || Test.isRunningTest())
            SendErrorEmail(a.CreatedBy.Email + ';jeff.lup@informa.com','TF_MigrateNotes_Batch ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
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
*/