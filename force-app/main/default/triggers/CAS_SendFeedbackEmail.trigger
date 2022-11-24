/**************************************************
* Created by Jeff Lup
* jeff.lup@informausa.com / 941-554-3475
*
* This trigger is meant to replace the class
*  CAS_OpportunityUpdateICOwner.cls which is not
*  firing upon mass transfer.  And it also replaces
*  the workflow rule "CAS - IC Feedback Submitted"
* Modified by Shay.Spoonmore@informausa.com - 2012.11.28 (CHG0045867)
* Modified by Jeff Lup - 2017.07.17 - switched org url to informa.my (CHG0036216/CHG0036218)
**************************************************/

trigger CAS_SendFeedbackEmail on CAS_Inspection_Copy__c (after insert, after update) {
    
    
    if (trigger.new.size() == 1 && MiscFunctions.triggerEnabled('CAS_SendFeedbackEmail')) {
      
        String orgUrl = 'https://taylorandfrancis.my.salesforce.com';
        //2012.12.13 Added limits because of errors with EmailInvocations
       

        if (limits.getEmailInvocations() < limits.getLimitEmailInvocations() && trigger.new[0].Adoption_Stage__c != null && (trigger.isInsert || trigger.old[0].Adoption_Level__c == null))
        {
            String emailaddress = [SELECT Owner.Email FROM Opportunity WHERE Id = :trigger.new[0].Opportunity__c].Owner.Email;
             String accountName = [SELECT Account.Name FROM Opportunity WHERE Id = :trigger.new[0].Opportunity__c].Account.Name;
            Integer numberStudents;
            String contactRep = '';
            String author='';
            Integer editionNumber;
            if (trigger.new[0].Product__c != null)
            {
                Product2 product = [SELECT Author__c,Edition_Number__c  FROM Product2 WHERE Id = :trigger.new[0].Product__c LIMIT 1];
                author=product.Author__c;
                editionNumber = (integer)product.Edition_Number__c;
            }
            
            numberStudents = (Integer) trigger.new[0].Number_of_Students__c;
            
            if (trigger.new[0].Contact_Rep__c != null)contactRep = trigger.new[0].Contact_Rep__c;
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Inspection Copy Feedback Submitted');
            String emailBody = '<html><body> Hi,'+  accountName + '\n\n' + trigger.new[0].Contact_Name__c + ' has submitted feedback for ' + trigger.new[0].Book_Title__c + ', '+ author +', '+ editionNumber +', '+ numberStudents  + '.'
                                + '<br><br>'
                                + 'Question :' + trigger.new[0].QuestionAboutT_FProduct__c
                             //   + 'Contact  Rep: ' + contactRep
                                + '<br><br>' 
                                + '<a href="' + orgUrl + '/' + trigger.new[0].Id + '">Click to view feedback</a>' 
                                + '</body></html>';
            email.setHtmlBody(emailBody);
            String[] emailAddresses = new String[]{emailaddress};
            //String[] emailAddresses = new String[]{'Shay.Spoonmore@informausa.com'};
            email.setToAddresses(emailAddresses);
            Messaging.SendeMailResult[] mailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                        system.debug('email '+email );

        }
    }
}