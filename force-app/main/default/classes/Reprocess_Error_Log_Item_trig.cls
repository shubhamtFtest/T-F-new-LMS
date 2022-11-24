/***************************************************************************
* Created by: Tom Reed, 2020.01.29
* Tested By: zTest_SAP_BP_Service @ 100%
* **************************************************************************/

public with sharing class Reprocess_Error_Log_Item_trig implements TriggerInterface_Error_Log_Items.Runnable {
    public void run(TriggerInterface_Error_Log_Items.Trig trig) {
        
        //As we're storing an error log item we must also check to see if a scheduled job is already in the pipeline.
        
        List<Error_Log_Configuration__c> recordsToUpdate = new List<Error_Log_Configuration__c>();
        Set<String> errorTypesProcessedSet = new Set<String>();
        for(Error_Log_Items__c eli : [SELECT Error_Log_Configuration__r.Is_Active__c, Error_Log_Configuration__r.Next_Scheduled_Job_Id__c, Should_Attempt_Retry__c,
                                      Error_Log_Configuration__r.Error_Type__c, Error_Log_Configuration__r.Schedule_Interval_Minutes__c, Is_Resolved__c
                                      FROM Error_Log_Items__c WHERE Id in: trigger.NewMap.keyset()]){
                                          if(eli.Error_Log_Configuration__r.Is_Active__c == true 
                                             && (eli.Error_Log_Configuration__r.Next_Scheduled_Job_Id__c == '' || eli.Error_Log_Configuration__r.Next_Scheduled_Job_Id__c == null)
                                             && eli.Should_Attempt_Retry__c == true && eli.Is_Resolved__c == false
                                            ){                                            
                                                //Don't add the error log config record to be updated twice.
                                                if(!errorTypesProcessedSet.contains(eli.Error_Log_Configuration__r.Error_Type__c)){
                                                    eli.Error_Log_Configuration__r.Next_Scheduled_Job_Id__c = ReprocessErrors_utl.enqueueScheduledJobForErrorLogConfig(eli.Error_Log_Configuration__r);
                                                    errorTypesProcessedSet.add(eli.Error_Log_Configuration__r.Error_Type__c);
                                                    recordsToUpdate.add(eli.Error_Log_Configuration__r);
                                                }
                                            }
                                      }
        if(recordsToUpdate.size()>0){update recordsToUpdate;}
    } 
}