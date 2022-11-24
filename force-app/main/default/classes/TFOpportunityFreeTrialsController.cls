//Created by Hailey Niemand 2014.07.22 - CHG0059921

public with sharing class TFOpportunityFreeTrialsController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;
    
    public boolean isEditMode{get; set;}
    public boolean firstTrial {get; set;}
    public boolean secondTrial {get; set;}
    
    private datetime validStartDate = datetime.now().addDays(5);
    private datetime validEndDate = datetime.now().addDays(5);
        
    public String errorMessage {get; set;}
    public Boolean showErrorMessage {get; set;}
    
    public TFOpportunityFreeTrialsController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
        
        isEditMode = false;
        
        if (opp.Trial_ID__c == null || opp.Trial_ID__c == '')
            firstTrial = true;
        else 
            firstTrial = false;
        
        if (opp.Trial_ID__c != null && opp.Trial_ID__c != '' && (opp.Second_Trial_ID__c == null || opp.Second_Trial_ID__c == ''))
            secondTrial = true;
        else 
            secondTrial = false;
            
        errorMessage = '';
        showErrorMessage = false;
    }
    
    public PageReference refreshPage() {
        PageReference thisPage = ApexPages.CurrentPage();
        thisPage.setRedirect(true);
        return thisPage;
    }  
    
    public Pagereference initiateFirstTrial() {    
        List<OpportunityLineItem> feesProducts = [SELECT Id FROM OpportunityLineItem 
                                                  WHERE OpportunityId =: controller.getid() 
                                                  AND PricebookEntry.Product2.Service_Description__c != 'Subscription'];
                                                  
            if (feesProducts.size() > 0 && opp.Trial_Start__c >= validStartDate && opp.Trial_End__c >= validEndDate) {
                Product2 p = new Product2();
                p.Name = 'trial';
                insert p;
                opp.Trial_Id__c = p.Id;
                opp.Trial_Initiated_Date__c = Date.today();
                update opp;
                delete p;
              //  return refreshPage();
              firstTrial=false;
              secondTrial=true;
                return null;
                
            } else {    
                    
            if (feesProducts.size() == 0)
                errorMessage += '• Your opportunity must have at least 1 Fee product.<br/>';
            if (opp.Trial_Start__c < validStartDate || opp.Trial_Start__c == null)
                errorMessage += '• You must supply a Trial Start Date which is at least five days in the future.<br/>';
            if (opp.Trial_End__c < validEndDate || opp.Trial_End__c == null)
                errorMessage += '• You must supply a Trial End Date which is at least five days in the future.<br/>';
            
            if (errorMessage != '') {
                errorMessage = 'Please correct the following before proceeding:<br/><br/>' + errorMessage;
                showErrorMessage = true;
            }
            
            return null;
       }
    }
    
    public Pagereference initiateSecondTrial() {
        List<OpportunityLineItem> feesProducts = [SELECT Id FROM OpportunityLineItem 
                                                  WHERE OpportunityId =: controller.getid() 
                                                  AND PricebookEntry.Product2.Service_Description__c != 'Subscription'];
                                                  
        if (feesProducts.size() > 0 && opp.Second_Trial_Start__c >= validStartDate && opp.Second_Trial_End__c >= validEndDate) {
            Product2 p = new Product2();
            p.Name = 'trial';
            insert p;
            opp.Second_Trial_Id__c = p.Id;
            opp.Second_Trial_Initiated_Date__c = Date.today();
            update opp;
            delete p;
            firstTrial=false;
            secondTrial=false;
           //return refreshPage();
           return null;
            
            
        } else {
            if (feesProducts.size() == 0)
                errorMessage += '• Your opportunity must have at least 1 Fee product.<br/>';
            if (opp.Second_Trial_Start__c < validStartDate || opp.Second_Trial_Start__c == null)
                errorMessage += '• You must supply a Second Trial Start Date which is at least five days in the future.<br/>';
            if (opp.Second_Trial_End__c < validEndDate || opp.Second_Trial_End__c == null)
                errorMessage += '• You must supply a Second Trial End Date which is at least five days in the future.<br/>';
                
            if (errorMessage != '') {
                errorMessage = 'Please correct the following before proceeding:<br/><br/>' + errorMessage;
                showErrorMessage = true;
            }
            return null;
       }
    }
    
    public Pagereference doEdit() {
        if (isEditMode == false)
            isEditMode = true;
        return null;
    }
    
    public Pagereference doSave() {
        errorMessage = '';
        if (opp.Trial_End__c < opp.Trial_Start__c || opp.Second_Trial_End__c < opp.Second_Trial_Start__c)
            errorMessage += '• A Trial End Date cannot be before a Trial Start Date.<br/>';    
        if (opp.Trial_ID__c != '' && opp.Trial_ID__c != null && opp.Trial_Initiated_Date__c != null && opp.Trial_Initiated_Date__c.addDays(5) > opp.Trial_Start__c)
            errorMessage += '• You must supply a Trial Start Date and Trial End Date which are at least five days from the date the First Trial was initiated: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Trial_Initiated_Date__c) + '<br/>';
        if (opp.Second_Trial_ID__c != '' && opp.Second_Trial_ID__c != null && opp.Second_Trial_Initiated_Date__c != null && opp.Second_Trial_Initiated_Date__c.addDays(5) > opp.Second_Trial_Start__c)
            errorMessage += '• You must supply a Second Trial Start Date and Second Trial End Date which are at least five days from the date the Second Trial was initiated: ' + MiscFunctions.convertDateToString_MMM_d_yyyy(opp.Second_Trial_Initiated_Date__c) + '<br/>';             
        if (errorMessage != '') {
            errorMessage = 'Please correct the following before proceeding:<br/><br/>' + errorMessage;
            showErrorMessage = true;
            return null;
        } else
            update opp;  
            //return refreshPage(); 
        isEditMode=false;
          return null;
        } 
    
    public Pagereference doCancel() {
          isEditMode = false;
       // return refreshPage();
       return null;
    }  
}