/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-09-17
** NOTE: 
***************************************************************************/

public  class OrgMessageRedirectController {

public Boolean DisplayRedirect {get;
set;
}
public OrgMessageRedirectController() 
{
	Set <Id> messageIdAgreed	= new  Set<Id>();
	
	User user = [Select u.Username, u.SystemModstamp, u.Name, u.LastLoginDate, u.Id, u.FirstName, u.Email From User u where u.Id=:UserInfo.getUserId()];
	
	for (Org_Wide_Message_History__c owmh : [SELECT Org_Wide_Message__c, User_Last_Login_Date__c, Verified_Message__c FROM Org_Wide_Message_History__c WHERE  User__c =:UserInfo.getUserId() Order By CreatedDate]) 
	{
		Datetime userLastLoginDate = user.LastLoginDate;
		if(user.LastLoginDate != null)userLastLoginDate = userLastLoginDate.addMinutes(-1);
		
		System.debug(owmh.User_Last_Login_Date__c +' < ' +userLastLoginDate);
		if (!(owmh.User_Last_Login_Date__c < userLastLoginDate && owmh.Verified_Message__c == false))
		{
			messageIdAgreed.add(owmh.Org_Wide_Message__c);
		}
	}
	
	
	List <Org_Wide_Message__c> messageIdNotAgreed	= [SELECT Id FROM Org_Wide_Message__c WHERE Enabled__c=true AND Id NOT IN : messageIdAgreed];
	
	If (messageIdNotAgreed.size() >0)
	{
		DisplayRedirect = true; 
	} 
	else
	{
		DisplayRedirect = false;
	}
}
}