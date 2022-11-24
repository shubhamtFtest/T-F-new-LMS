/* 
 Created by Jeff Lup on 2014.04.08, for TF Journals, CHG0057797
 Modified By Shefali Arora - 2020.01.29 (Jira Ticket SAL-1307)
 Modified By Matthew Smith - 2020.12.21 (Case: 01719383)
 Modified By Matthew Smith - 2022.01.20 (GRQ0253085) - Updating Non Renewal Products
*/

public with sharing class OppRenewalPrompt_TFJournalsController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;

    public OppRenewalPrompt_TFJournalsController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
    
    public Boolean getShowPrompt() {
        Integer yyyy = 0;
        Integer revisit_year =0;
        
        if(opp.ReVisit_date__c !=null)
            revisit_year = opp.ReVisit_date__c.year();
        
        if (opp.Volume_Year__c != null && opp.Volume_Year__c.isNumericSpace())
            yyyy = integer.valueOf(opp.Volume_Year__c);
        
        
        //if (yyyy >= 2015 && opp.StageName == 'Closed Won' && opp.Next_Renewal__c == null && opp.Reason_No_Renewal__c == NULL && IsNonRenewalProduct(opp.Id))
        if(opp.StageName == 'Closed Won' && opp.Opportunity_for_Renewal__c == 'Yes' && opp.Next_Renewal__c == null && IsNonRenewalProduct(opp.Id)) {
            return true;
        }
        else if(opp.StageName == 'Investigating' && revisit_year >yyyy && IsDigitalProduct(opp.Id) && opp.Next_Renewal__c == null && opp.Reason_No_Renewal__c == NULL){
                return true;
            }
            
        else
            return false;
        
        /*if(opp.StageName == 'Closed Won' && opp.Opportunity_for_Renewal__c == 'Yes' && opp.Next_Renewal__c == null) {
            return true;
        }
        else
            return false;*/
    }
    
    public Boolean IsDigitalProduct(String oppId){
        
        List<OpportunityLineItem> oppItems =[Select Id from OpportunityLineITem 
                                                where OpportunityId=:oppId and PriceBookEntry.Product2.Family='Digital Products'];
        if(oppItems !=null && oppItems.size() >0){
            return true;
        }               
        else{
            return false;
        }                                 
                                                        
    }
    public Boolean IsNonRenewalProduct(String oppId){
        
        List<OpportunityLineItem> oppItems =[Select Id from OpportunityLineITem 
                                                where OpportunityId=:oppId and PriceBookEntry.Product2.Family In('Digital Products','Classic Archive','Classic Archive Upgrade','Modern Archive','Modern Archive Upgrade') AND (NOT PriceBookEntry.Product2.Name LIKE '%Annual%') AND (NOT PriceBookEntry.Product2.Name LIKE '%Maintenance%') AND (NOT PriceBookEntry.Product2.Name = 'DATA MINING SERVICE FEE')];
        if(oppItems !=null && oppItems.size() >0){
            return false;
        }               
        else{
            return true;
        }                                                                                 
    }
}