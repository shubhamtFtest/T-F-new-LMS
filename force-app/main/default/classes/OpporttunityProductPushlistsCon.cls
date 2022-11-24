/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-02-22
***************************************************************************/
public with sharing class OpporttunityProductPushlistsCon
{
	private List<T_F_GT_Pushlist_Mappings__c> push;
	private OpportunityLineItem oli;     
	
	public OpporttunityProductPushlistsCon(ApexPages.StandardController controller) 
	{        this.oli= (OpportunityLineItem)controller.getRecord();    }
	
	
	 public List<T_F_GT_Pushlist_Mappings__c> getPush()    
	 {         
	 	OpportunityLineItem oppProd = [Select o.PricebookEntryId, o.PricebookEntry.Product2Id from OpportunityLineItem o where o.id = :oli.id];
	 	 
	 	push = [Select Id, Name, Product__c, Product__r.Author__c, Product__r.Edition_Number__c, Product__r.ISBN__c, Product__r.Name, PROFILE_NAME__c, T_F_GT_Pushlists__r.Name from T_F_GT_Pushlist_Mappings__c  where Product__c = :oppProd.PricebookEntry.Product2Id ORDER BY CreatedDate DESC]; //where Product__c = :oppProd.PricebookEntry.Product2Id 
	 	   
	 	if (push==null || push.Size() == 0 )  return null; 
	 	            
	 	return push;    
	 }
}