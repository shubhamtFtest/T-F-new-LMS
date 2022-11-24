/*
* Created by Sourabh Goyal
* Calls: TF_CANADAUpdateEmailOptOut_Batch
* Tested by: zTEST_TF_CANADAUpdateEmailOptOut_Batch
* Summary : Sceduler for the batch class named TF_CANADAUpdateEmailOptOut_Batch
*/
global class TF_CANADAUpdateEmailOptOut_Schedule implements Schedulable {
    public Boolean isTesting = false;// used for test methods
    global boolean sendStatus = false;
    global void execute(SchedulableContext SC) {  
        TF_CANADAUpdateEmailOptOut_Batch tfBatch = new TF_CANADAUpdateEmailOptOut_Batch();
        
        if (isTesting)
            tfBatch.isTesting = true;
        
        Database.executeBatch(tfBatch,1);
    }
}