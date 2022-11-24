/*
Schedule class created for WCE-5089 : Auto Roll Over Budget End Date on Account
Crated by Mindtree.com
Created on 21st August 2017
*/
global class TF_AutoRollBudgetEndDate_Schedule implements Schedulable {
   global void execute(SchedulableContext sc) {
        // execute the batch class
        TF_AutoRollBudgetEndDate_Batch b = new TF_AutoRollBudgetEndDate_Batch(); 
        database.executebatch(b);
   }
}