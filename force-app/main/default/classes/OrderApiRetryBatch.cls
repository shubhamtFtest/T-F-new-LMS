/***************************************************************************
* Created by: Piyush Jain, 2019.10.14
* Tested By:
* Description: Retry Order API Call for failed Orders from Batch class Contaning errorLogs and the Json Body.
* NOTE: Although bulkified in most places this class is designed as per Order hub and Order Item is created with ISBN for product
* Extensive testing is needed if the code is to be completely bulkified in future.
* **************************************************************************/

global class OrderApiRetryBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    String settingName = 'OrderApi_Error_Logs';
    String query = 'SELECT Id, Text_3__c, Text_2__c, Long_Text_1__c FROM Setting_Item__c WHERE Setting__r.Name =: settingName';
    
    // ----- getting list of failed Records  ------
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        return Database.getQueryLocator(query);
    }
    // ----- passing list of records to OrderAPI class containing jsonBody for reTry to create Order and OrderLineItem .------
    global void execute(Database.BatchableContext BC, List<Setting_Item__c> scope){
        
        if(!scope.isEmpty()){
            OrderAPI.reOrderApiResponse(scope);
        }       
    }
    // ----- Finish method .------
    global void finish(Database.BatchableContext BC){
        
    }
    
}