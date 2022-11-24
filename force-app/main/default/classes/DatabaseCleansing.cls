/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-11-30
**####### Deletes data older than a number of days
***************************************************************************/
public class DatabaseCleansing 
{
    public static integer dataCount = 0;
    public static string emailDefaultTo = 'Do_Not_Reply.SFDC@informausa.com';
        
    Public static void GetSettings(id settingItemId)
    {
        
        
        
        String soqlOrderBy =  ' ORDER BY LastModifiedDate ASC ';
        Boolean isSandbox = false;
      Set<Id> batchProcessIds = new Set<Id>();
      
        string settingsItemQuery = 'SELECT Checkbox_1__c,Checkbox_2__c,Checkbox_3__c,Id,Name,Setting__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c FROM Setting_Item__c Where Checkbox_1__c=true AND Setting__r.Name = \'Database Cleansing\'';
        if(settingItemId != null) settingsItemQuery += ' AND Id=\''+ settingItemId +'\'';
      
        
        list<Setting_Item__c> settingItems = Database.query(settingsItemQuery);
        
        for(Setting_Item__c si : settingItems)
    {   
            string soqlObject = si.Text_1__c;
            string soqlWhere = si.Text_2__c == null? '' : ' AND ' + si.Text_2__c;
            string soqlLimit = si.Text_6__c == null? '' : ' LIMIT ' + si.Text_6__c;
            
            string daysHowMany = si.Text_3__c;
            string emailErrorsTo = si.Text_4__c;
            string emailReportTo = si.Text_5__c;
            string dateField = si.Checkbox_3__c ? 'CreatedDate' : 'LastModifiedDate';
            boolean emptyRecyleBinScope = si.Checkbox_2__c;
            string soqlwhereLastNDays= ' WHERE ('+ dateField +' < LAST_N_DAYS:'+ daysHowMany +')';
            if (daysHowMany == '0') 
            {
                soqlwhereLastNDays = '';
               soqlWhere = si.Text_2__c == null? '' : ' WHERE ' + si.Text_2__c;
            }
            
            string soqlRecordsToDelete = 'SELECT Id FROM ' + soqlObject + soqlwhereLastNDays + ' ' + soqlWhere ;
        
      //####Could Not get Counts Because of Limits -- Get counts and test query 
            //Integer objectCount = Integer.valueOf(Database.countQuery(soqlRecordsToDelete.replace('Id', 'count()') + ' Limit 40000'));            
            
          System.debug('#### Delete soql=' + soqlRecordsToDelete + soqlOrderBy + soqlLimit);
            DatabaseCleansingBatch clean = new DatabaseCleansingBatch();
            clean.soqlRecordsToDelete = soqlRecordsToDelete + soqlOrderBy + soqlLimit;
        clean.soqlObject = soqlObject;
        clean.emailErrorsTo = emailErrorsTo;
        clean.emailReportTo  =emailReportTo;
            clean.emailReportTo  =emailReportTo;
        clean.emptyRecyleBinScope=emptyRecyleBinScope;
            
            try{
            batchProcessIds.add(Database.executeBatch(clean));
            }
            catch(Exception e)
            {
                string emailTo = emailErrorsTo;
                string emailPriority= 'High';
                string emailSubject= 'SFDC Data Cleansing ' + soqlObject.toUpperCase() + ' Exception!!!';
                string emailMessage = 'Object: ' +soqlObject +'\nSOQL: '+ soqlRecordsToDelete +'\n\nException Information\nMessage: '+ e.getMessage() + '\nCause: ' + e.getCause() + '\nLineNumber: '+ e.getLineNumber() + '\nStackTrace: ' + e.getStackTraceString();
                
                emailPriority='High';
                emailSubject= emailSubject.toUpperCase() ;
                
                     
               SendEmail(emailTo,emailSubject,emailMessage ,emailPriority);
            }
        }
    }
    
    public static void SendEmail(string emailTo,string emailSubject, string emailMessage,string emailPriority )
    {
        
        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
        {
                        //Send Email
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //Build Email Message
                        //mail = new Messaging.SingleEmailMessage();
                  set<string> toDedupeAddresses = new set<string>();
                  toDedupeAddresses.add(DatabaseCleansing.emailDefaultTo);
            
                  //Clean emails
                  if (emailTo.endsWith(';') || emailTo.endsWith(',')) 
                        {
                            integer r = (emailTo.length() - 1);
                            emailTo = emailTo.left(r);
                        }
                  if (emailTo.startsWith(';') || emailTo.startsWith(',')) 
                        {
                            integer r = (emailTo.length() - 1);
                            emailTo = emailTo.right(r);
                        }
                  
                  
            
                  toDedupeAddresses.addAll(emailTo.split(';' ,-1));
                  //toDedupeAddresses.addAll(emailTo.split(',',-1));
            list<string> toAddresses= new list<string>();
                  toAddresses.addAll(toDedupeAddresses);
                  
                  System.debug('#### emailTo=' + emailTo + ';list:' + toAddresses);
                  mail.setSenderDisplayName('SFDC Data Cleansing');
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(emailSubject); 
                        mail.setBccSender(false);
            
                        mail.setEmailPriority(emailPriority);// values =
                        mail.setUseSignature(false);
                        mail.setPlainTextBody(emailMessage);
                        
                        
                        Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         }
        
    }

}