//Class: OppRenewalPromptTFHomePageController.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
// Modified by Avi - 2017.08.03 CHG0036607

public with sharing class OppRenewalPromptTFHomePageController {

    public String oppId {get;set;}

    public OppRenewalPromptTFHomePageController() {
        oppId = '';
        List<Opportunity> opps;
        //First look for Journals Opps
        //Recordtypes: 'T&F Journals Consortium Opportunity (Direct)', 'T&F Journals Customer Opportunity (Direct)', 'T&F Journals Consortium Opportunity (Price Agreement)'
        opps = [SELECT Id
                FROM Opportunity
                WHERE Opportunity.OwnerId = :Userinfo.getUserId()
                    //AND RecordtypeId IN ('01260000000J08eAAC','01260000000J08dAAC','01260000000J08fAAC')
                    AND RecordtypeId IN ('0120Y000000Wn9VQAS','0120Y000000Wn8TQAS','0120Y000000Wn9WQAS')
                    AND StageName = 'Closed Won'
                    AND Next_Renewal__c = NULL
                    AND Reason_No_Renewal__c = NULL
                    AND Volume_Year__c > '2014' //Go live year
                    AND Id not in :NonRenewalProduct() //CHG0036607
                    LIMIT 1];
        if (opps.size() > 0) {
            oppId = opps[0].Id;
        } else {
            //Then look for eBooks Opps
            //Recordtypes: 'T&F eBooks Consortium Opportunity (Direct)', 'T&F eBooks Consortium Opportunity (Price Agreement)', 'T&F eBooks Customer Opportunity (Direct)'
            Date goliveDate = TF_ERN_Settings__c.getOrgDefaults().Go_Live_Date__c;
            opps = [SELECT Id
                    FROM Opportunity
                    WHERE OwnerId = :Userinfo.getUserId()
                        //AND RecordtypeId IN ('01260000000J2hoAAC','01260000000J2hpAAC','01260000000J2hnAAC')
                        AND RecordtypeId IN ('0120Y000000Wn9YQAS','0120Y000000Wn9ZQAS','0120Y000000Wn8YQAS')
                        AND StageName = 'Closed Won'
                        AND Next_Renewal__c = NULL
                        AND Reason_No_Renewal__c = NULL
                        AND Type = 'New Business'
                        AND Order_Type__c != 'Gratis'
                        AND Order_Type__c != 'Trial'
                        AND CloseDate >= :goliveDate
                    LIMIT 1];
            if (opps.size() > 0)
                oppId = opps[0].Id;
        }
    }
    
    //CHG0036607
    public Set<Id> NonRenewalProduct(){
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem oppItems :[SELECT OpportunityId FROM OpportunityLineItem WHERE Opportunity.OwnerId = :Userinfo.getUserId()
                                            //AND Opportunity.RecordtypeId IN ('01260000000J08eAAC','01260000000J08dAAC','01260000000J08fAAC')
                                            AND Opportunity.RecordtypeId IN ('0120Y000000Wn9VQAS','0120Y000000Wn8TQAS','0120Y000000Wn9WQAS')
                                            AND Opportunity.StageName = 'Closed Won' AND Opportunity.Next_Renewal__c = NULL AND Opportunity.Reason_No_Renewal__c = NULL
                                            AND Opportunity.Volume_Year__c > '2014' //Go live year
                                           AND PriceBookEntry.Product2.Family In('Digital Products','Classic Archive','Classic Archive Upgrade','Modern Archive','Modern Archive Upgrade')]){
            oppIds.add(oppItems.OpportunityId);
        }
       return oppIds;                                                                                
    }
        
}