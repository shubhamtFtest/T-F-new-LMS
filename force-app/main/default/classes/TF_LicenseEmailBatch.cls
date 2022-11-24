/************************************************************************************
    //This batch class is to send email notification for intermediate license 
      status with more than 24 hours
    //Created by Vikas Varshney for UBXC-1544 on dated 26th May, 2021 //CHG0048117
    //Test coverage "zTest_TF_LicenseEmailBatch"
************************************************************************************/

global class TF_LicenseEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
    public List<License__c> finalLicenseList = new List<License__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime nowDate = System.now()-1;
        DateTime maxNowGMTDate = DateTime.newInstanceGmt(nowDate.dateGMT(), nowDate.timeGMT());
        DateTime minNowGMTDate = maxNowGMTDate.addDays(-1);
        
        String querrry = 'SELECT id, name, CreatedDate, LastModifiedDate FROM License__c WHERE Status__c = \'License created successfully, Entitlement Creation in progress\' AND LastModifiedDate >=: minNowGMTDate AND LastModifiedDate <=: maxNowGMTDate';
        return Database.getQueryLocator(querrry);
    }
    
    global void execute(Database.BatchableContext BC, List<License__c> licenseList) {
        if ( licenseList != Null ) {
            finalLicenseList.addAll(licenseList);
        }
        System.debug('Execute finalLicenseList =====>' + finalLicenseList);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Finish finalLicenseList =====>' + finalLicenseList);
        
        List<String> lstSendToEmails = new List<String>();
        String emailIds = '';
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        emailIds = (String) orgSpecificProps.get('EmailAddressForLicenseNotification__c');
        
        if ( String.isBlank(emailIds) ) {
            emailIds = 'vikas.c.varshney@informa.com';
        }
        lstSendToEmails = emailIds.split(',');
        
        Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
        objEmail.setToAddresses(lstSendToEmails);
        objEmail.setSubject('SFDC License not Active Notification');
        String htmlBody = 'Below licenses are not active in SFDC and having status as "License created successfully, Entitlement Creation in progress" :-<br/><br/><br/>';
        
        if ( !finalLicenseList.isEmpty() ) {
            htmlBody += '<table style="width:100%; border-collapse: collapse; text-align: center" border="1"><tr><th>License Id</th><th>License Name</th><th>CreatedDate</th><th>LastModifiedDate</th></tr>';
        }
        
        for (License__c lic : finalLicenseList) {
            htmlBody += '<tr><td>' + lic.id + '</td><td>' + lic.Name + '</td><td>' + lic.CreatedDate + '</td><td>' + lic.LastModifiedDate + '</td></tr>';
        }
        
        if ( !finalLicenseList.isEmpty() ) {
            htmlBody += '</table>';
        }
        
        objEmail.setHtmlBody(htmlBody);
        
        if(!Test.isRunningTest() && !finalLicenseList.isEmpty()) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{objEmail});
            if ( results[0].success ) {
                System.debug('********** Email sent successfully **********');
            } else {
                System.debug('********** Error in sending email **********');
            }
        }
    }
}