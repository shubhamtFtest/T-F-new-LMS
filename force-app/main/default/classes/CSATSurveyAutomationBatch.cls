/**************************************************
* Created by: Tom Reed: 2018-12-10
* Tested by: zTest_CSATSurveyAutomation @ 96%
**************************************************/
global class CSATSurveyAutomationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        CSAT_Configuration__c csat_Configuration = [SELECT Contact_Exclusion_Range__c
                                                    , Run_in_Sandboxes__c
                                                    , Closed_Date_Range__c
                                                    , Closed_Date_Range_Length__c
                                                    FROM CSAT_Configuration__c LIMIT 1];
        
        Boolean isRunningInSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        
        //Only run if the code is in production or has been set to allowed to run in a sandbox.
        string query= '';
        
        //If a test is running select the test case as the ClosedDate field is not writeable to be able to create a test case that has been closed for 6 days.
        
        if(isRunningInSandbox == false || csat_Configuration.Run_in_Sandboxes__c == true){ 
            
            String queryString = '';
            Integer loopCount = 0;
            for(Setting_Item__c si: [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.Name='CSATSurveyRules - RecordType Inclusion List']){
                
                String tempString = '';
                
                if(loopCount == 0){
                tempString = ' RecordType.Name = \'' + si.Text_1__c +'\'';    
                } else {
                tempString = ' OR RecordType.Name = \'' + si.Text_1__c +'\'';
                }
                queryString += tempString;   
                loopCount++;
            }
            
            //Set the range on how long the cases should have been closed for.
            //+1 to the date supplied because the value returned has a time of 00:00, so the code looks for any cases closed at the end of the day rather than the beginning.
            datetime dateValueStart = system.Today().adddays(Integer.ValueOf((-1*csat_Configuration.Closed_Date_Range__c)+1));
            system.debug(dateValueStart);
            datetime dateValueEnd = system.Today().adddays(Integer.ValueOf(-1*csat_Configuration.Closed_Date_Range__c) + Integer.ValueOf(-1*csat_Configuration.Closed_Date_Range_Length__c));
            system.debug(dateValueEnd);
            
            //Query for any cases which have been closed for x days, Ready_For_CSAT__c = False and don't have the record types outlined below.
            
            query = 'SELECT Id, Ready_for_CSAT_Survey__c';
            query+= ' FROM CASE WHERE Ready_For_CSAT_Survey__c = False';
            query+= ' AND ClosedDate < ' + dateValueStart.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') ;
            query+= ' AND ClosedDate > ' + dateValueEnd.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') ;
            query+=' AND (';
            query+=queryString;
            query+=')';
            /*
            query+= ' AND RecordType.Name != \'T&F - PROD Online Content Checking\'';
            query+= ' AND RecordType.Name != \'Platform Support\'';
            query+= ' AND RecordType.Name != \'T&F - PROD Reprints\' AND RecordType.Name != \'Salesforce Internal Support\'';
			*/
            query+= ' AND (Status = \'Closed\' OR Status = \'Closed - Re-Opened Case\' OR Status = \'Closed - Completed\')';
            system.debug(query);
            
        } else {
            query = 'SELECT Id FROM CASE WHERE Subject = \'This will return no results\'';
        }

        if(test.isRunningTest()){
            query = 'SELECT Id, Ready_for_CSAT_Survey__c FROM Case WHERE Subject = \'Test for zTest_CSATSurveyAutomation\'';                            
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope) {        
        List<Id> caseIds = new List<Id>();
        for(Case c: Scope){
            system.debug(c);
            caseIds.add(c.Id);
        }
        if(caseIds.size()>0){
            CSATSurveyAutomation.CSATSurveyAutomation(caseIds);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}