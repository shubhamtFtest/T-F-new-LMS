/***************************************************************************
* Created by: Tom Reed, 2020.01.29
* Tested By: zTest_SAP_BP_Service @ 100%
* **************************************************************************/
global class reprocessErrorsScheduled implements Schedulable {
    
    global void execute(SchedulableContext SC) {
  
        //Query for the error confif record which relates to the running job.
        Error_Log_Configuration__c configurationRecord = [SELECT Total_Records_Currently_In_Error__c, Next_Scheduled_Job_Id__c, Batch_Size__c, Reprocess_Class_Name__c,
                                                          Error_Type__c, Max_Retries__c, Schedule_Interval_Minutes__c
                                                          FROM Error_Log_Configuration__c WHERE Next_Scheduled_Job_Id__c =: String.ValueOf(SC.getTriggerId())];
        
        //If there are currently errors relating to the config record create a batch class to run.
        if(configurationRecord.Total_Records_Currently_In_Error__c >0){
            reprocessErrorsBatch batchRun = new reprocessErrorsBatch();
            batchRun.configurationRecord = configurationRecord;
            database.executebatch(batchRun, Integer.ValueOf(configurationRecord.Batch_Size__c)); 
        } else {
            configurationRecord.Next_Scheduled_Job_Id__c='';
            update configurationRecord;
        }
    }
}