/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-09-17
** NOTE: 
***************************************************************************/
@isTest
private class zTEST_OrganizationMessage {
    
    @testSetup static void Settings() 
    {
        CreateApplicationBypass();   
	}
    
    static testMethod void UnitTest() 
    {
         
        User u1 = insertUser();
        // u1.Username = 'OWM1'+ u1.Username;
        // Update u1;
        
        User u2 = insertUser();
        // u2.Username = 'OWM2'+ u2.Username;
        // Update u2;
        
        List<Org_Wide_Message__c> owm = new List<Org_Wide_Message__c>();
        
        owm.add(new Org_Wide_Message__c(Enabled__c = true ,Message_Type__c = 'Warning',Message__c = 'BlA BLA BLA',Name = '1BlA BLA BLA',No_Button_Text__c= 'BlA BLA BLA',Reset_Users__c = false, Yes_Button_Text__c = 'BlA BLA BLA'));
        owm.add(new Org_Wide_Message__c(Enabled__c = true ,Message_Type__c = 'Danger',Message__c = 'BlA BLA BLA',Name = '2BlA BLA BLA',Reset_Users__c = false, Yes_Button_Text__c = 'BlA BLA BLA'));
        owm.add(new Org_Wide_Message__c(Enabled__c = true ,Message_Type__c = 'danger',Message__c = 'BlA BLA BLA',Name = '3BlA BLA BLA',Reset_Users__c = false, Yes_Button_Text__c = 'BlA BLA BLA'));
        
        insert owm;
        
        
        
        
        
        List<Org_Wide_Message_History__c> owmh = new List<Org_Wide_Message_History__c>();
        owmh.add(new Org_Wide_Message_History__c(Name =u1.Username,Org_Wide_Message__c=owm[0].Id,UpsertId__c=  owm[0].Id+ '|' +u1.Id, User_Last_Login_Date__c=System.now().addYears(-1),User__c=u1.Id,Verified_Message__c=false));
        owmh.add(new Org_Wide_Message_History__c(Name =u2.Username,Org_Wide_Message__c=owm[0].Id,UpsertId__c=  owm[0].Id+ '|' +u2.Id, User_Last_Login_Date__c=u2.LastLoginDate,User__c=u2.Id,Verified_Message__c=false));
        owmh.add(new Org_Wide_Message_History__c(Name =u1.Username,Org_Wide_Message__c=owm[1].Id,UpsertId__c=  owm[1].Id+ '|' +u1.Id, User_Last_Login_Date__c=u1.LastLoginDate,User__c=u1.Id,Verified_Message__c=false));
        owmh.add(new Org_Wide_Message_History__c(Name =u2.Username,Org_Wide_Message__c=owm[1].Id,UpsertId__c=  owm[1].Id+ '|' +u2.Id, User_Last_Login_Date__c=u2.LastLoginDate,User__c=u2.Id,Verified_Message__c=false));
        
        insert owmh;
        
        //Test OrgWideMessage_ResetUsers
        owm[0].Reset_Users__c = true; 
        Update owm[0];
        
        owmh[0].Verified_Message__c = true;
        Update owmh[0];
        
        owm[0].Reset_Users__c = true;
        Update owm[0];
        
        //OrgMessageRedirectController
        
        
        delete owmh[3];
        System.runAs(u2)
        {
            PageReference pref = Page.OrgMessageRedirect;
            
            Test.setCurrentPage(pref);
            OrgMessageRedirectController con = new OrgMessageRedirectController();
            
        }
        
        System.runAs(u1)
        {
            PageReference pref = Page.OrgMessageRedirect;
            Test.setCurrentPage(pref);
            OrgMessageRedirectController con = new OrgMessageRedirectController();
            
        }
        //OrganizationMessageController 
        
        System.runAs(u2)
        {
            PageReference pref = Page.OrganizationMessage ;
            
            Test.setCurrentPage(pref);
            OrganizationMessageController con = new OrganizationMessageController();
            con.yesSave();
        }
        
        delete owmh[2];
        System.runAs(u1)
        {
            PageReference pref = Page.OrganizationMessage ;
            Test.setCurrentPage(pref);
            OrganizationMessageController con = new OrganizationMessageController();
            con.noSave();
        }
        System.runAs(u1)
        {
            PageReference pref = Page.OrganizationMessage ;
            Test.setCurrentPage(pref);
            OrganizationMessageController con = new OrganizationMessageController();
            con.yesSave();
        }
        System.runAs(u1)
        {
            PageReference pref = Page.OrganizationMessage ;
            Test.setCurrentPage(pref);
            OrganizationMessageController con = new OrganizationMessageController();
            con.yesSave();
        }
        System.runAs(u1)
        {
            PageReference pref = Page.OrgMessageRedirect;
            Test.setCurrentPage(pref);
            OrgMessageRedirectController con = new OrgMessageRedirectController();
            
        }
    }
    
    public static User insertUser(){
        
        Organization o = [SELECT Country,Id,InstanceName,IsSandbox,Name,State FROM Organization limit 1]; 
        User u = new User(alias='test', email='test@example.com', firstname='Testing',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey=Userinfo.getLanguage(), 
                          localesidkey=Userinfo.getLocale(), country=o.Country,
                          timezonesidkey=Userinfo.getTimeZone().getID(),//'America/Los_Angeles',
                          username='test@example.com.informaplc' + system.now().second() + system.now().millisecond() + math.random(),
                          // Informa_Business_Unit__c='INFORMA USA INC',
                          profileid=system.UserInfo.getProfileId(), //System Administrator
                          
                          Active_Directory_Username__c='testinguser1' + system.now().second() + system.now().millisecond(),
                          Active_Directory_OU__c='ukcorplan');
        insert u;    
        return u;
    }
    
    public static void CreateApplicationBypass()
    {
        //Bypass Validation Rules
        List<Application_Bypass__c> applicationBypass =[Select Id,Bypass_Validation_Rules__c,SetupOwnerId from Application_Bypass__c WHERE SetupOwnerId=:UserInfo.getUserId()];
        if(applicationBypass.size() == 0)
        {
            applicationBypass.add(new Application_Bypass__c(Bypass_Validation_Rules__c=true,SetupOwnerId=UserInfo.getUserId()));
            insert applicationBypass;
        }                                     
    }
}