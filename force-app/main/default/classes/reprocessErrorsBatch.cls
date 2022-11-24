/***************************************************************************
* Created by: Tom Reed, 2020.01.29
* Tested By: zTest_SAP_BP_Service @ 83%
* **************************************************************************/
global class reprocessErrorsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    global Error_Log_Configuration__c configurationRecord;
    List<Error_Log_Items__c> eliToUpdate = new List<Error_Log_Items__c>();
    String soqlString;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //Check to see if there are still records to be processed, if not don't run the remainder of the batch class.
        soqlString ='SELECT ID, JSON_Body__c, Total_Retries_Attempted__c, Last_Retry_DateTime__c,'; 
        soqlString +=' Should_Attempt_Retry__c, Is_Resolved__c, RequestURI__c FROM Error_Log_Items__c '; 
        soqlString +=' WHERE Should_Attempt_Retry__c = true AND Error_Log_Configuration__r.Error_Type__c =' + '\'' + configurationRecord.Error_Type__c + '\'';
        
        return Database.getQueryLocator(soqlString);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Error_Log_Items__c> scope) { 
        
        //Instanciate the class to be used to handle reprocessing.
        Type classType = Type.forName(configurationRecord.Reprocess_Class_Name__c);
        ReprocessErrors_Interface classInstance = (ReprocessErrors_Interface)classType.newInstance();
        
        for(Error_Log_Items__c eli: scope){

            //Don't process the record if the JSON body is blank as we can't do anything with it.
            if(eli.JSON_Body__c == null || eli.JSON_Body__c == ''){
                eli.Is_Resolved__c = true;  
            } else {
                try{ //Try-Catch so if reprocessing fails in the processing class we can still continue with updating the Error_Log_Items__c record.
                    //Call the "reprocessAPIErrors" method. If true is returned the reprocessing was successful.
                    if(classInstance.reprocessAPIErrors(eli)){
                        eli.Is_Resolved__c = true; 
                    }
                } catch (exception e) {
                    system.debug('Error Debug: '+e.getMessage());
                }
            }
            //Increment the total retries attempted.
            if(eli.Total_Retries_Attempted__c == null){eli.Total_Retries_Attempted__c = 0;} 
            eli.Total_Retries_Attempted__c=eli.Total_Retries_Attempted__c+1;
            eli.Last_Retry_DateTime__c = system.now();
            //If the total attempts has reached the max retry attemts flag the record so it doesn't get processed again.
            if(eli.Total_Retries_Attempted__c >= configurationRecord.Max_Retries__c){eli.Should_Attempt_Retry__c = false;}
            eliToUpdate.add(eli);
        }
        //Update the Error_Log_Items__c records once the batch has finished.
        if(eliToUpdate.size()>0){update eliToUpdate;}               
    }
    
    global void finish(Database.BatchableContext BC) {
        
        //Remove any errors which have been successfully processed.
        List<Error_Log_Items__c> eliToDelete = new List<Error_Log_Items__c>();
        for(Error_Log_Items__c eli: [SELECT Id 
                                     FROM Error_Log_Items__c 
                                     WHERE Is_Resolved__c = true AND Error_Log_Configuration__r.Error_Type__c =: configurationRecord.Error_Type__c]){
                                         eliToDelete.add(eli);   
                                     }
        
        if(eliToDelete.size()>0){delete eliToDelete;}
        
        //Remove the Next_Scheduled_Job_Id__c as it's finished running.
        configurationRecord.Next_Scheduled_Job_Id__c = '';
        update configurationRecord;
        
        List<Error_Log_Items__c> eliRecords = new List<Error_Log_Items__c>();
        soqlString ='SELECT ID, JSON_Body__c, Total_Retries_Attempted__c, Last_Retry_DateTime__c,'; 
        soqlString +=' Should_Attempt_Retry__c, Is_Resolved__c FROM Error_Log_Items__c '; 
        soqlString +=' WHERE Should_Attempt_Retry__c = true AND Error_Log_Configuration__r.Error_Type__c =' + '\'' + configurationRecord.Error_Type__c + '\'';        
        try{
            eliRecords = database.query(soqlString);
        } catch (exception e){
            system.debug('No records to process'); 
        }
        
        //Don't add another scheduled job if running a test.
        if(!Test.isRunningTest()){
        //Double check the Error Log Config record is still active.
        //If we still have errors to be processed enqueue another job.
        if([SELECT Is_Active__c FROM Error_Log_Configuration__c WHERE Id =: configurationRecord.Id].Is_Active__c){
            if(eliRecords.size()>0){
                configurationRecord.Next_Scheduled_Job_Id__c = ReprocessErrors_utl.enqueueScheduledJobForErrorLogConfig(configurationRecord);
                update configurationRecord;                
            }
        }
        }   
        
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        
        //then use the active job id and abort it
        system.abortJob(a.id);
    }
}