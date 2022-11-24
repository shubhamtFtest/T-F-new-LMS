//Note: Don't change the running class parameter when creating the error log config record. I've factored into that class not to run the a callout to an external
//API to prevent this test class accidently making a callout to a production api during testing. TR 2020-01-29.
@isTest
public class zTest_Reprocess_API_Errors_Process {
    
    public static String jsonString = getJSONString();

    @isTest
    public static void testAddingScheduledJob(){
        
        //Create an Error_Log_Configuration__c record.
        Error_Log_Configuration__c elc = noInsertErrorLogConfiguration('Test Error Type', 2, 'SAP_BP_Service');
        Insert elc;     
        
        //Commit a Error_Log_Items__c record before the trigger is enabled so the job doesn't run twice.
        ReprocessErrors_utl.createErrorLogItem(
            '12345', //errorLogUniqueKey
            jsonString, //jsonBody
            '/123456/generateBP/doPost', //RequestURI
            system.now(), //errorDateTime
            'Test Error', //errorDetails
            'Test Error Type', //errorType
            'api', //typeOfError
            null //existingErrorLogItemRecord
        ); 
        
        Error_Log_Items__c firstEli = [SELECT Id, Is_Latest_For_Record__c, Is_Resolved__c, Should_Attempt_Retry__c FROM Error_Log_Items__c LIMIT 1];
        
        //Commit a Error_Log_Items__c record before the trigger is enabled so the job doesn't run twice.
        ReprocessErrors_utl.createErrorLogItem(
            '12345', //errorLogUniqueKey
            jsonString, //jsonBody
            '/123456/generateBP/doPost', //RequestURI
            system.now(), //errorDateTime
            'Test Error', //errorDetails
            'Test Error Type', //errorType
            'api', //typeOfError
            firstEli //existingErrorLogItemRecord
        );         
        
        Id devRecordTypeId = Schema.SObjectType.Error_Log_Items__c.getRecordTypeInfosByName().get('API Error').getRecordTypeId();
        
        TriggerInterfaceHelper.runTrigger('Reprocess_Error_Log_Item_trig', 'Error_Log_Items__c', 1, 'ai,au', devRecordTypeId, null);           
        
        //Create an Error_Log_Items__c record.
        test.startTest();
        Error_Log_Items__c eli = new Error_Log_Items__c();
        ReprocessErrors_utl.createErrorLogItem(
            '12345', //errorLogUniqueKey
            jsonString, //jsonBody
            '/123456/generateBP/doPost', //RequestURI
            system.now(), //errorDateTime
            'Test Error', //errorDetails
            'Test Error Type', //errorType
            'api', //typeOfError
            null //existingErrorLogItemRecord
        ); 
        test.stopTest();        
        
        //Test that the utl class removes an error using a unique error key.
        ReprocessErrors_utl.removeErrorsIfresolved(new List<String>{'12345'}, 'Test Error Type');
        for(Error_Log_Items__c eliRecord: [SELECT Should_Attempt_Retry__c, Is_Resolved__c, Total_Retries_Attempted__c from Error_Log_Items__c]){
            system.assertEquals(true ,eliRecord.Is_Resolved__c);   
        }
    }
    
    @isTest
    public static void runFailure(){
        
        //Create an Error_Log_Configuration__c record.
        Error_Log_Configuration__c elc = noInsertErrorLogConfiguration('Test Error Type', 2, 'SAP_BP_Service');
        Insert elc;  
        
        //Create an Error_Log_Items__c record.
        test.startTest();
        Error_Log_Items__c eli = new Error_Log_Items__c();
        ReprocessErrors_utl.createErrorLogItem(
            '12345', //errorLogUniqueKey
            jsonString, //jsonBody
            '/123456/generateBP/doPost', //RequestURI
            system.now(), //errorDateTime
            'Test Error', //errorDetails
            'Test Error Type', //errorType
            'api', //typeOfError
            null //existingErrorLogItemRecord
        ); 
        
        reprocessErrorsBatch testBatch = new reprocessErrorsBatch();
        testBatch.configurationRecord = elc;
        database.executeBatch(testBatch);
        test.stopTest();
        
        //Check to see if the error log item was processed.
        eli = [SELECT Should_Attempt_Retry__c, JSON_Body__c, Is_Resolved__c, requestURI__c, Total_Retries_Attempted__c from Error_Log_Items__c limit 1];
        system.assertEquals(false, eli.Is_Resolved__c);
        system.assertEquals(true, eli.Should_Attempt_Retry__c);       
        system.assertEquals(1, eli.Total_Retries_Attempted__c);
        
        //Test that the utl class removes an error using a unique error key.
        ReprocessErrors_utl.removeErrorsIfresolved(new List<String>{'12345'}, 'Test Error Type');
        eli = [SELECT Should_Attempt_Retry__c, Is_Resolved__c, Total_Retries_Attempted__c from Error_Log_Items__c WHERE id =: eli.Id];
        system.assertEquals(true ,eli.Is_Resolved__c);
    }
    
