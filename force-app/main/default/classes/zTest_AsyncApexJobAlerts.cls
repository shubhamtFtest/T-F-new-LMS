/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-03-25
** 
***************************************************************************/
@isTest
public with sharing class zTest_AsyncApexJobAlerts {

  static testMethod void CAS_DeadMesagesQueue()
    {
        List<ApplicationProcessRunning__c> apr = ApplicationProcessRunning();
        insert apr;
        
        AsyncApexJobAlerts.CASAsyncApexJobQueue caajb = new AsyncApexJobAlerts.CASAsyncApexJobQueue(); 
        
        AsyncApexJobAlerts.CAS_DeadMesagesQueue();
        
        
         
    // Schedule the test job
    	Test.startTest(); 
    	CAS_DeadMesagesQueueSchedule m = new CAS_DeadMesagesQueueSchedule();
    	String sch = '20 30 8 10 2 ?';
		System.schedule('Test_CAS_DeadMesagesQueueSchedule',sch, m);
		Test.stopTest();
    
        
        
        
    }

	public static List<ApplicationProcessRunning__c> ApplicationProcessRunning()
    	{
        List<ApplicationProcessRunning__c> x = new List<ApplicationProcessRunning__c>();
 
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = false ,ProcessLastRecord__c ='ApexJobId:7076000000TvdcAAAR',Name='CAS.SendEmailFeedBackShortForm' ));
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = true ,ProcessLastRecord__c =Null,Name='CAS.SendEmailFeedBackShortForm' ));
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = true,ProcessLastRecord__c =Null,Name='CAS.SendEmailFeedBack' ));
       	x.add(new ApplicationProcessRunning__c(ProcessRunning__c = true,ProcessLastRecord__c =Null,Name='CAS.SendEmailFeedBackSingapore' ));
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = true ,ProcessLastRecord__c =Null,Name='CAS.SendEmailInProcess.false' ));
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = true ,ProcessLastRecord__c =Null,Name='CAS.SendEmailFeedBackFollowUp' ));
        x.add(new ApplicationProcessRunning__c(ProcessRunning__c = false ,ProcessLastRecord__c =Null,Name='CAS.SendEmailInProcess.true' ));
        return x;
     }


}