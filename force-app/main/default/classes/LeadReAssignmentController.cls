//Modified by Jeff Lup - 2017.07.17 - CHG0036218 - switched org url to informa.my

public class LeadReAssignmentController {

    public static final String SALESFORCE_URL = 'https:taylorandfrancis.my.salesforce.com/';
    public static final String SITES_URL = 'http://taylorandfrancis.force.com/';
    public Lead lead {get; set;}
    public User owner {get; set;}
    public String status {get; set;}
        
    public LeadReAssignmentController () {
    }
    
    public void init(){
        String leadId  = ApexPages.currentPage().getParameters().get('leadId');
        String ownerId = ApexPages.currentPage().getParameters().get('ownerId');
        status = ApexPages.currentPage().getParameters().get('status');
        
        if (leadId != null && ownerId != null){
            for (Lead l : [SELECT Id, Name, Company, Title, Phone, Email FROM Lead WHERE Id = :leadId])
                lead = l;
            for (User u : [SELECT Id, Name FROM User WHERE Id = :ownerId])
                owner = u;
            if (lead!=null && owner!=null)    
                assign(leadId, ownerId);
        } else if (leadId != null && status != null) {
            for (Lead l : [SELECT Id, Name, Company, Title, Phone, Email FROM Lead WHERE Id = :leadId])
                lead = l;
            if (lead!=null)
                updateLead(leadId, status);
        }
    }
    
    public Boolean getDontRenderLead(){
        return lead == null || (owner == null && status == null);
    }

    public Boolean getRenderLead_Assign(){
        return lead != null && owner != null;
    }

    public Boolean getRenderLead_Update(){
        return lead != null && status != null;
    }
    
    public String getLeadUrl(){
        return SALESFORCE_URL + lead.Id;
    }
    
    @future
    public static void updateLead(String leadId, String status){
        //Update Lead
        Lead lead = [SELECT Id, Name, Company, Status, //Reason_Closed__c,
                     	Reason_Disqualified__c FROM Lead WHERE Id =:leadId];
        if (status == 'Disqualified - Incorrect Info') {
            lead.Status = 'Disqualified';
            lead.Reason_Disqualified__c = 'Incorrect Info';
        } else if (status == 'Disqualified - Not Relevant') {
            lead.Status = 'Disqualified';
            lead.Reason_Disqualified__c = 'Not Relevant';
        } else if (status == 'Closed - Just Curious') {
            lead.Status = 'Closed';
            //lead.Reason_Closed__c = 'Just Curious';
        } else if (status == 'Closed - No Interest') {
            lead.Status = 'Closed';
            //lead.Reason_Closed__c = 'No Interest';
        } else {
            lead.Status = status;
        }
        update lead;
    }
    
    @future
    public static void assign(String leadId, String ownerId){
        //Reassign
        Lead lead = [SELECT Id, Name, Company, Title, Phone, Email, OwnerId, Owner.Name FROM Lead WHERE Id =:leadId];
        String oldOwnerId = lead.OwnerId;
        String oldOwnerName = lead.Owner.Name;
        lead.OwnerId = ownerId;
        update lead;
        
        //SendUserEmail
        User owner = [SELECT Id, Name, FirstName, Email FROM User WHERE Id = :ownerId];
        string leadCompany = '';
        if (lead.Company != null)
            leadCompany = lead.Company;
        string leadTitle = '';
        if (lead.Title != null)
            leadTitle = lead.Title;
        string leadPhone = '';
        if (lead.Phone != null)
            leadPhone = lead.Phone;
        string leadEmail = '';
        if (lead.Email != null)
            leadEmail = lead.Email;
        Messaging.SingleEmailMessage[] aSingleEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('New Lead');
                
        email.setHtmlBody('<html><body>Dear ' + owner.FirstName + ',<br><br>'
        + oldOwnerName + ' has assigned you the following lead:<br><br>'
        + '<p style="font-size:16px;">'
        + '<strong>Name: </strong><a href="' + SALESFORCE_URL + lead.Id + '">' + lead.Name + '</a><br/>'
        + '<strong>Company: </strong>' + leadCompany + '<br/>'
        + '<strong>Title: </strong>' + leadTitle + '<br/>'
        + '<strong>Phone: </strong>' + leadPhone + '<br/>'
        + '<strong>Email: </strong>' + leadEmail + '<br/><br/>'
        + '<div style="padding: 10px; font-size: 20px; font-weight: bold; text-align: center; text-shadow: rgba(0, 0, 0, 0.6) 0px -1px 0; text-overflow: ellipsis; color: #FFFFFF; background: #6d84a2; border-bottom: 1px solid #2d3642;">'
        + 'Update Lead Status'
        + '</div>'
        + '<ul style="margin: 0; padding: 0;">'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Attempting to Contact">Attempting to Contact</a>'
        + '    </li>'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Working">Working</a>'
        + '    </li>'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Disqualified - Incorrect Info">Disqualified - Incorrect Info</a>'
        + '    </li>'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Disqualified - Not Relevant">Disqualified - Not Relevant</a>'
        + '    </li>'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Closed - Just Curious">Closed - Just Curious</a>'
        + '    </li>'
        + '    <li style="list-style: none; margin: 0; padding: 0; border-bottom: 1px solid #E0E0E0; font-size: 20px; font-weight: bold;">'
        + '        <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&status=Closed - No Interest">Closed - No Interest</a>'
        + '    </li>'
        + '</ul><br><br>'
        + 'or <a style="display: block; padding: 8px 32px 8px 8px; text-decoration: none;font-weight: bold;font-size: 16px;" href="' + SITES_URL + '/LeadReAssignment?leadId=' + lead.Id + '&ownerId=' + oldOwnerId + '">Click Here</a> to ReAssign back to ' + oldOwnerName + '.');
        
        String[] emailToAddresses = new String[]{};
        emailToAddresses.add(owner.Email);
        email.setToAddresses(emailToAddresses);
        aSingleEmails.add(email);

        Messaging.Email[] aEmails = new List<Messaging.Email>();
        for(Integer k = 0; k < aSingleEmails.size(); k++) {
            aEmails.add(aSingleEmails.get(k));
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(aEmails);
    }
}