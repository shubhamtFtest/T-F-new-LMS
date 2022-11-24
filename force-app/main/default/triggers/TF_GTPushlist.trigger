/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-02-22
***************************************************************************/
trigger TF_GTPushlist on T_F_GT_Pushlists__c (after insert, after update, after delete) 
{
	Set<String> profileIds = new Set<String>();
	List<T_F_GT_Pushlists__c> deletePushlists = new List<T_F_GT_Pushlists__c>();
	
	
	if(Trigger.isDelete)
	{
		
		for (Integer i=0;i<Trigger.old.size();i++) 
		{
			
				profileIds.add(Trigger.old[i].SEL_ID_PROFILE__c); 
				//deletePushlists.add(new T_F_GT_Pushlists__c(Id = Trigger.new[i].Id));
			
		}
		
	}
	else
	{
		for (Integer i=0;i<Trigger.new.size();i++) 
		{
			
			if ( Trigger.new[i].Process__c == 'D')
			{
				profileIds.add(Trigger.new[i].SEL_ID_PROFILE__c); 
				deletePushlists.add(new T_F_GT_Pushlists__c(Id = Trigger.new[i].Id));
			}
			
			
		}
	
	}
	
	
	
		if(profileIds.Size()> 0)
		{
			
			List<T_F_GT_Pushlist_Mappings__c> pushlistMappings= [SELECT Id FROM T_F_GT_Pushlist_Mappings__c WHERE NAME IN :profileIds]; 
			
			if(pushlistMappings.Size()> 0)
			{
				delete pushlistMappings;
			}
		
		
			if(!Trigger.isDelete && deletePushlists.Size()> 0)
			{delete deletePushlists;}
		
		}

	
}