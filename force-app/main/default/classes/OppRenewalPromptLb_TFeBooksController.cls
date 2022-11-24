//Class: OppRenewalPromptLb_TFeBooksController.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Shefali Arora on 2020.01.09,  Jira Ticket SAL-1308

public with sharing class OppRenewalPromptLb_TFeBooksController {
    private Opportunity opp;
    
    public Id oppId { get { return opp.Id;} set; }
    public Id renewalId { get; set; }
    public String reasonForNoRenewal { get; set; }  
    public String oldStage { get; set; }
    public Boolean showOldStage { get; set; }
    
    public OppRenewalPromptLb_TFeBooksController(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord();
        
        List<OpportunityFieldHistory> ofh = [SELECT OldValue
                                             FROM OpportunityFieldHistory
                                             WHERE OpportunityId = :opp.Id
                                                AND Field = 'StageName'
                                             ORDER BY CreatedDate DESC
                                             LIMIT 1];
        if (ofh.size() > 0) {
            oldStage = (String)ofh[0].OldValue;
            showOldStage = true;
        } else {
            showOldStage = false;
        }
    }
    
    public Pagereference yesRenewal() {
    	renewalId = OppRenewalTFeBooks.renewOpp(opp.Id);
            PageReference pageRef = new PageReference('/'+renewalId);
            return pageRef;
    }

    public Pagereference noRenewal() {
        if (reasonForNoRenewal != null && reasonForNoRenewal != '') {
            opp.Reason_No_Renewal__c = reasonForNoRenewal;
            update opp;
        }
        return null;
    }

    public Pagereference cancelClosedWon() {
        opp.StageName = oldStage;
        update opp;
        return null;
    }
}