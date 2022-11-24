/**
Created by Sourabh Goyal. @26 July 2017
Usage:- Scheduler for the batch class TF_UpdateRec_Batch.
*/
global class scheduler_TF_UpdateContactsRec_Batch implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        TF_UpdateContactsRec_Batch b1 = new TF_UpdateContactsRec_Batch();
        ID batchprocessid = Database.executeBatch(b1,200); 
        //ID jobID = System.enqueueJob(b1);
         
    }
}