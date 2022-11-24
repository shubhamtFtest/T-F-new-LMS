/**************************************************
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
* This is a controller for the CAS_Inspection_Copy_Display
* Visualforce page to display the OpportunityLineItem
* as a link.
**************************************************/

public class CASInspectionCopyDisplayController {
	
    private ApexPages.StandardController controller {get; set;}	
    private CAS_Inspection_Copy__c ic;
    
    public String oliName {
        get {
            if (oliName == null) {
            	//oliName = [Select PricebookEntry.Name from OpportunityLineItem Where Id = :ic.Opportunity_Product__c].PricebookEntry.Name;
            	OpportunityLineItem[] oli = [Select PricebookEntry.Name from OpportunityLineItem Where Id = :ic.Opportunity_Product__c];
				if (oli.size() == 1)
					oliName = oli[0].PricebookEntry.Name;
            }
            return oliName;
        }
        set;
    }
    
    public CASInspectionCopyDisplayController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.ic = (CAS_Inspection_Copy__c)controller.getRecord();
    }        

}