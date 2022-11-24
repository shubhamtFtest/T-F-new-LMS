/*
* Created by Sourabh Goyal - 25thSep2017
* Called by: TF_CANADAUpdateEmailOptOut_Schedule
* Tested by: zTEST_TF_CANADAUpdateEmailOptOut_Batch
* Summary : Explicit Opt Out all the Contacts from CANADA who do NOT have any Explicit Opt In Optin-OptOut Status record entry.
* 
*/

global class TF_CANADAUpdateEmailOptOut_Batch implements Database.Batchable<Sobject> 
{
    private String query;
    public Boolean isTesting;// used for test methods
    public string testContactId;
    global database.querylocator start(Database.BatchableContext BC)  
    {
        String recordTypeId = '\''+label.TandF_Contact_Record_Type_Id+'\'';   
        String recordTypeIdI8 = '\''+label.TandF_Contact_Record_Type_Id_18+'\'';    
        String query = 'SELECT Id,Account_Shipping_Country__c,optin_optout_source__c,optin_optout_status__c,Last_Modified_Opt_Out_Status_Date__c,Last_Modified_Global_Opt_Out_Status_Date__c,HasOptedOutOfEmail FROM Contact ';
        query += ' WHERE RecordtypeId in '; //T&F - Contacts
        query += '(' + recordTypeId + ',' + recordTypeIdI8 +')';
        if (isTesting != null && isTesting && testContactId !=null)
        {
          query += ' AND ( Id = ' + '\'' + testContactId + '\')';
        }
        else
        {
          query += ' AND ( Email LIKE \'%.ca\'';
          query += ' OR MailingCountry = \'CANADA\' OR MailingCountry = \'CA\' OR Account_Shipping_Country__c = \'Canada\') AND HasOptedOutOfEmail = False AND (optin_optout_status__c!= \'Explicit Opt-Out\' AND optin_optout_status__c!= \'Explicit Opt-In\') AND (Email!=\'need.email@address.com\' AND Email!=\'no_email@address.com\')';
        }
  
        if (isTesting != null && isTesting)
              query = query + ' LIMIT ' + 5;
        
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope) 
    {
        List<Contact> contactList = new List<Contact>();
        if(scope.size()>0){
            for(Contact s : scope) 
            {
                s.optin_optout_source__c = 'CASL';
                s.optin_optout_status__c = 'Explicit Opt-Out';
                s.Last_Modified_Opt_Out_Status_Date__c = System.today();
                contactList.add(s);
            }
            
        }
        try {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.optAllOrNone = false;
            database.update(contactList,dlo);
        } catch (Exception e) {
            system.debug('exception:: '+string.valueOf(e));
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
            //System.Debug('a.TotalJobItems : '+a.TotalJobItems);
        // Send an email to the Apex job's submitter notifying of job completion.
        try{
            if (a.NumberOfErrors > 0 || isTesting)
              SendErrorEmail(a.CreatedBy.Email + ';'+ label.TF_Job_Error_Send_Email, 'TF_UpdateImplicitEmailOptOut_Batch ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
            system.debug('errors:: '+a.NumberOfErrors);
            
        }catch(Exception e){
            system.debug('exception error:: '+string.valueOf(e));
        }
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