/*
** Tested by: zTEST_CAS.cls && zTest_CAS_NewOpportunityProduct.cls
**
** CHG0042490 Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-05-16
** CHG0044348 Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-08-30
** CHG0045131 Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-10-02
** Modified by Jeff Lup - 2015.02.27 - Moved Trigger into this TrigClass
** Modified by Matt Smith - 2020.06.04 - Updated line 16 to support for CAS opps only.
*/
public without sharing class CAS_NewOpportunityProduct_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && trig.isInsert) {
       
            //get Opportunity owners email
            List<OpportunityLineItem> oppProducts = [Select o.Id, o.OpportunityId, o.Opportunity.Account.Name, o.Opportunity.Name, o.Opportunity.OwnerId ,o.Opportunity.Owner.email, o.PricebookEntryId, o.PricebookEntry.Name, o.PricebookEntry.Product2Id, o.PricebookEntry.Product2.Name 
                                            ,o.PricebookEntry.Product2.Author__c, o.PricebookEntry.Product2.Edition_Number__c , o.Opportunity.Number_of_Students__c from OpportunityLineItem o where o.id= :trig.newMap.keySet() AND o.Opportunity.RecordType.DeveloperName = 'CASCourseOpportunities'];
            
            List<Messaging.SingleEmailMessage> mailOppOwners = new List<Messaging.SingleEmailMessage>();
            for (OpportunityLineItem oppProd : oppProducts) { 
                //User oppUser = oppProd.OpportunityId;
                string editionNumber = '';
                
                if (oppProd.PricebookEntry.Product2.Edition_Number__c != null && oppProd.PricebookEntry.Product2.Edition_Number__c != 0) {
                    editionNumber = ', ' + oppProd.PricebookEntry.Product2.Edition_Number__c + 'e';
                }
                
                string[] emailInfo = new String[2];
    
                emailInfo[0] = 'New Book has been added to an Opportunity.';
                emailInfo[1] = 'Hi,'+ oppProd.Opportunity.Account.Name+'\n\n'
                    + oppProd.PricebookEntry.Name + editionNumber + ' by ' + oppProd.PricebookEntry.Product2.Author__c + ', has been added to your Opportunity. To see '+ oppProd.Opportunity.Name +', click on the link below.'  
                    + ' Number of Students: ' + oppProd.Opportunity.Number_of_Students__c + '\n\n'
                    + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppProd.Opportunity.Id +  '\n\nFrom,\nCAS';
                
                Messaging.SingleEmailMessage mailOppOwner = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new  String[] {oppProd.Opportunity.Owner.email};// 'Shay.Spoonmore@informaUSA.com'
                               
                mailOppOwner.setToAddresses(toAddresses);
                mailOppOwner.setSubject(emailInfo[0]);
                mailOppOwner.setPlainTextBody(emailInfo[1]);
                mailOppOwner.setEmailPriority('High');
                //mailOppOwner.setTemplateId('00XW0000000QE7q');//CAS - New Opportunity Product
                //The Target object is a Contact and will not work with out one
                //A Contact setup with the do_not_reply_textbookfeedback@taylorandfrancis.com email is the only way to make this work
                //mailOppOwner.setTargetObjectId('');//
                //mailOppOwner.setTargetObjectId(oppProd.Id);//
                //mailOppOwner.setwhatId(oppProd.OpportunityId);
                mailOppOwner.setSaveAsActivity(false);
                mailOppOwner.setBccSender(false);
                mailOppOwner.setUseSignature(false);
                
                mailOppOwner.setOrgWideEmailAddressId('0D20Y000000L2FpSAK');
                
                mailOppOwners.add(mailOppOwner);
            }
            
            if (mailOppOwners.size() > 0) {
                if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())) {   
                    Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(mailOppOwners, false);
                    System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                    
                    //loop through email results and update only successful related Inspection Copy
                    Integer errorCount = 0;
                    String emailMessage = '';
                    for (Integer i = 0, j = 0; i < sendEmailResults.size(); i++) { 
                        if (!sendEmailResults[i].isSuccess()) {
                            for (Messaging.Sendemailerror sendEmailError : sendEmailResults[i].getErrors()) {
                                System.debug('******Error Message:' + sendEmailError.Message);
                                String errorFields = '';
                                for(String field :sendEmailError.getFields()) {
                                    errorFields = errorFields + field + '; ';
                                }
                                                
                                String errorMessage = 'Message=' + sendEmailError.getMessage() + '::StatusCode=' + sendEmailError.getStatusCode()  + '::TargetObjectId=' +  sendEmailError.getTargetObjectId() + '::errorFields=' + errorFields ;
                                                
                                //Build Email Error Message
                                emailMessage = emailMessage + '::' + errorMessage + '\n\r';
                                                
                                errorCount++;// keep count of how many records errored
                            }
                        }
                    }
                    System.debug('******emailMessage:' + emailMessage);
                }
            }
        }
    }
}