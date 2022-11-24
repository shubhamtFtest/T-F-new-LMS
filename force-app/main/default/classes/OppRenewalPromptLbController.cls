public with sharing class OppRenewalPromptLbController {
    private Opportunity opp;
    
    public Id renewalId { get; set; }
    
    public OppRenewalPromptLbController() {
      opp = [SELECT Id, Next_Renewal__c, CloseDate, Volume_Year__c, Start_Date__c, End_Date__c
               FROM Opportunity
               WHERE ID = :ApexPages.currentPage().getParameters().get('id')];

    }
    
    public Pagereference yesRenewal() {
        //Get OpportunityLineItem to clone
        List<OpportunityLineItem> olis = 
         [SELECT Id, OpportunityId, PricebookEntryId, Quantity, eBook_Order_Type__c,
            Start_Date__c, End_Date__c, Access__c, Trial_Start_Date__c, Trial_End_Date__c,
            Product_Type__c, Scheduled__c, Core_Subscription__c, Description,
            PricebookEntry.Product2.Family
          FROM OpportunityLineItem
          WHERE OpportunityId = :opp.Id];
          
        //Check for Product Family = netBase
        Boolean isNetBase = false;
        for (OpportunityLineItem oli : olis) {
            if (oli.PricebookEntry.Product2.Family == 'netBase')
                isNetBase = true; 
        }

        //Clone Opportunity
        sObject originalSObject = (sObject)opp;
        List<sObject> originalSObjects = new List<sObject>{originalSObject};
        List<sObject> clonedSObjects = SObjectAllFieldCloner.cloneObjects(
                                      originalSobjects,
                                      originalSobject.getsObjectType());

        Opportunity clonedOpp = (Opportunity)clonedSObjects.get(0);
        clonedOpp.CloseDate = (opp.CloseDate == null ? null : opp.CloseDate.addYears(1)); //Add one year
        clonedOpp.Volume_Year__c = (opp.Volume_Year__c == null ? null : String.valueOf(Integer.valueOf(opp.Volume_Year__c) + 1)); //Add one year
        clonedOpp.Description = ''; //Description should be empty
        clonedOpp.StageName = 'Prospect';
        clonedOpp.Probability = 0;
        clonedOpp.Type = 'Renewal';
        clonedOpp.Start_Date__c = (opp.Start_Date__c == null ? null : opp.Start_Date__c.addYears(1)); //Add one year
        clonedOpp.End_Date__c = (opp.End_Date__c == null ? null : opp.End_Date__c.addYears(1)); //Add one year
        clonedOpp.Previous_Renewal__c = opp.Id;
        if (isNetBase) {
                if (test.isRunningTest())
                clonedOpp.OwnerId = '0050Y000002Ioqx'; //DRForce
            else
                clonedOpp.OwnerId = '0050Y000002IvXd'; //Samantha Rodriguez
        }
        insert clonedOpp;

        //Clone OpportunityLineItem
        List<OpportunityLineItem> clonedOlis = new List<OpportunityLineItem>();
        for (OpportunityLineItem oli : olis) {
            OpportunityLineItem clonedOli = oli.clone(false, true);
            clonedOli.OpportunityId = clonedOpp.Id;
            clonedOli.Start_Date__c = (oli.Start_Date__c == null ? null : oli.Start_Date__c.addYears(1)); //Add one year
            clonedOli.End_Date__c = (oli.End_Date__c == null ? null : oli.End_Date__c.addYears(1)); //Add one year
            clonedOli.Trial_Start_Date__c = (oli.Trial_Start_Date__c == null ? null : oli.Trial_Start_Date__c.addYears(1)); //Add one year
            clonedOli.Trial_End_Date__c = (oli.Trial_End_Date__c == null ? null : oli.Trial_End_Date__c.addYears(1)); //Add one year
            clonedOli.Description = ''; //Description should be empty
            clonedOli.UnitPrice = 0; //Zero price
            clonedOlis.add(clonedOli);
        }
        if (clonedOlis.size() > 0)
            insert clonedOlis;
        
        //Clone OpportunityContactRole
        List<OpportunityContactRole> ocrs = 
         [SELECT Id, ContactId, OpportunityId, Role, IsPrimary
          FROM OpportunityContactRole
          WHERE OpportunityId = :opp.Id];

        List<OpportunityContactRole> clonedOcrs = new List<OpportunityContactRole>();
        for (OpportunityContactRole ocr : ocrs) {
            OpportunityContactRole clonedOcr = ocr.clone(false, true);
            clonedOcr.OpportunityId = clonedOpp.Id;
            clonedOcrs.add(clonedOcr);
        }
        if (clonedOcrs.size() > 0)
            insert clonedOcrs;

        //Update old Opportunity
        opp.Next_Renewal__c = clonedOpp.Id;
        update opp;
        
        //set renewalId for redirect
        renewalId = clonedOpp.Id;

        return null;
    }

    public Pagereference noRenewal() {
        update opp; //changes LastModifiedDate, so not prompted again
        return null;
    }

}