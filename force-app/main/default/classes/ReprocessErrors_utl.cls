/***************************************************************************
* Created by: Tom Reed, 2020.01.29
* Tested By: zTest_SAP_BP_Service @ 97%
* **************************************************************************/
public class ReprocessErrors_utl {
    
    
    //Returns a list of error log itmes which need to be updated.
    @TestVisible
    public static void createErrorLogItem(
        String errorLogUniqueKey,
        String jsonBody,
        String requestURI,
        DateTime errorDateTime,
        String errorDetails,
        String errorType,
        String typeOfError,
        Error_Log_Items__c existingErrorLogItemRecord
    ){
        //Locate the correct record type for the type of error being stored.
        ID recordTypeId;
        if(typeOfError.toLowerCase() == 'api'){recordTypeId = [SELECT Id FROM RecordType 
                                                               WHERE DeveloperName = 'API_Error' AND sObjectType = 'Error_Log_Items__c' LIMIT 1].ID;}
        //Create a map of the error config records.
        Map<String, Error_Log_Configuration__c> errorTypeToConfigMap = new Map<String, Error_Log_Configuration__c>();
        for(Error_Log_Configuration__c elc: [SELECT Id, Error_Type__c, Only_Reprocess_Latest_For_Record__c FROM  Error_Log_Configuration__c]){
            errorTypeToConfigMap.put(elc.Error_Type__c.ToLowerCase(), elc);     
        }   
        
        //Don't store the error log if we don't have a related Error Log Config record.        
        if(errorTypeToConfigMap.ContainsKey(errorType.toLowerCase())){
            
            
            //If the stored record should be the lastest for the given record but we're not currently processing an existing error.
            List<Error_Log_Items__c> eliToUpsert = new List<Error_Log_Items__c>();
            if(errorTypeToConfigMap.get(errorType.ToLowerCase()).Only_Reprocess_Latest_For_Record__c && existingErrorLogItemRecord == null){
                for(Error_Log_Items__c eli: [SELECT Id FROM Error_Log_Items__c WHERE Unique_Key_For_Error__c =: errorLogUniqueKey]){
                    eli.Is_Latest_For_Record__c = false;
                    //Flag the error as resolved because we have stored a more recent record.
                    eli.Is_Resolved__c = true;
                    eli.Should_Attempt_Retry__c = false;
                    eliToUpsert.add(eli);
                }
                
            }
            
            //If we need to update an existing error log.
            if(existingErrorLogItemRecord != null){
                existingErrorLogItemRecord.Last_Error_DateTime__c = errorDateTime;
                existingErrorLogItemRecord.Error_Details__c = errorDetails;
                eliToUpsert.add(existingErrorLogItemRecord);         
            } else {          
                //Add the new Error Log Item.
                Error_Log_Items__c eli = new Error_Log_Items__c();
                eli.Is_Latest_For_Record__c = true;
                eli.Error_Log_Configuration__c = errorTypeToConfigMap.get(errorType.toLowerCase()).Id;
                eli.Unique_Key_For_Error__c = errorLogUniqueKey;
                eli.Error_DateTime__c = errorDateTime;
                eli.Last_Error_DateTime__c = errorDateTime;
                eli.Error_Details__c = errorDetails;
                eli.Should_Attempt_Retry__c = true;
                eli.RecordTypeId = recordTypeId;
                eli.JSON_Body__c = jsonBody;
                eli.RequestURI__c = requestURI;
                //If the JSON is blank just flag the record as resolved as we can't do anything with it.
                if(jsonBody == '' || jsonBody == null){
                    eli.Is_Resolved__c = true; eli.Should_Attempt_Retry__c = false;
                }
                eliToUpsert.add(eli);
            }
            if(eliToUpsert.size()>0){upsert eliToUpsert;}
        }
    }
    
    //Method will mark an existing errors for a list of particular error key if the request has subsequently been successful.
    @TestVisible
    public static void removeErrorsIfresolved(List<String> uniqueErrorKeyList, String ErrorType){
        List<Error_Log_Items__c> eliListToUpdate = new List<Error_Log_Items__c>();
        for(Error_Log_Items__c eli : [SELECT Is_Resolved__c, ID 
                                      FROM Error_Log_Items__c WHERE Unique_Key_For_Error__c in: uniqueErrorKeyList AND Error_Log_Configuration__r.Error_Type__c =: ErrorType]){
                                          eli.Is_Resolved__c = true;
                                          eliListToUpdate.add(eli);
                                      }
        if(eliListToUpdate.size()>0){update eliListToUpdate;}
    }
    
    public static Id enqueueScheduledJobForErrorLogConfig(Error_Log_Configuration__c errorLogConfigRecord){
        reprocessErrorsScheduled scheduledJob = new reprocessErrorsScheduled();
        DateTime ScheduledTime = system.now().addMinutes(Integer.ValueOf(errorLogConfigRecord.Schedule_Interval_Minutes__c));
        //system.debug(ScheduledTime.format('u'));
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String sch = '00 ' +  ScheduledTime.minute() + ' ' + ScheduledTime.hour() + ' ' + ScheduledTime.Day() + ' ' + ScheduledTime.Month() + ' ? ' + ScheduledTime.Year();
        
        String jobID = System.schedule('RerunAPIErrors: ' + errorLogConfigRecord.Error_Type__c + ': ' + ScheduledTime, sch, scheduledJob);
        return jobID;
    }
}