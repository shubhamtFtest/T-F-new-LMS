/*
*
* Created by Hailey Niemand - 2014.01.20
* Modified by Hailey Niemand - 2014.09.17 - CHG0061269 - allow removal of Parent Opp
* Modified by Jeff Lup - 2016.03.28 - CHG0072245 - Errors on New Opportunity in Lightning
*
*/

public class TFOpportunityParentOpportunityController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity obj;
    private map<String, Opportunity> poMap;
    private list<SelectOption> poOptions;
    private list<Opportunity> poList;
    
    public TFOpportunityParentOpportunityController (ApexPages.StandardController controller){
        this.controller = controller;
        List<Opportunity> opps = [SELECT Id, Name, AccountId, Volume_Year__c, Parent_Opportunty__r.Name FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        if (opps.size() > 0) {
            this.obj = opps[0];
            volYear = obj.Volume_Year__c;
            tfParentOpp = obj.Parent_Opportunty__c; 
            tfParentOppName = obj.Parent_Opportunty__r.Name; 
            accId = obj.AccountId;
        }
    }
  
    public String volYear {
        get {
          if (volYear == null)
            volYear = '';
          return volYear;   
        }
        set;
    }
  
    public String tfParentOpp {
        get {
          if (tfParentOpp == null)
            tfParentOpp = '';
          return tfParentOpp;   
        }
        set;
    }
  
    public String tfParentOppName {
        get {
          if (tfParentOppName == null)
            tfParentOppName = '';
          return tfParentOppName;   
        }
        set;
    }
    
    public string accId {get; set;}

    public List<SelectOption> gettfParentOppOptions() {
        if (poList == null) {
            poOptions = new list<SelectOption>();
            poOptions.add(new SelectOption('','----NONE----'));
            poMap = new map<String, Opportunity>();
            poList = [SELECT Id, Name, Volume_Year__c
                      FROM Opportunity
                      WHERE RecordTypeId = '0120Y000000Wn9WQAS' AND Volume_Year__c = :volYear AND AccountId <> :AccId AND Id <> :ApexPages.currentPage().getParameters().get('id') ORDER BY Name];
            for (Opportunity parentOpp : poList) {
                poOptions.add(new SelectOption(parentOpp.Id,parentOpp.Name));
                poMap.put(parentOpp.Id, parentOpp);
            } 
        }
        return poOptions;
    }
  
    public Boolean isEditMode {
        get {
          if (isEditMode == null)
            isEditMode = false;
          return isEditMode;   
        }
        set;
    }
    
    public Boolean isDisplayMode {
        get {
          return !isEditMode;   
        }
        set;
    }  
    
    public Pagereference changeParentOpportunity() {
        isEditMode = true;
        return null;
    }
    
    public Pagereference updateParentOpp() { 
        
        //page to refresh to display latest parent opportunity value
        PageReference pr = ApexPages.CurrentPage();
        pr.setRedirect(true);
    
        if (tfParentOpp != null) {
            Opportunity parentOpp = poMap.get(tfParentOpp);         
            if (parentOpp != null && parentOpp.Id != null) {
                tfParentOppName = parentOpp.Name;
                obj.Parent_Opportunty__c = tfParentOpp;
                update obj;
            } else { //CHG0061269
                obj.Parent_Opportunty__c = null;
                update obj;
            }
        }    
        //leave edit mode
        isEditMode = false;
        
        //return null;
        return pr;
        
    }
    
    public Pagereference cancel() {
        isEditMode = false;
        return null;
    }  

}