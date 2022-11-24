/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-02-22
***************************************************************************/
public with sharing class OpporttunityPushlistsCon {

	private List<T_F_GT_Pushlist_Mappings__c> push;
	private Opportunity opp;     
	
	public OpporttunityPushlistsCon(ApexPages.StandardController controller) 
	{        this.opp= (Opportunity)controller.getRecord();    }
	
	
	 public List<T_F_GT_Pushlist_Mappings__c> getPush()    
	 {   //OpportunityLineItem oppProd       
	 	Set<Id> prodIds = new Set<Id>();
	 	
	 	for (OpportunityLineItem oli :[Select o.PricebookEntry.Product2Id from OpportunityLineItem o where o.OpportunityId = :opp.id])
	 	{prodIds.add(oli.PricebookEntry.Product2Id);
	 	}
	 	
	 	push = [Select Id, Name, Product__c, Product__r.Author__c, Product__r.Edition_Number__c, Product__r.ISBN__c, Product__r.Name, PROFILE_NAME__c, T_F_GT_Pushlists__r.Name from T_F_GT_Pushlist_Mappings__c where Product__c = :prodIds ORDER BY CreatedDate DESC]; //where Product__c = :prodIds 
	 	   
	 	if (push==null || push.Size() == 0 )  return null; 
	 	            
	 	return push;    
	 }


}