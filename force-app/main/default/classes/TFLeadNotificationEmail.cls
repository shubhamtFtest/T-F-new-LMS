/******************************************************
* 
* Created by Hailey Niemand - 2015.03.15 - CHG0064161 
* Modified by Hailey Niemand - 2015.09.02 - PRJ0013143 
*
* tested by zTEST_TFLeadNotificationEmail 94%
* 
******************************************************/

global class TFLeadNotificationEmail implements Schedulable {
    global void execute(SchedulableContext sc) {
        getLeadsByOwner();
    }
    
    public void getLeadsByOwner() {
        //Get Leads
        List<Lead> leads = [SELECT Id, OwnerId, Owner.FirstName, Owner.Name, Owner.Email, Name, Company,
                            Email, CreatedDate, LeadSource, Lead_Source_Description__c, Product_Name__r.Name,
                            Temperature__c, Promotion_Name__c, Days_Assigned__c
                            FROM Lead 
                            WHERE RecordTypeId = '0120Y000000Wn6XQAS' //T&F - Leads
                            AND IsConverted = false //Exclude Converted Leads
                            AND Status != 'Disqualified' //Exclude Disqualified leads
                            AND (Owner.Profile.Name LIKE 'T&F eBook%' OR Owner.Profile.Name LIKE 'T&F - Journal%'
                                OR Owner.Profile.Name LIKE 'T&F - CIS%')]; //Only Leads owned by T&F eBooks, T&F Journals and T&F - CIS users //PRJ0013143
        
        if (leads.size() > 0) {
            Map<ID, List<Lead>> leadsByOwner = new Map<Id, List<Lead>>();
            //if map already contains owner then add to list else create new list
            for (Lead l : leads) {
                if (leadsByOwner.containsKey(l.OwnerId)) {
                    List<Lead> tempLeads = leadsByOwner.get(l.OwnerId);
                    tempLeads.add(l);
                } else {
                    List<Lead> tempLeads = new List<Lead>();
                    tempLeads.add(l);
                    leadsByOwner.put(l.OwnerId, tempLeads);
                }
            }
            
            //get email message for the list of leads to send to each owner
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (ID ownerId : leadsByOwner.keySet()) {
                emails.add(getEmailMessage(leadsByOwner.get(ownerId)));
            }
            sendEmails(emails);
        }
    }
    
    public Messaging.SingleEmailMessage getEmailMessage(List<Lead> leads) {
        //Lead to use for Owner Information - each lead in list contains the same Owner information
        Lead firstLead = leads.get(0);
        
        //Compose message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {firstLead.Owner.Email});
        email.setOrgWideEmailAddressId('0D20Y000000L2Eh'); //No Reply (do_not_reply.sfdc@informausa.com)
        email.setSubject('You have open Leads');
        String name = firstLead.Owner.FirstName != null ? firstLead.Owner.FirstName : firstLead.Owner.Name;
        email.setHtmlBody('<html>'
                          + '<style type="text/css"> body{font-family: Calibri; font-size: 11pt;}th{text-align: left;}</style>'
                          + '<body>Hi ' + name + ',<br><br>'
                          + 'You currently have ' + string.valueOf(leads.size()) + ' open Leads on Salesforce.com:<br><br>'
                          + formatLeadsAsHTMLTable(leads)
                          + '<br><br>Please either convert these Leads to Opportunities, or move them to ‘Disqualified’ status.'
                          + '</body></html>');
        return email;
    }
    
    //Create html table of leads
    public string formatLeadsAsHTMLTable(List<Lead> leads){
        string html = '';
        html += '<table cellpadding="3" >';
        html += '<tr ><th>Name</th><th>Company</th><th>Email</th><th>Lead Source</th><th>Lead Source Description</th><th>Product Name</th><th>Temperature</th><th>Promotion Name</th><th>DaysAssigned</th></tr>';
        for(Lead l : leads){
            html +='<tr><td><a href="https://informa.my.salesforce.com/' + l.Id + '">' + l.Name + '</a></td><td>' + l.Company + '</td><td>' + (l.Email != null ? l.Email : '') + '</td><td>' + (l.LeadSource != null ? l.LeadSource : '') + '</td><td>' + (l.Lead_Source_Description__c != null ? l.Lead_Source_Description__c : '') + '</td><td>' + (l.Product_Name__r.Name != null ? l.Product_Name__r.Name : '') +'</td><td>' + l.Temperature__c + '</td><td>' + (l.Promotion_Name__c != null ? l.Promotion_Name__c : '') + '</td><td>' + l.Days_Assigned__c + '</td></tr>';
        }
        html += '</table>';
        return html;
    }
    
    //send the emails
    public void sendEmails(List<Messaging.SingleEmailMessage> emails) {
        //if Production and tests aren't running
        if (UserInfo.getOrganizationId()  == '00D0Y0000035Iji' && !Test.isRunningTest()) {
            if (emails.size() > 0)
                Messaging.sendEmail(emails);
        }
    }
}