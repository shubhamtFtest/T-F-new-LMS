/**************************************************
* 
* Last Modified by Shay.Spoonmore@informausa.com - 2015.02.10
* 
**************************************************/
public class CASFeedbackVerifiedController 
{
	public CAS_Inspection_Copy__c ic {get; set;}
	 public CASFeedbackVerifiedController()
	 {
    	
    	if (ApexPages.currentPage().getParameters().get('id') != null) 
    	{
    		
    		List<CAS_Inspection_Copy__c> records = [Select  c.OwnerId, c.Opportunity__c, c.Opportunity_Product__c, 
    			c.Id, c.ISBN__c,c.Opportunity__r.Owner.Name,c.Opportunity__r.Owner.Email
    			From CAS_Inspection_Copy__c c Where Id = :ApexPages.currentPage().getParameters().get('id')];
    			
    			
    			 
    		if (records.size() > 0)
    			ic = records.get(0); 

    	}
        
    } 
    
    public String OpportunityOwner 
    {
		get {
			if (ic.Opportunity__c != null)
			{
				User u = ic.Opportunity__r.Owner;
			
				return u.Name;
			}
			else
				return '';
		}
		set;
	}
	
	public String OpportunityOwnerEmail 
    {
		get {
			if (ic.Opportunity__c != null)
			{
				User u = ic.Opportunity__r.Owner;
			
				return u.Email;
			}
			else
				return '';
		}
		set;
	}
    
    public PageReference isValidId(){
	    if (ic == null) 
	    {
	    	PageReference newRef = Page.ICHome;
	    	newRef.setRedirect(true);
	    	return newRef;
	    } 
	    else
	    return null;
	  
    } 
    

}