/* Tested by: zTEST_TF_EmailMessage_MapToCase_Trig  at 98%
* 
*	CHG0041736 - Updated by Tom Reed - 2018.02.21 - Removed Email Message
*  	Created by Jeff Lup and Tom Reed - 2017.11.15
*
*/
public class TF_EmailMessage_MapToCase_Trig implements TriggerInterface_EmailMessage.Runnable {
    
    public void run(TriggerInterface_EmailMessage.Trig trig) {
        if (trig.isBefore && trig.isInsert) {
            List<EmailMessage> emailMessages = new List<EmailMessage>();
            Map<Id, String> mapEmailMessageIdToOldThreadId = new Map<Id, String>();
            Map<Id, Id> mapEmailMessageIdToOldOrgCaseId = new Map<Id, Id>();
            System.debug('trig.newList Size:'+trig.newList.size());
            for (EmailMessage em : trig.newList) {     
                String subject = String.Valueof(em.subject);
                String sos = '[ ref:';  
                String eos = ':ref ]';
                
                if (subject != null && subject.contains(sos) && subject.contains(eos)) {
                    String threadId;
                    Id orgId;
                    Id caseId;
                    try {
                        threadId = subject.mid(subject.indexOf(sos) + 7, (subject.indexOf(eos) - subject.indexOf(sos) - 7));
                        orgId = threadId.left(5) + '000000' + threadId.mid(5,4);
                        caseId = threadId.mid(11,5) + '0000' + threadId.mid(16,6);
                    }
                    catch(Exception e){}
                    
                    if (orgId == '00D300000001NXO') { //came from the old org
                        emailMessages.add(em);
                        mapEmailMessageIdToOldOrgCaseId.put(em.Id, caseId);
                        mapEmailMessageIdToOldThreadId.put(em.Id, threadId);
                    }
                }
            }
            
            if (emailMessages.size() > 0) {
                //Initialize Setting Item record
                Map<Id, Case> mapOldIdToNewCase = new Map<Id, Case>();
                system.debug('JEFF: mapEmailMessageIdToOldOrgCaseId.values() = ' + mapEmailMessageIdToOldOrgCaseId.values());
                
                List<Case> migratedCases = [SELECT Legacy_ID__c, Id, Owner.Email, CaseNumber, Subject
                                            FROM CASE
                                            WHERE Legacy_ID__c IN :mapEmailMessageIdToOldOrgCaseId.values()];
                
                for (Case cse : migratedCases) {
                    mapOldIdToNewCase.put(cse.Legacy_ID__c, cse);
                }
                
                if (mapOldIdToNewCase.size() > 0) {
                    List<Id> caseIdsToDelete = new List<Id>();
                   List<EmailMessage> emailsToInsert = new List<EmailMessage>();
                   //List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); // CHG0041736
                    for (EmailMessage em : emailMessages) {
                        Id oldOrgCaseId = mapEmailMessageIdToOldOrgCaseId.get(em.Id);
                        if (mapOldIdToNewCase.containsKey(oldOrgCaseId)) {
                            Case migratedCase = mapOldIdToNewCase.get(oldOrgCaseId);
                            system.debug('JEFF: em.ParentId = ' + em.ParentId);
                            
                            if (em.ParentId != null)
                                caseIdsToDelete.add(em.ParentId); //add Case Id to a list to delete
                            
                            system.debug('JEFF: em.ToAddress = ' + em.ToAddress);
                            system.debug('JEFF: em.ParentId = ' + em.ParentId);
                            system.debug('JEFF: em.Subject = ' + em.Subject);
                            
                            //Create new email (because changing the old email didn't work)
                            EmailMessage em2 = NEW EmailMessage();
                            em2.ToAddress = em.ToAddress;
                            em2.ParentId = migratedCase.Id;
                            String oldThreadId = mapEmailMessageIdToOldThreadId.get(em.Id);
                            String newThreadId = UserInfo.getOrganizationId().left(5)
                                + UserInfo.getOrganizationId().mid(11,4) + '._' 
                                + string.valueof(em2.ParentId).left(5)
                                + string.valueof(em2.ParentId).mid(9,6);
                            em2.Subject = em.Subject.Replace(oldThreadId, newThreadId);
                            em2.TextBody = em.TextBody;
                            em2.HtmlBody = em.HtmlBody;
                            em2.FromAddress = em.FromAddress;
                            em2.FromName = em.FromName;
                            em2.CcAddress = em.CcAddress;
                            em2.BccAddress = em.BccAddress;
                            em2.Status = '0';
                            em2.Incoming = true;
                            emailsToInsert.add(em2);
                            
                            system.debug('JEFF: em2.ToAddress = ' + em2.ToAddress);
                            system.debug('JEFF: em2.ParentId = ' + em2.ParentId);
                            system.debug('JEFF: em2.Subject = ' + em2.Subject);
                            
                            /* CHG0041736
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTreatTargetObjectAsRecipient(false);
                            mail.setToAddresses(new String[] {String.valueof(migratedCase.Owner.Email)});
                            mail.setReplyTo('noreply@Salesforce.com');
                            mail.setSenderDisplayName('Case Notification');
                            mail.setBccSender(false);
                            mail.setUseSignature(false);
                            mail.setSaveAsActivity(false);
                            mail.setSubject('New case email notification. Case number ' + migratedCase.CaseNumber);
                            String body = 'An email has been received for case '+ migratedCase.CaseNumber+': '+migratedCase.Subject+'.'+'<br>'; 
                            body +='<br>';
                            body += 'Please click the link below to review the new email and respond appropriately.'+'<br>';
                            body +='<br>';
                            body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + migratedCase.id +'<br>';
                            body +='<br>';
                            body += 'NOTE: It is not recommended that you forward this email because its association with the original case may be lost.'+'<br>';
                            mail.setHtmlBody(body);
                            //Only send an email message when the Case record type is not like CSD
                            if (String.valueof(migratedCase.Owner.Email) != null)
                                mailList.add(mail); 
							*/ //CHG0041736
                            
                        } 
							
                    }
                    //Attach new emails to existing cases
                    if (emailsToInsert.size() > 0)
                        insert emailsToInsert;
                    
                    /* CHG0041736
                    //Send the list of email messages   
                    if (mailList.size() > 0 && !Test.isRunningTest()) 
                        Messaging.sendEmail(mailList);
                    *///CHG0041736
                    
                    //Remove any cases which have been created as a result of email-to-case
                    system.debug('JEFF: caseIdsToDelete = ' + caseIdsToDelete);
                    if (caseIdsToDelete.size() > 0)
                        deleteCases(caseIdsToDelete);
                    //Database.delete(caseIdsToDelete, false);
                }
            }
        }
    }
    
    @future
    public static void deleteCases(List<Id> caseIdsToDelete)
    {
        system.debug('JEFF: caseIdsToDelete = ' + caseIdsToDelete);
        Database.delete(caseIdsToDelete, false);
    }
}