    @isTest
    public static void runSuccess(){
        
        //Create an account to be used.
        Account testAccount = zTest_Shared.noinsertAccount(UserInfo.getUserId());
        testAccount.customer_Id__c = '123456';
        insert testAccount;
        
        //Create an Error_Log_Configuration__c record.
        Error_Log_Configuration__c elc = noInsertErrorLogConfiguration('Test Error Type', 2, 'SAP_BP_Service');
        Insert elc;  
        
        //Create an Error_Log_Items__c record.
        test.startTest();
        Error_Log_Items__c eli = new Error_Log_Items__c();
        ReprocessErrors_utl.createErrorLogItem(
            '12345', //errorLogUniqueKey
            jsonString, //jsonBody
            '/123456/generateBP/doPost', //RequestURI
            system.now(), //errorDateTime
            'Test Error', //errorDetails
            'Test Error Type', //errorType
            'api', //typeOfError
            null //existingErrorLogItemRecord
        ); 
        
        reprocessErrorsBatch testBatch = new reprocessErrorsBatch();
        testBatch.configurationRecord = elc;
        database.executeBatch(testBatch);
        test.stopTest();
        
        //We should have no error log items because the batch has successfully processed the request. We should have a BP record because the request was processed successfully.
        List<Error_Log_Items__c> eliList = new List<Error_Log_Items__c>();
        for(Error_Log_Items__c eliRecords: [SELECT Id FROM Error_Log_Items__c]){
            eliList.add(eliRecords);
        }
        List<SAP_BP__c> bpList = new List<SAP_BP__c>();
        for(SAP_BP__c bp: [SELECT Id FROM SAP_BP__c]){
            bpList.add(bp);
        }        
        system.assertEquals(0, eliList.size());
        system.assertEquals(1, bpList.size());    
    }
    
    public static Error_Log_Configuration__c noInsertErrorLogConfiguration(String errorType, Integer maxRetries, String reprocessClassName){
        Error_Log_Configuration__c elc = new Error_Log_Configuration__c();
        elc.Batch_Size__c=1;
        elc.Error_Type__c=errorType;
        elc.Is_Active__c=true;
        elc.Max_Retries__c=maxRetries;
        elc.Only_Reprocess_Latest_For_Record__c=true;
        elc.Reprocess_Class_Name__c=reprocessClassName;
        elc.Schedule_Interval_Minutes__c=1;
        return elc;
        
    }
    
    public static String getJSONString(){
        String jsonString;
        jsonString = '{';
        jsonString+='"houseNumber": "abc",';
        jsonString+='"addressLine1": "Test Street3",';
        jsonString+='"addressLine2": "Test Address Line 3",';
        jsonString+='"addressLine3": "Test Address Line 3",';
        jsonString+='"city": "",';
        jsonString+='"state": "Oxfordshire",';
        jsonString+='"country": "United Kingdom",';
        jsonString+='"countryCode": "UK",';
        jsonString+='"postalCode": "OX111STTTT",';
        jsonString+='"addressType": "ORGANISATION",';
        jsonString+='"contactType": "",';
        jsonString+='"firstName": "Tom",';
        jsonString+='"lastName": "Reed",';
        jsonString+='"title": "Mr",';
        jsonString+='"emailAddress": "tom.reed@tandf.co.uk",';
        jsonString+='"telephone": "07111212121",';
        jsonString+='"bpPartnerFunction": "SP",';
        jsonString+='"bpBusinessPartnerCategory": "2",';
        jsonString+='"taxRegistrationNumber": "",';
        jsonString+='"taxNumberCategory": "",';
        jsonString+='"source": "eCommerce",';
        jsonString+='"addressUseType": "Account Billing"';
        jsonString+='}';
        return jsonString;        
    }
}