/* Tested by: zTEST_EmailPreferenceController    100%
*
* Created by Jeff Lup - 2017.09.27
* Updated by Jeff Lup - 2017.11.14 - CHG0039473 - replace ' with | (per Marketing Cloud issue)
*/
public with sharing class EmailPreferenceController {
    
    public final Email_Preference__c emailPreference {get; set;}
    
    public Id leadId {get; set;}
    public Id contactId {get; set;}
    public String email {get; set;}
    public Boolean showErrorMessage {get; set;}
    public String errorMessage {get; set;}
    private Boolean newRecord = false;
    
    public Boolean showCurrentStatus {get; set;}
    public Boolean showCurrentReason {get; set;}
    public String currentStatus {get; set;}
    public String currentReason {get; set;}
    
    public EmailPreferenceController(){
        showErrorMessage = false;
        
        leadId = ApexPages.currentPage().getParameters().get('lId');
        contactId = ApexPages.currentPage().getParameters().get('cId');
        email = ApexPages.currentPage().getParameters().get('email');
        
        if (email != null && email.trim() != '') {
            List<Email_Preference__c> emailPreferences = [SELECT Id, Email__c, Reason__c, Salesforce_User__c, Source__c, Status__c, Status_Date__c
                                    FROM Email_Preference__c
                                    WHERE Email__c = :email
                                      OR Email__c = :email.replace('\'','|')]; //CHG0039473
                
            if (emailPreferences.size() == 0) {
                this.emailPreference = new Email_Preference__c();
                this.emailPreference.Email__c = email;
                showCurrentStatus = false;
                showCurrentReason = false;
                newRecord = true;
            } else {
                this.emailPreference = emailPreferences[0];
                this.emailPreference.Email__c = email; //CHG0039473
                currentStatus = emailPreference.Status__c;
                if (emailPreference.Reason__c != null)
                  currentReason = (emailPreference.Reason__c).replaceAll('\n','<br>');
                emailPreference.Status__c = null;
                emailPreference.Reason__c = null;
                showCurrentStatus = (currentStatus != null ? true : false);
                showCurrentReason = (currentReason != null ? true : false);
            }
            getLeadsAndContacts();
        } else {
            this.emailPreference = new Email_Preference__c();
            errorMessage = 'Email address not specified';
            showErrorMessage = true;
        }
    }
    
    public PageReference cancelUpdate() {
        return exitPage();
    }
    
    public PageReference updatePreference() {
        emailPreference.Salesforce_User__c = UserInfo.getUserId();
        emailPreference.Source__c = (emailPreference.Status__c == 'Unsubscribed' ? 'Manual Salesforce Unsubscribe' : 'Manual Salesforce Re-subscribe');
        emailPreference.Status_Date__c = datetime.now();
        
        //CHG0039473
        if (email.contains('\''))
            emailPreference.Email__c = email.replace('\'','|');
        
        //We just need to save the Preference, the trigger will take care of updating the Leads and Contacts
        if (newRecord) {
            if (emailPreference.Status__c == 'Unsubscribed')
                insert emailPreference;
        } else {
            update emailPreference;
        }
        return exitPage();
    }
    
    public PageReference exitPage() {
        if (leadId != null || contactId != null) {
            PageReference page = new PageReference('/' + (contactId != null ? contactId : leadId)); 
            page.setRedirect(true); 
            return page;
        } else {
            return null;
        }
    }
    
    private void getLeadsAndContacts() {
        Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        Id contactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        Id oacContactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - OAC Contacts'); //CHG0038379
        Set<Id> setContactIds = new Set<Id>();
        setContactIds.add(contactRtId);
        setContactIds.add(oacContactRtId);
        
      List<Lead> leads = [SELECT Id, Name, Phone, Country, Company, HasOptedOutOfEmail
                            FROM Lead
                            WHERE Email = :email
                               AND RecordtypeId = :leadRtId AND isConverted=false];
      List<Contact> contacts = [SELECT Id, Name, Account.Name, Phone, Mailing_Country_List__c, HasOptedOutOfEmail, optin_optout_status__c, optin_optout_source__c
                                  FROM Contact
                                  WHERE Email = :email
                                   AND RecordtypeId IN :setContactIds];
        for (Lead l : leads) {
            LeadContactWrapper w = new LeadContactWrapper();
            w.personType = 'Lead';
      w.personId = l.Id;
            w.personName = l.Name;
            w.company = l.Company;
            w.personPhone = l.Phone;
            w.personCountry = l.Country;
            w.doNotEmail = l.HasOptedOutOfEmail;
            listLeadsAndContacts.add(w);
        }
        for (Contact c : contacts) {
            LeadContactWrapper w = new LeadContactWrapper();
            w.personType = 'Contact';
            w.personId = c.Id;
            w.personName = c.Name;
            w.company = c.Account.Name;
            w.personPhone = c.Phone;
            w.personCountry = c.Mailing_Country_List__c;
            w.doNotEmail = c.HasOptedOutOfEmail;
            w.optin_optout_status = c.optin_optout_status__c;
            w.optin_optout_source = c.optin_optout_source__c;
            listLeadsAndContacts.add(w);
        }        
    }
    
    //List of Custom Type to contain Lead(s) & Contact(s)
    public List<LeadContactWrapper> listLeadsAndContacts { 
        get 
        { 
            if (listLeadsAndContacts == null) 
                listLeadsAndContacts = new List<LeadContactWrapper>(); 
            return listLeadsAndContacts; 
        } 
        set; 
    }
    
    public class LeadContactWrapper {
        public Id personId { get; set; }
        public String personType { get; set; }
        public String personName { get; set; }
        public String company { get; set; }
        public String personPhone { get; set; }
        public String personCountry { get; set; }
        public Boolean doNotEmail { get; set; }
        public String optin_optout_status { get; set; }
        public String optin_optout_source { get; set; }
    }
}