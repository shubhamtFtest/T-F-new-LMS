/*
CHG0049990 - Hailey Niemand 02.05.2013: added oli currency field
INC0929069 - Hailey Niemand 28.05.2013: Replaced field pse__Parent_Opportunity__c with Parent_Opportunty__c 
CHG0061310 - Hailey Niemand 07.10.2014: Free Trial fields
*/

public class TFClosedWonNotificationController {
    public Opportunity OpportunityObj {get;set;}
    public string trialStartDate {get;set;}
    public string trialEndDate {get;set;}
    public string secondTrialStartDate {get;set;}
    public string secondTrialEndDate {get;set;}
        
    private Opportunity oOpportunity;
    public Opportunity getOpp(){
        if (oOpportunity == null)
            oOpportunity = [SELECT Id, Name, Owner.Name, Account.Name, Type, Volume_Year__c,
                                Parent_Opportunty__r.Name, Amount_USD__c, //pse__Parent_Opportunity__c , INC0929069
                                Trial_Start__c, Trial_End__c, 
                                //CHG0061310 
                                Trial_ID__c, Trial_Initiated_Date__c, Second_Trial_Start__c, 
                                Second_Trial_End__c, Second_Trial_ID__c, Second_Trial_Initiated_Date__c
                           FROM Opportunity
                           WHERE Id = :OpportunityObj.Id];
                           
        trialStartDate = MiscFunctions.convertDateToString_d_MMM_yy(oOpportunity.Trial_Start__c);
        trialEndDate = MiscFunctions.convertDateToString_d_MMM_yy(oOpportunity.Trial_End__c);
        secondTrialStartDate = MiscFunctions.convertDateToString_d_MMM_yy(oOpportunity.Second_Trial_Start__c);
        secondTrialEndDate = MiscFunctions.convertDateToString_d_MMM_yy(oOpportunity.Second_Trial_End__c);
        
        return oOpportunity;        
    }
    
    private List<OpportunityLineItem> oOlis;
    public List<OpportunityLineItem> getOlis(){
        if (oOpportunity == null) 
            oOpportunity = getOpp();
        if (oOlis == null)
            oOlis = [SELECT Id, ProductName__c, TotalPrice, Net_Price__c, CurrencyIsoCode
                           FROM OpportunityLineItem
                           WHERE OpportunityId = :oOpportunity.Id];
        return oOlis;       
    }
    
    public OpportunityLineItem getFirstOli(){
        return oOlis[0];
    }

    private Contact oPrimaryContact;
    public Contact getPrimaryContact(){
        if (oOpportunity == null) 
            oOpportunity = getOpp();
        if (oPrimaryContact == null) {
            List<OpportunityContactRole> ocrs = [SELECT Contact.Name, Contact.Account.Name,
                                Contact.Phone, Contact.Email, Contact.MailingStreet,
                                Contact.MailingCity, Contact.MailingState,
                                Contact.MailingPostalCode, Contact.MailingCountry
                           FROM OpportunityContactRole
                           WHERE OpportunityId = :oOpportunity.Id
                                AND IsPrimary = true];
            if (ocrs.size() > 0)
                oPrimaryContact = ocrs[0].Contact;
            else
                oPrimaryContact = new Contact();
        }
        return oPrimaryContact;     
    }
    
    public String getOppURL() {
        if (oOpportunity == null) 
            oOpportunity = getOpp();
        return system.url.getSalesforceBaseUrl().toExternalForm() + '/' + oOpportunity.Id;
    }
    
    //CHG0061310 
    public boolean firstTrial {
        get{
            if ((oOpportunity.Second_Trial_ID__c == null || oOpportunity.Second_Trial_ID__c == '') && oOpportunity.Trial_ID__c != null && oOpportunity.Trial_ID__c != '')
                firstTrial = true;
            else
                firstTrial = false;
                
            return firstTrial;
        }
        set;
    }
}