/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-09-17
** NOTE: 
***************************************************************************/

public class OrganizationMessageController {
	
	public Boolean DisplayMessage {get;set;}
	public Boolean DisplayNoButton {get;set;}
	public Org_Wide_Message__c OrgWideMessage {get;set;}
	public User user {get;set;}
	public String AlertType {get;set;}
	//public String AlertText {get;set;}
	 
public OrganizationMessageController() 
{
	Set <Id> messageIdAgreed	= new  Set<Id>();
	
	user = [Select u.Username, u.SystemModstamp, u.Name, u.LastLoginDate, u.Id, u.FirstName, u.Email From User u where u.Id=:UserInfo.getUserId()];
	
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
	
	
	
	List<Org_Wide_Message__c> owm	= [SELECT Id, Name,Message__c,Message_Type__c, Reset_Users__c,No_Button_Text__c,Yes_Button_Text__c  FROM Org_Wide_Message__c WHERE Enabled__c=true AND Id NOT IN : messageIdAgreed order by CreatedDate ASC LIMIT 1];
	If (owm != null && owm.size() > 0)
	{	
		OrgWideMessage = owm[0];
		AlertType = 'info';
		DisplayNoButton = true;
		if (OrgWideMessage.No_Button_Text__c ==null)DisplayNoButton = false;
		if (OrgWideMessage.Yes_Button_Text__c ==null)OrgWideMessage.Yes_Button_Text__c = 'Okay';
		if(orgWideMessage.Message_Type__c == 'Danger')
		{
			AlertType = 'danger';
		}
		else if(orgWideMessage.Message_Type__c == 'Warning')
		{
			AlertType = 'warning';
		}
		
		DisplayMessage = true;
		
		
	} 
	else
	{	OrgWideMessage = new Org_Wide_Message__c();
		DisplayMessage = false;
	} 
	


}

	public PageReference yesSave() {
	PageReference pageRef = null;
	
	try{
	Org_Wide_Message_History__c owmh = new Org_Wide_Message_History__c();
	owmh.Org_Wide_Message__c = OrgWideMessage.Id;
	owmh.User__c= UserInfo.getUserId();
	owmh.Name = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
	owmh.Verified_Message__c = true;
	owmh.UpsertId__c =  owmh.Org_Wide_Message__c+ '|' +owmh.User__c;
	owmh.User_Last_Login_Date__c =user.LastLoginDate;
	upsert owmh UpsertId__c;
	pageRef = new PageReference('/home/home.jsp');
	pageRef.setRedirect(true);
}
catch(DmlException ex){
ApexPages.addMessages(ex);
}
return pageRef;
}

public PageReference noSave() {
	PageReference pageRef = null;
	
	try{
	Org_Wide_Message_History__c owmh = new Org_Wide_Message_History__c();
	owmh.Org_Wide_Message__c = OrgWideMessage.Id;
	owmh.User__c= UserInfo.getUserId();
	owmh.Name = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
	owmh.Verified_Message__c = false;
	owmh.UpsertId__c =  owmh.Org_Wide_Message__c+ '|' +owmh.User__c;
	owmh.User_Last_Login_Date__c =user.LastLoginDate;
	upsert owmh UpsertId__c;
	pageRef = new PageReference('/home/home.jsp');
	pageRef.setRedirect(true);
}
catch(DmlException ex){
ApexPages.addMessages(ex);
}
return pageRef;
}

}