/************************************************************************** 
** Created by Shay Spoonmore (shay.spoonmore@informausa.com)20091102
** Last Modified by Jeff Lup - 2011.07.11
***************************************************************************/

public with sharing class ApplicationRunningProcess {

public static Boolean CheckProcessRunning(String appName) 
    {
        System.debug('*****CheckProcessRunning*****');
        
        Boolean runningProcess = true;
        
        LIST<ApplicationProcessRunning__c> CheckProcessRunning = [Select a.Name, a.ProcessRunning__c, a.SystemModstamp, a.ProcessCalled__c 
                                                                    from ApplicationProcessRunning__c a WHERE a.ProcessRunning__c = true
                                                                    AND a.Name=:appName ORDER BY a.SystemModstamp DESC LIMIT 1];

		//Reset old LeadRouting job which timed out - Jeff Lup
		if (CheckProcessRunning.size() > 0) {
			if (CheckProcessRunning[0].Name == 'LeadRouting' && (CheckProcessRunning[0].ProcessCalled__c).addHours(1) < datetime.now()) { //1 hour old
				CheckProcessRunning[0].ProcessRunning__c = false;
				update CheckProcessRunning[0];
				CheckProcessRunning = null;
			}
		}
       
        if( CheckProcessRunning == null || CheckProcessRunning.isEmpty())
        {
            System.debug('*****No Current Process Running*****');
            runningProcess = false;
            ApplicationProcessRunning__c insertAPR = new ApplicationProcessRunning__c(name=AppName,ProcessRunning__c= true ,ProcessCalled__c = System.now());
            insert(insertAPR);
            
        }
        
        
        return runningProcess;
        
    }
    
    public static void FinishProcessRunning(String appName, DateTime processStart) 
    {
        System.debug('*****FinishProcessRunning*****');
        
        ApplicationProcessRunning__c fp = [Select Id, Name, ProcessRunning__c, SystemModstamp 
                                                    from ApplicationProcessRunning__c  WHERE ProcessRunning__c = true 
                                                    AND Name=:appName ORDER BY SystemModstamp DESC LIMIT 1];
        
        DateTime processFinish = System.now();
        fp.ProcessRunning__c = false;
        fp.ProcessStart__c = processStart;
        fp.ProcessFinished__c = processFinish;
        
        System.debug('*****FinishProcessRunning: fp.Id=' + fp.Id);
        System.debug('*****FinishProcessRunning: fp.ProcessRunning__c =' + fp.ProcessRunning__c);
        System.debug('*****FinishProcessRunning: fp.ProcessStart__c =' + fp.ProcessStart__c);
        System.debug('*****FinishProcessRunning: fp.ProcessFinished__c =' + fp.ProcessFinished__c);
        
        UPDATE(fp);
    }
    
    public static void TestProcessRunning() 
    {
        String appName = 'testApp';
        Boolean processRunning = CheckProcessRunning(appName);
        System.debug('*****ApplicationRunning= ' + appName + ':' + processRunning);
        
        if (!processRunning)
        {
            
            RunApplication();
        }
        
        
        
    }
    
    @future
    public static void RunApplication() 
    {
        
        System.debug('*****Running Process*****');
        DateTime processStart = System.now();
        
        for (Integer S = 0; S < 4; S++) 
        {
            System.debug(S);
            
            for (Integer ms = 0; ms < 1000; ms++) 
            {
                //System.debug(ms);
            }
            
            //for (USER u : [Select u.Alias, u.Annual_Quota__c, u.Budget_Region__c, u.CallCenterId, u.City, u.CommunityNickname, u.CompanyName, u.ContactId, u.Country, u.Country_List__c, u.CreatedById, u.CreatedDate, u.CurrencyIsoCode, u.Default_Owner__c, u.DefaultCurrencyIsoCode, u.DefaultDivision, u.DelegatedApproverId, u.Department, u.Direct_Phone__c, u.Division, u.Email, u.EmailEncodingKey, u.EmployeeNumber, u.ESBEnabled__c, u.Experience__c, u.Extension, u.Fax, u.FirstName, u.ForecastEnabled, u.Id, u.Industry_experience__c, u.Informa_Business_Unit__c, u.Informa_Business_Unit_Id__c, u.Is_a_mentor_coach__c, u.IsActive, u.IsPortalSelfRegistered, u.LanguageLocaleKey, u.Languages__c, u.LastLoginDate, u.LastModifiedById, u.LastModifiedDate, u.LastName, u.Legacy__c, u.Legacy_ID__c, u.LocaleSidKey, u.ManagerId, u.MobilePhone, u.Name, u.OfflinePdaTrialExpirationDate, u.OfflineTrialExpirationDate, u.oppty_approvals__c, u.Phone, u.PortalRole, u.PostalCode, u.ProfileId, u.Program_Certifications__c, u.ReceivesAdminInfoEmails, u.ReceivesInfoEmails, u.Region__c, u.Reports_To__c, u.Sales_Code__c, u.Sales_Region__c, u.SAP_ID__c, u.State, u.State_List__c, u.Street, u.System_ID__c, u.SystemModstamp, u.TimeZoneSidKey, u.Title, u.Type__c, u.Username, u.UserPermissionsAvantgoUser, u.UserPermissionsCallCenterAutoLogin, u.UserPermissionsMarketingUser, u.UserPermissionsMobileUser, u.UserPermissionsOfflineUser, u.UserPermissionsSFContentUser, u.UserPreferencesActivityRemindersPopup, u.UserPreferencesApexPagesDeveloperMode, u.UserPreferencesEventRemindersCheckboxDefault, u.UserPreferencesReminderSoundOff, u.UserPreferencesTaskRemindersCheckboxDefault, u.UserRoleId, u.UserType, u.YTD_Revenue__c from User u
            //                ORDER BY SystemModstamp DESC limit 10]) {
                // Your code
            //}
            
        }
        
        String appName = 'testApp';
        
        FinishProcessRunning(appName,processStart);
        //FinishProcessRunning('ShayApp',System.now());
        
    }



}