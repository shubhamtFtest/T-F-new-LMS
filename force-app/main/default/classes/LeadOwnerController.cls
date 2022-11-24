// Created by Jeff Lup - CHG0064280 - 2015.03.25
// Last Modified by Jeff Lup - WRQ0413143 - 2015.04.16

public with sharing class LeadOwnerController {
    private ApexPages.StandardController controller {get; set;}
    public final Lead lead;
    public Boolean showChangePage {get; set;}
    public String comments {get; set;} 
    public Boolean sendNotificationEmail {get; set;}
    public String currentOwnerName {get; set;}

    public LeadOwnerController(ApexPages.StandardController controller){
        this.controller = controller;
        this.lead = (Lead)controller.getRecord();
        currentOwnerName = lead.Owner.Name;
        lead.OwnerId = null;
        sendNotificationEmail = false;
        if (ApexPages.currentPage().getParameters().get('pg') == '2')
            showChangePage = true;
        else
            showChangePage = false;
    }

    public Pagereference save() {
        if (lead.OwnerId != null) {
            update lead;
            //if (sendNotificationEmail) {
            if (sendNotificationEmail && String.valueOf(lead.OwnerId).left(3) == '005') { //WRQ0413143
               String emailAddress = [SELECT Email FROM User WHERE Id = :lead.OwnerId].Email;
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {emailAddress});
                email.subject = 'Lead: ' + lead.Name + ' has been assigned to you.';
                String emailBody = '<html><body>';
                emailBody += 'Lead: ' + lead.Name + ', ' + lead.Company + ' has been assigned to you.';
                if (comments != null)
                    emailBody += '<br/><br/>' + comments.replace('\n','<br/>');
                emailBody += '<br/><br/>To view the details of this lead in salesforce.com click on the following link:';
                emailBody += '<br/><a href="' + URL.getSalesforceBaseUrl().toExternalForm().replace('http:','https:') + '/' + lead.Id + '">' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + lead.Id + '</a>';
                emailBody += '</body></html>';
                email.setHtmlBody(emailBody);
                emails.add(email);
                if (!Test.isRunningTest())
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
            }
        }
        return exitPage();
    }

    public PageReference exitPage() {
        PageReference page = new PageReference('/' + lead.id);  
        page.setRedirect(true);  
        return page;
    }
        
}