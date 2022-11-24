/*
Batch class created for WCE-5089 : Auto Roll Over Budget End Date on Account
Crated by Mindtree.com
Created on 18th August 2017
This will find the Accounts where Budget End Date = Today's date , 
and update Budget End Date = Budget End Date + 1 year
*/
global class TF_AutoRollBudgetEndDate_Batch implements Database.Batchable<Sobject> {
    
    private string query;
    global database.querylocator start(Database.BatchableContext BC)
    {
        Date todayDate = system.today();
        //prepare Account Query
        query = 'Select Id, Budget_End_Date__c from Account Where RecordtypeId IN (\'0120Y000000Wn4vQAC\', \'0120Y000000Wn63QAC\') AND Budget_End_Date__c <=: todayDate ';
        return Database.getQueryLocator(query); 
        
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        List<Account> accList = new List<Account>();
        for(sobject s : scope) {
            Date rollOcerDate = Date.ValueOf(s.get('Budget_End_Date__c')).addYears(1);
            s.put('Budget_End_Date__c' , rollOcerDate); // update Date to next year date
        }
        update scope; //update the Account records
        
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}