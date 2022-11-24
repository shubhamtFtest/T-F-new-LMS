public with sharing class OppRenewalPromptController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;

    public OppRenewalPromptController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
    
    public Boolean getShowPrompt() {
      if (opp.Next_Renewal__c == null) { //Not already renewed
            List<OpportunityHistory> history = [SELECT Probability, CreatedDate
                                                FROM OpportunityHistory
                                                WHERE OpportunityId = :opp.Id
                                                    AND CreatedDate = :opp.LastModifiedDate //just changed
                                                    AND Probability = 100 //Closed Won 
                                                LIMIT 1];
            if (history.size() > 0)
                return true;
            else
                return false;
      } else
          return false;
    }

}