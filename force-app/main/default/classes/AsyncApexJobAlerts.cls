/************************************************************************** 
** Modified by Shay Spoonmore - 2013-03-25
** Modified by Jeff Lup - 2017.07.17 - CHG0036218 - switched org url to informa.my
***************************************************************************/
public  class AsyncApexJobAlerts {
    
    
    public class CASAsyncApexJobQueue 
    {
        public String ApexClassId { get; set; }
        public Datetime CompletedDate { get; set; }
        public Datetime CreatedDate { get; set; }
        public String ExtendedStatus { get; set; }
        public String Status { get; set; }
        public String Id { get; set; }
        public String MethodName { get; set; }
        
        public CASAsyncApexJobQueue()
        {}
        
        public CASAsyncApexJobQueue(String apexClassId1,Datetime completedDate1,Datetime createdDate1, String extendedStatus1, String status1, String id1, String methodName1 )
        {
            ApexClassId = apexClassId1;
            CompletedDate = completedDate1;
            CreatedDate = createdDate1;
            ExtendedStatus = extendedStatus1;
            Status = status1;
            Id = id1 ;
            MethodName = methodName1; 
        }
    }
    
    
    public static void CAS_DeadMesagesQueue()
    {
        //Apex jobs only seem to keep history for around 10days
        //Build list of jobs that have already been reset because of the dead queue
            List<ApplicationProcessRunning__c> appsAlreadyReset = [Select a.ProcessLastRecord__c, a.Id, a.Name, a.ProcessRunning__c from ApplicationProcessRunning__c a where a.ProcessRunning__c = false and a.Name like 'CAS.%' and a.ProcessLastRecord__c != null order by a.CreatedDate desc limit 20];
            Set<String> appsJobsAlreadyReset = new Set<String>();
            system.debug('####appsAlreadyReset.Size():' + appsAlreadyReset.Size());
            for (ApplicationProcessRunning__c appAlreadyReset: appsAlreadyReset)
            {
                system.debug('####appsJobsAlreadyReset.Id:' + appAlreadyReset.Id);
                String apexJobId = appAlreadyReset.ProcessLastRecord__c;
                appsJobsAlreadyReset.add(apexJobId.Replace('ApexJobId:',''));
            }
        
        
        system.debug('####appsJobsAlreadyReset:' + appsJobsAlreadyReset);
        
        //List<AsyncApexJob> casEmailJobs = new List<AsyncApexJob>();
        
        List<AsyncApexJobAlerts.CasAsyncApexJobQueue> casAsyncApexJobQueue = new List<AsyncApexJobAlerts.CasAsyncApexJobQueue>();
        
        if(Test.isRunningTest())
        { 
            casAsyncApexJobQueue = TestCASAsyncApexJobQueue();
        }
        else
        {
            List<AsyncApexJob> casEmailJobs = [Select a.ApexClassId, a.ApexClass.Name, a.CompletedDate, a.CreatedById, a.CreatedDate, a.ExtendedStatus, a.Id, a.JobType, a.LastProcessed, a.LastProcessedOffset, a.MethodName, a.NumberOfErrors, a.ParentJobId, a.Status, a.TotalJobItems from AsyncApexJob a  where a.ApexClass.Name = 'CASEmail' and Status = 'failed' and a.CreatedDate = LAST_N_DAYS:3 and a.Id NOT IN :appsJobsAlreadyReset order by a.CreatedDate desc];
            for (AsyncApexJob aaj: casEmailJobs)
            {
                //casAsyncApexJobQueue.add(new CasAsyncApexJobQueue(ApexClassId=String.ValueOf(aaj.ApexClassId), CompletedDate=aaj.CompletedDate, ExtendedStatus=aaj.ExtendedStatus, Status=aaj.Status, Id=String.ValueOf(aaj.Id), MethodName = aaj.MethodName  ));
                 
           
                casAsyncApexJobQueue.add(new AsyncApexJobAlerts.CasAsyncApexJobQueue(String.ValueOf(aaj.ApexClassId), aaj.CompletedDate, aaj.CreatedDate, aaj.ExtendedStatus, aaj.Status, String.ValueOf(aaj.Id), aaj.MethodName  ));
                
            }
            
        
        }
        
        
        String emailMessage = '';
        set<string> failedMethods = new set<string>();
        Map<String,String> methodStatus = new Map<String,String>();
        Map<String,String> methodJobId = new Map<String,String>();
        
        system.debug('####casAsyncApexJobQueue.size():' + casAsyncApexJobQueue.size());
        for (casAsyncApexJobQueue casEmailJob: casAsyncApexJobQueue)
        {
            
            system.debug('####Failed: casEmailJob.MethodName:' + casEmailJob.MethodName);
            
            String apexJobInfo = 'APEX JOB: ' + casEmailJob.MethodName + '; ' + casEmailJob.Id + '; ' + casEmailJob.CreatedDate + '; ' + casEmailJob.ExtendedStatus;
            String apexJobId = 'ApexJobId:' + casEmailJob.Id ;
            emailMessage = emailMessage + '\n\r' + apexJobInfo ;
            String runningName = 'CAS.' + casEmailJob.MethodName;
            system.debug('####apexJobInfo:' + apexJobInfo);
            if (casEmailJob.MethodName == 'SendEmailInProcess')
            {
            
                failedMethods.add(runningName + '.true');
                methodStatus.put(runningName + '.true',apexJobInfo);
                methodJobId.put(runningName + '.true',apexJobId );
                
                failedMethods.add(runningName + '.false');
                methodStatus.put(runningName + '.false',apexJobInfo);
                methodJobId.put(runningName + '.false',apexJobId );
            }
            else
            {
            
            failedMethods.add(runningName);
            methodStatus.put(runningName,apexJobInfo);
            methodJobId.put(runningName,apexJobId );
            }
        }
        
        
        if (failedMethods.size() > 0)
        {
            
            
            
            //Build list of jobs that need reset because of dead queue
            List<ApplicationProcessRunning__c> appsRunning= [Select a.Error_Message__c, a.Id, a.Name, a.ProcessRunning__c from ApplicationProcessRunning__c a where  a.ProcessRunning__c = true and a.Name=:failedMethods order by a.CreatedDate desc limit 20];
            List<ApplicationProcessRunning__c> updateAppsRunning = new List<ApplicationProcessRunning__c>();
            
            system.debug('####appsRunning.Size():' + appsRunning.Size());
            
            for (ApplicationProcessRunning__c appRunning: appsRunning)
            {
                String errorMessage = '';
                if (methodStatus.get(appRunning.Name) != null)
                {
                 errorMessage= methodStatus.get(appRunning.Name);
                
                    if(errorMessage.length() >= 255)
                    {
                        errorMessage = errorMessage.substring(0, 254);
                    }
                
                }
                
                updateAppsRunning.add(new ApplicationProcessRunning__c(Id=appRunning.Id, Error_Message__c=errorMessage,ProcessRunning__c=false, ProcessLastRecord__c= methodJobId.get(appRunning.Name)));
                
            }
            
            if (updateAppsRunning.size() > 0)           {
                update updateAppsRunning; 
                //send email
                //CASEmail casEmail = new CASEmail();
                CASEmail.SendErrorEmail('Shay.Spoonmore@informaUSA.com','CAS EMAIL - APEX JOB DEAD QUEUE',System.Now() + emailMessage + '\n\r\n\r' + 'https://informa.my.salesforce.com/a1p?div_filter=&fcf=00B60000006ioKH' );
            
            
            }
            
        }
        
        
        
    }
    
