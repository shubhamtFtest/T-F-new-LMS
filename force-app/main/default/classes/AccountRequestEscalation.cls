/**************************************************
* Created by Jeff Lup, 2018.07.09
* Tested By zTest_AccountRequestEscalation @ 95%
//Updated by : Ashish Purwar to send email only if approver had not added any comments on line number 12
**************************************************/
global class AccountRequestEscalation implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Id requestRT = MiscFunctions.getRecordtypeId('Account', 'Account Request');
        Map<Id, Account> accountRequests = new Map<Id, Account>([SELECT Id, Name, CreatedDate
                                                                 FROM Account
                                                                 WHERE RecordtypeId = :requestRT
                                                                 AND Account_Status__c = 'Submit for Approval' AND Reason_for_delay_in_approval__c=NULL]);//Added  extra condition to see if comment is there or not.
        
        List<ProcessInstance> submissions = [SELECT CreatedDate, TargetObjectId
                                             FROM ProcessInstance
                                             WHERE TargetObjectId IN :accountRequests.keySet()
                                             ORDER BY TargetObjectId, CreatedDate]; //sorting on oldest first, so that newest date per account is used below
        
        Map<Id, DateTime> mapAccountToSubmissionDate = new Map<Id, DateTime>();
        for (ProcessInstance submission : submissions) {
            mapAccountToSubmissionDate.put(submission.TargetObjectId, submission.CreatedDate); 
        }
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        Setting_Item__c settingItem  = [SELECT Text_1__c, Text_2__c
                                        FROM Setting_Item__c
                                        WHERE Setting__r.Name =: 'Account Approval Process' LIMIT 1];
        
        Integer hourThreshold = Integer.ValueOf(settingItem.Text_1__c);
        String emailTo = String.ValueOf(settingItem.Text_2__c);
        
		system.debug('JEFF: hourThreshold = ' + hourThreshold);
		system.debug('JEFF: emailTo = ' + emailTo);        
        
        for (Account a: accountRequests.values()) {
            if (mapAccountToSubmissionDate.containsKey(a.Id)) {
                system.debug('JEFF: Account Id = ' + a.Id);
                if (workingHoursExpired(mapAccountToSubmissionDate.get(a.Id), hourThreshold) || test.isRunningTest()) {
                    //Time has expired, so send an email to Talie, Alex, and Sarah (they are Tier 2)
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email = new Messaging.SingleEmailMessage();
                    String[] toAddresses = emailTo.split(';',-1);
                    email.setToAddresses(toAddresses);
                    email.setSubject('Account Request Tier 2 Escalation');
                    String accountUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/'+a.Id;
                    email.setPlainTextBody('The following Account Request has expired, and is therefore being raised to Tier 2 support for your approval:\r\n\r\n' + a.Name + '\r\n' + accountUrl);
                    system.debug('JEFF: add to email list');
                    emails.add(email);
                }    
            }
        }
        //send emails
        if (emails.size() > 0 && !test.isRunningTest()) {
            Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(emails, false);
            system.debug('JEFF: sendEmailResults = ' + sendEmailResults);
        } else {
            system.debug('JEFF: nothing to escalate');   
        }
    }
    
    static boolean workingHoursExpired(datetime startDateTime, integer hourThreshold) {       
        //9GMT through 22GMT (only count UK and US working hours)   
        //ignore weekends
        
        boolean exitLoop = false;
        integer runningDiff = 0;
        integer h = 0;
        datetime thresholdDateTime;
        
        //Calculate thresholdDateTime (when the request should be escellated to Tier 2)
        do {
            h++; //add an hour to our loop
            system.debug('JEFF: h ' + h);
            thresholdDateTime = startDateTime.addHours(h);
            system.debug('JEFF: thresholdDateTime (running) = ' + thresholdDateTime);
            system.debug('JEFF: thresholdDateTime.hourGmt() = ' + thresholdDateTime.hourGmt());
            
            if (thresholdDateTime.hourGmt() >= 9 && thresholdDateTime.hourGmt() < 22) { //is between 9am GMT and 10pm GMT (US 5pm)
                String dayOfWeek = thresholdDateTime.format('E');
                if (dayOfWeek != 'Sat' && dayOfWeek != 'Sun') { //is not during the weekend
                    runningDiff++;
                    system.debug('JEFF: within working hours, so add an hour to running Diff');
                    system.debug('JEFF: runningDiff ' + runningDiff);
                }
            }
            if (runningDiff >= hourThreshold)
                exitLoop = true;
            
        } while (!exitLoop);
        
        //See if we are past the threshold
		system.debug('JEFF: thresholdDateTime ' + thresholdDateTime);
        system.debug('JEFF: system.now() ' + system.now());
        if (system.now() >= thresholdDateTime)
            return true;
        else
            return false;
    }
}