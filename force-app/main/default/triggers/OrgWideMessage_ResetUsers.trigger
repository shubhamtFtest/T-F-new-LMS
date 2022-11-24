/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-09-17
** NOTE: 
***************************************************************************/
trigger OrgWideMessage_ResetUsers on Org_Wide_Message__c (before update, before insert) 
{
	Set<Id> messageId = new Set<Id>();
	
	for (Org_Wide_Message__c owm: Trigger.new )
	{
		if(owm.Reset_Users__c == true)
		{
			owm.Reset_Users__c = false;
		
			if(System.Trigger.isUpdate)
			{
				messageId.Add(owm.Id);
			}
		}  
	}
	
	
	if(messageId.size() > 0)
	{
		List<Org_Wide_Message_History__c> updateMessageHistory = new List<Org_Wide_Message_History__c>();
		for (Org_Wide_Message_History__c owmh : [SELECT Id, Org_Wide_Message__c, User_Last_Login_Date__c, Verified_Message__c FROM Org_Wide_Message_History__c WHERE Verified_Message__c = true AND Org_Wide_Message__c IN :messageId  Order By CreatedDate]) 
		{
			
			updateMessageHistory.add(new Org_Wide_Message_History__c(id=owmh.Id, Verified_Message__c = false )) ;
			
		}
		
		
		if(updateMessageHistory.size() > 0)
		{
			update updateMessageHistory;
		}
	}
	
	
	
}