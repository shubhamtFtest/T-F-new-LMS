/**************************************************
* Created by: Tom Reed: 2019-01-30
* Tested by: zTest_ProductAPI @100%
**************************************************/
global class ProductAPIReRunErrorsBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        Integer batchRecordCount = Integer.ValueOf([SELECT Batch_Record_Count__c FROM ProductAPISettings__c LIMIT 1].Batch_Record_Count__c);
        system.debug(batchRecordCount);
        string query = 'SELECT Long_Text_1__c FROM Setting_Item__c WHERE Checkbox_1__c = false';
            query+= ' AND Setting__r.Name = \'ProductAPI_ErrorLogs\' AND Text_3__c != null ORDER BY CreatedDate asc LIMIT ' + batchRecordCount;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Setting_Item__c> scope) {        
        for(Setting_Item__c si: scope){
            ProductAPI.runProductSync(String.ValueOf(si.Long_Text_1__c));
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
        //Delete out any errorLogs which have been successfully processed.
        List<Setting_Item__c> completedErrorLogsList = new List<Setting_Item__c>();
        for(Setting_Item__c si: [SELECT Id, checkbox_1__c FROM Setting_Item__c where setting__r.Name = 'ProductAPI_ErrorLogs' AND Checkbox_1__c = true limit 10000]){
            completedErrorLogsList.add(si);
        }
        if(completedErrorLogsList.size()>0){delete completedErrorLogsList;}
        
    }
}