     public static List<CASAsyncApexJobQueue> TestCASAsyncApexJobQueue ()
        {
        List<CASAsyncApexJobQueue> x = new List<CASAsyncApexJobQueue >();
        /*
        x.add(new CASAsyncApexJobQueue('01p600000000B23AAE', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdcAAAR','SendEmailFeedBackShortForm' ));
        x.add(new CASAsyncApexJobQueue('01p600000000B23AAE', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue', 'Failed' ,'7076000000TvdWsAAJ','SendEmailFeedBack' ));
        x.add(new CASAsyncApexJobQueue('01p600000000B23AAE', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdWtAAJ','SendEmailFeedBackSingapore' ));
        x.add(new CASAsyncApexJobQueue('01p600000000B23AAE', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdWqAAJ','SendEmailInProcess' ));
        x.add(new CASAsyncApexJobQueue('01p600000000B23AAE', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TtvsrAAB','SendEmailFeedBackFollowUp' ));
		*/
        x.add(new CASAsyncApexJobQueue('01p0Y00000Nk3tL', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdcAAAR','SendEmailFeedBackShortForm' ));
        x.add(new CASAsyncApexJobQueue('01p0Y00000Nk3tL', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue', 'Failed' ,'7076000000TvdWsAAJ','SendEmailFeedBack' ));
        x.add(new CASAsyncApexJobQueue('01p0Y00000Nk3tL', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdWtAAJ','SendEmailFeedBackSingapore' ));
        x.add(new CASAsyncApexJobQueue('01p0Y00000Nk3tL', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TvdWqAAJ','SendEmailInProcess' ));
        x.add(new CASAsyncApexJobQueue('01p0Y00000Nk3tL', System.Now(), System.Now(), 'Message could not be processed and ended up in dead message queue','Failed' ,'7076000000TtvsrAAB','SendEmailFeedBackFollowUp' ));
        return x;
     }
     
     

    
    

}