//Class: OppRenewalPrompt_TFeBooksController.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Shefali Arora on 2020.01.09,  Jira Ticket SAL-1308

public with sharing class OppRenewalPrompt_TFeBooksController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;

    public OppRenewalPrompt_TFeBooksController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
    
    public Boolean getShowPrompt() {
        //Date goliveDate = TF_ERN_Settings__c.getOrgDefaults().Go_Live_Date__c;
        //if (opp.CloseDate >= goliveDate && opp.Type == 'New Business' && opp.Order_Type__c != 'Gratis' && opp.Order_Type__c != 'Trial' && opp.StageName == 'Closed Won' && opp.Next_Renewal__c == null && opp.Reason_No_Renewal__c == NULL)
        if (opp.StageName == 'Closed Won' && opp.Next_Renewal__c == null && opp.Opportunity_for_Renewal__c == 'Yes' && opp.Type == 'New Business' && opp.Order_Type__c != 'Gratis' && opp.Order_Type__c != 'Trial')
        	return true;
        else
        	return false;
    }
}